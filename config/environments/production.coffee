fs = require("fs")
connectAssets = require("connect-assets")

#gzippo = require('gzippo');
module.exports = (app, express) ->

  app.use express.logger(
    format: "tiny"
    stream: fs.createWriteStream("log/node.log")
  )

  #Enable dependency based asset loading
  #Setup concatenate and compress build dir
  #(NOT WORKING YET)
  app.use connectAssets(
    build: true
    compress: true
    buildDir: "./public/bin"
    src: "#{__dirname}/../../app/assets"
  )

  #var duration = 2592000000; // One month
  #app.use(gzippo.staticGzip(__dirname + '/../public_build/', { maxAge: duration }));
  app.use express.errorHandler()