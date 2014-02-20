# -- String utils
require "colors"

# global require:false
# Module dependencies.
express = require "express"
http    = require "http"
expresso_app = require("#{__dirname}/src/app")

# -- Create Express instance and export
app = express()
server = http.createServer(app)

# -- Start Expresso
console.log "\nBooting up...".yellow
expresso_app(app)

server.listen app.get("port") , ->
  console.log "\n[Expresso]".magenta + " Application is running on PORT:" + "#{app.get("port")}".cyan + ", ENV:" + "#{app.settings.env}".cyan