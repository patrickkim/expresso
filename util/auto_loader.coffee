fs = require 'fs'

# Recursively require a folder’s files
exports.autoload = autoload = (dir, app) ->
  fs.readdirSync(dir).forEach (file) ->

    if file.match(/^\.\w+/)
      console.log "Skipping File! #{file} in #{dir}".yellow
      return


    path = "#{dir}/#{file}"
    stats = fs.lstatSync(path)
    console.log "Loading: #{path}".grey

    # Go through the loop again if it is a directory
    if stats.isDirectory()
      autoload path, app
    else
      require(path)?(app)