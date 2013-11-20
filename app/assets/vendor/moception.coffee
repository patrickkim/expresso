window.Moception = {}

getValue = (object, prop) ->
  return null if (!(object && object[prop]))
  if _.isFunction(object[prop]) then object[prop]() else object[prop]

Moception.EventMixin =
  _prepare_event_router: ->
    @off('all', @_route_event)
    @on('all', @_route_event)

  _route_event: (event, data...) ->
    if @__parent # has_many/collection
      return unless namespaced_event = @_namespace_event(event, data)
      if @_event_is_whitelisted(event, @__parent)
        @__parent.trigger.apply(@__parent, [].concat(namespaced_event, data))

    if @__parents?.length # has_one/model
      return unless namespaced_event = @_namespace_event(event, data)
      for parent in @__parents
        if @_event_is_whitelisted(event, parent)
          parent.trigger.apply(parent, [].concat(namespaced_event, data))

  _namespace_event: (event, data) ->
    return unless @__event_namespace
    new_namespaces = []
    namespaces = event.split(':')
    if _(namespaces).contains(@__event_namespace) # don't cycle events
      return
    new_namespaces.concat(namespaces[0], @__event_namespace, namespaces[1..namespaces.length]).join(":")

  _event_is_whitelisted: (event, parent) ->
    return false if parent.__relations_hash[@__event_namespace].silence_events
    return true unless whitelist = parent.__relations_hash[@__event_namespace].event_whitelist
    _(whitelist).contains(event)

