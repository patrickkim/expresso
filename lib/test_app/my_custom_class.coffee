# module.exports = (app) ->
#   # Your code
#
#
# Or if you want this to be a class
#
# module.exports = (app) ->
#   class app.MyCustomClass
#
#     constructor: (args) ->
#       # Your code
#
# Usage: new app.MyCustomClass(args)

module.exports = (app) ->

  log_errors: (err, req, res, next) ->
    console.error err.stack
    next err

  client_error_handler: (err, req, res, next) ->
    if req.xhr
      res.send 500,
        error: "Something blew up!"
    else
      next err