# global require:false
# Module dependencies.
express = require "express"
http    = require "http"

# -- String utils
require "colors"

# -- Create Express instance and export
app = express()
server = http.createServer(app)

# -- Import app settings.
app_loader = require("#{__dirname}/src/app")
console.log "\n=> Booting up ...".cyan.bold
app_loader(app)

server.listen app.get("port") , ->
  console.log "=> Node/Express #{express.version} ".cyan + "Application is running on PORT:" + "#{app.get("port")}".cyan + ", ENV:" + "#{app.settings.env}".cyan