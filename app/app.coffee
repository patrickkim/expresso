# global require:false 
# Module dependencies.
express = require "express"
http    = require "http"
nano    = require('nano')('http://localhost:5984')
#    async       = require('async')
#    request     = require('request')

# -- String utils
require "colors"
require "string-format"

# -- Create Express instance and export
app    = express()
env    = app.settings.env
server = http.createServer(app)

# -- Import configuration
app_config = require("#{__dirname}/../config/settings")
settings   = app_config.settings

console.log "Application is starting...".green.bold
app_config(app, express, env)

# -- Routes
require("#{__dirname}/routes")(app)

# -¥- APIs -¥-
server.listen settings.port, ->
  console.log "Express server listening on " + " port %d ".bold.inverse.red + " in " + " %s mode ".bold.inverse.green + " //", settings.port, env
  console.log "Using Express %s...", express.version.red.bold