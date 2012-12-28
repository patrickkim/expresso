# -- Global settings
# change this to json formated loader..
settings =
  siteName: "yoursitename"
  sessionSecret: "sessionSecret"
  uri: "http://localhost" # Without trailing /
  port: process.env.PORT or 1337
  debug: 0
  profile: 0
  # HISTORY_LIMIT_MSG_NUMBER: 50

module.exports.base_settings = settings

###
# Default configuration manager
# Inject app and express reference
###
module.exports.env_settings = (app, express, env) ->
  require("./development") app, express  if env is "development"
  require("./production") app, express  if env is "production"

