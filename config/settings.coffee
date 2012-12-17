# -- Global settings
settings =
  siteName: "yoursitename"
  sessionSecret: "sessionSecret"
  uri: "http://localhost" # Without trailing /
  port: process.env.PORT or 1337
  debug: 0
  profile: 0

  # App settings
  HISTORY_LIMIT_MSG_NUMBER: 50


###
Default configuration manager
Inject app and express reference
###
module.exports = (app, express, env) ->
  require("./environments/development") app, express  if env is "development"
  require("./environments/production") app, express  if env is "production"

module.exports.settings = settings