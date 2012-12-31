_     = require "underscore"
redis = require("redis").createClient()

class Widget
  constructor: (options) ->
    @name = options.name
    @desc = options.desc
    console.log "new widget #{@name}"

  save: ->
    updated_at = Date.now()


    console.log "Saving Widget..."
    console.log @

    redis.incr "widget_id", (err, id) ->
      console.log "New Widget: #{id} "
      # redis.hset "widget:#{id}", "name", @name , "description", @description

    console.log "Tada! It's a new widget #{@name}!"

exports.Widget = Widget



# Share models on front and back?
# ->
#   server = false
#   models = undefined
#   if typeof exports isnt "undefined"
#     _ = require("underscore")._
#     Backbone = require("backbone")
#     models = exports
#     server = true
#   else
#     models = @models = {}