class Moception.Model extends Backbone.Model
  constructor: (attributes = {}, options = {}) ->
    # extracted (and translated to coffeescript) from Backbone.Model
    @relations ?= []
    attributes = @parse(attributes) if options.parse
    if (defaults = getValue(this, 'defaults'))
      attributes = _.extend({}, defaults, attributes)

    @collection = options.collection if options.collection
    @attributes = {}
    @_escapedAttributes = {}
    @cid = _.uniqueId('c')
    @changed = {}
    @_silent = {}
    @_pending = {}

    # addition to support relations
    @_prepare_relations(attributes)
    @set(attributes, {silent: true})
    @changed = {}
    @_silent = {}
    @_pending = {}
    @_previousAttributes = _.clone(this.attributes)

    @initialize(attributes, options)

  set: (key, value, options = {}) ->
    if _(key).isObject() || key == null
      attributes = key
      options = value
    else
      attributes = {}
      attributes[key] = value

    options ||= {}
    options.changes ||= {}

    attributes = @_process_has_many_attributes(attributes, options)
    attributes = @_process_has_one_attributes(attributes, options)

    this._change(options) unless options.silent #this will only trigger change events for has_one model swaps
    super(attributes, options)

  clear: ->
    [attributes, has_many_attributes] = @_extract_has_many_relations_attributes(@attributes)
    for key, value of has_many_attributes
      value.reset()

  toJSON: ->
    [base_json, has_many_relations] = @_extract_has_many_relations_attributes(@attributes)
    [base_json, has_one_relations] = @_extract_has_one_relations_attributes(base_json)
    relations = _(has_many_relations).extend(has_one_relations)
    for key in _(relations).keys()
      unless @__relations_hash[key].exclude_from_json
        base_json[key] = relations[key].toJSON()
    base_json

  fetch: ->
    @__active_request?.abort()
    @__active_request = super

  _change: (options)-> # triggers change events for changed attributes
    for name, value of options.changes
      this.trigger("change:#{name}", value)

  _get_relation: (name) ->
    _(getValue(this, 'relations')).find( (relation) -> relation.name == name )

  _prepare_has_one_model: (model, relation) ->
    model.__parents ||= []
    model.__parents.push(this) unless _(model.__parents).contains(this)
    model.__event_namespace = relation.name
    _(model).extend(Moception.EventMixin)
    unless relation.silence_events
      model._prepare_event_router()

  _remove_parent_reference: (model) ->
    model.__parents = _(model.__parents).without(this)

  _prepare_relations: (attributes = {}) ->
    for relation in getValue(this, 'relations')
      @__relations_hash ||= {}
      @__relations_hash[relation.name] = relation
      @_prepare_has_many_relations(relation)
      @_prepare_has_one_relations(relation)
      @_prepare_belongs_to_relations(relation)


  _prepare_has_many_relations: (relation) ->
    return unless relation.type == "has_many"
    collection = new relation.collection()
    @attributes[relation.name] = collection
    _(collection).extend(Moception.EventMixin)

    collection.__parent = this
    collection.__event_namespace = relation.name
    collection._prepare_event_router() unless relation.silence_events
    @[relation.name] = ->
      @get(relation.name)

  _prepare_has_one_relations: (relation) ->
    return unless relation.type == "has_one"
    @[relation.name] = ->
      @get(relation.name)

    return unless relation.delegates

    _(relation.delegates).each (method) =>
      @[method] = ->
        @[relation.name]()[method]()


  _prepare_belongs_to_relations: (relation) ->
    return unless relation.type == "belongs_to"
    @[relation.name] = ->
      if @collection?.__parent? && parent_relations = getValue(@collection.__parent, 'relations')
        parent_relation = _(parent_relations).find (rel) -> rel.inverse_of == relation.name
        if parent_relation
          @collection.__parent

      else if @__parents?
        _(@__parents).find (parent) ->
          _(getValue(parent, 'relations')).find (parent_relation) ->
            parent_relation.inverse_of == relation.name

    return unless relation.delegates

    _(relation.delegates).each (method) =>
      @[method] = ->
        @[relation.name]()[method]()

  _process_has_many_attributes: (attributes, options) ->
    [attributes, has_many_attributes] = @_extract_has_many_relations_attributes(attributes)
    for key in _(has_many_attributes).keys()
      if (attribute = has_many_attributes[key]) instanceof Backbone.Collection
        @get(key).set(attribute.models, {remove: false})
      else
        attribute = [attribute] unless _(attribute).isArray()
        (collection = @get(key)).set(attribute)
    attributes

  _process_has_one_attributes: (attributes, options) ->
    [attributes, has_one_attributes] = @_extract_has_one_relations_attributes(attributes)
    for key in _(has_one_attributes).keys()
      model = @_build_has_one_model(key, has_one_attributes)
      relation = @_get_relation(key)

      if (attribute = has_one_attributes[key]) instanceof Backbone.Model && attribute.id == model.id
        return if model == options.parent # cycle detection
        @_prepare_has_one_model(model, relation)
        model.set(has_one_attributes[key].attributes, parent: this)

      else if attribute instanceof Backbone.Model
        #basically, if you want to replace the model instance on a relation, you must provide a model object (with a different id)
        @_remove_parent_reference(model)
        model = has_one_attributes[key]
        @_prepare_has_one_model(model, relation)
        options.changes[key] = model # this is how we track a replacement of the has_one object

      else
        @_prepare_has_one_model(model, relation)
        model.set(has_one_attributes[key])

      @attributes[key] = model
    attributes

  _build_has_one_model: (relation_name, attributes) ->
    if @get(relation_name)
      @get(relation_name)
    else if attributes[relation_name] instanceof Backbone.Model
      attributes[relation_name]
    else
      klass = @_get_relation(relation_name).model
      new klass()

  _extract_has_many_relations_attributes: (attributes) ->
    @_extract_relations_attributes(attributes, 'has_many')

  _extract_has_one_relations_attributes: (attributes) ->
    @_extract_relations_attributes(attributes, 'has_one')

  _extract_relations_attributes: (attributes, relation_type) ->
    relations_attributes = {}
    for relation in getValue(this, 'relations')
      if attributes && attributes[relation.name] && relation.type == relation_type
        relations_attributes[relation.name] = attributes[relation.name]
    if attributes
      base_keys = _(_(attributes).keys()).difference(_(relations_attributes).keys())
      base_attributes = _(attributes).pick(base_keys)
    [base_attributes, relations_attributes]
