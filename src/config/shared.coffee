config = require "./config"

module.exports = (app, express) ->
  # -- Shared Settings
  app.settings.app_name = config.shared_settings.app_name
  app.ENV = process.env.NODE_ENV || "development"

  # Global paths
  app.PATH = {}
  app.PATH["config"]      = "#{__dirname}/config"
  app.PATH["static"]      = "#{__dirname}/../../public"
  app.PATH["assets"]      = "#{__dirname}/../../assets"
  app.PATH["lib"]         = "#{__dirname}/../lib"
  app.PATH["helpers"]     = "#{__dirname}/../helpers"
  app.PATH["models"]      = "#{__dirname}/../models"
  app.PATH["views"]       = "#{__dirname}/../views"
  app.PATH["controllers"] = "#{__dirname}/../controllers"
  app.PATH["routes"]      = "#{__dirname}/../routes"

  # Frontend Template compilation
  app.PATH["templates_path"] = "#{__dirname}../../assets/templates"

