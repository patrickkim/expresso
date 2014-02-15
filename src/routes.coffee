module.exports = (app) ->

  # Custom
  app.get '/', app.ApplicationController.index

  # == Standard MVC CRUD routes
  # _/_ -> controllers/index/index method
  app.all '/', (req, res, next) ->
    route_mvc('index', 'index', req, res, next)

  # _/#{controller_name}  -> controllers/#{controller_name}/index method
  app.all '/:controller', (req, res, next) ->
    route_mvc(req.params.controller, 'index', req, res, next)

  # _/#{controller_name}/#{method_name} -> controllers/#{controller_name}/#{method_name} method
  app.all '/:controller/:method', (req, res, next) ->
    route_mvc(req.params.controller, req.params.method, req, res, next)

  # _/#{controller_name}/#{method_name}/#{id} -> controllers/#{controller_name}/#{method_name} method with #{id} param passed
  app.all '/:controller/:method/:id', (req, res, next) ->
    route_mvc(req.params.controller, req.params.method, req, res, next)

  # Error handling (No previous route found. Assuming it’s a 404)
  app.get '/*', (req, res) ->
    resource_not_found(res)

  # == render the page based on controller name, method and id
  # TODO: might want to make this a module concern.
  resource_not_found = (res) ->
    res.render '404', status: 404, view: 'four-o-four'

  route_mvc = (controller_name, method_name, req, res, next) ->
    controller_name = 'index' if not controller_name?

    try
      controller = require "#{app.PATH["controllers"]}/#{controller_name}"
    catch e
      console.warn "[ERROR]".red + " controller not found:".grey + " '#{controller_name}'\n\n", e
      next()
      return

    if typeof controller[method_name] is 'function'
      action_method = controller[method_name].bind controller
      action_method req, res, next
    else
      console.warn "[ERROR]".red + "method not found: ".grey + "#{method_name}"
      next()
      
