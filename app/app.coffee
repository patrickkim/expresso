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
load_config = require("#{__dirname}/../config/settings")
app_loader    = require("#{__dirname}/../app_loader")
settings    = load_config.settings

console.log "Application is starting...".green.bold
load_config(app, express, env)
app_loader.boot_up(app)

# -¥- APIs -¥-
server.listen settings.port, ->
  console.log "Express server listening on " + " port %d ".bold.red + " in " + " %s mode ".bold.green + " //", settings.port, env
  console.log "Using Express %s...", express.version.red.bold