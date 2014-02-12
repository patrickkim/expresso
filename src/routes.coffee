module.exports = (app) ->

  # Custom
  app.get '/', app.ApplicationController.index

  # # - _/_ -> controllers/index/index method
  # app.all '/', (req, res, next) ->
  #   route_mvc('index', 'index', req, res, next)

  # #   - _/**:controller**_  -> controllers/***:controller***/index method
  # app.all '/:controller', (req, res, next) ->
  #   route_mvc(req.params.controller, 'index', req, res, next)

  # #   - _/**:controller**/**:method**_ -> controllers/***:controller***/***:method*** method
  # app.all '/:controller/:method', (req, res, next) ->
  #   route_mvc(req.params.controller, req.params.method, req, res, next)

  # #   - _/**:controller**/**:method**/**:id**_ -> controllers/***:controller***/***:method*** method with ***:id*** param passed
  # app.all '/:controller/:method/:id', (req, res, next) ->
  #   route_mvc(req.params.controller, req.params.method, req, res, next)

  # # Error handling (No previous route found. Assuming it’s a 404)
  # app.get '/*', (req, res) ->
  #   resource_not_found(res)

  # -- 500 status
  app.use (err, req, res, next) ->
    console.log err
    res.status(500).send err

  # -- 404 status
  app.use (req, res, next) ->
    console.log "404"
    res.status(404).end()

  # == render the page based on controller name, method and id
  # TODO: might want to make this a module concern.
  resource_not_found = (res) ->
    res.render '404', status: 404, view: 'four-o-four'

  route_mvc = (controller_name, method_name, req, res, next) ->
    controller_name = 'index' if not controller_name?
    # controller = null
    # data = null

    try
      controller = require "./controllers/#{controller_name}"
    catch e
      console.warn "controller not found: #{controller_name}", e
      next()
      return

    if typeof controller[method_name] is 'function'
      action_method = controller[method_name].bind controller
      action_method req, res, next
    else
      console.warn 'method not found: ' + method_name
      next()
