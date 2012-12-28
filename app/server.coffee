# global require:false
# Module dependencies.
express  = require "express"
http     = require "http"
# request = require('request')

# -- String utils
require "colors"

# -- Create Express instance and export
app    = express()
env    = app.settings.env
server = http.createServer(app)

# -- Databases
# mongoose = require "mongoose"
# mongoose.connect('mongodb://localhost/nodesample-dev')
# db = mongoose.connection
# db.on "error", console.error.bind(console, "connection error:")
# db.on "open", callback = ->
#   console.log "DB connection sucess"

# -- Import configuration
load_settings = require("#{__dirname}/../config/settings")
app_loader      = require("#{__dirname}/app")

console.log "Application is starting...".green.bold
settings = load_settings.base_settings
load_settings.env_settings(app, express, env)
app_loader.boot_up_application(app)

# -¥- APIs -¥-
server.listen settings.port, ->
  console.log "Express server listening on " + "port: #{settings.port}".cyan + " in " + "#{env} mode".cyan + "..."
  console.log "Using Express #{express.version}".green