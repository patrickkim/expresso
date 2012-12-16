# global require:false
# Module dependencies.
express = require "express"
http    = require "http"
# nano    = require('nano')('http://localhost:5984')
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
app_boot   = require("#{__dirname}/../config/boot")
settings   = app_config.settings

console.log "Application is starting...".green.bold
app_config(app, express, env)
app_boot.boot(app)

# -¥- APIs -¥-
server.listen settings.port, ->
  console.log "Express server listening on " + " port %d ".bold.red + " in " + " %s mode ".bold.green + " //", settings.port, env
  console.log "Using Express %s...", express.version.red.bold