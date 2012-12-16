fs = require("fs")
connectAssets = require("connect-assets")

#gzippo = require('gzippo');
module.exports = (app, express) ->
  app.use express.logger(
    format: "tiny"
    # stream: fs.createWriteStream("log/node.log")
  )

  #Enable dependency based asset loading
  #Setup concatenate and compress build dir
  app.use connectAssets(
    src: "#{__dirname}/../../app/public"
    buildDir: "public_build"
  )
  app.use express.staticCache()

  #var duration = 2592000000; // One month
  #app.use(gzippo.staticGzip(__dirname + '/../public_build/', { maxAge: duration }));
  app.use express.errorHandler()