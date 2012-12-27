fs = require 'fs'

# Recursively require a folder’s files
exports.autoload = autoload = (dir, app) ->
  fs.readdirSync(dir).forEach (file) ->

    console.log "Skipping File! #{file} in #{dir}".yellow if file.match(/^\.\w+/)
    return if file.match(/^\.\w+/)
    console.log "Loading: #{dir}/#{file}".grey

    path = "#{dir}/#{file}"
    stats = fs.lstatSync(path)

    # Go through the loop again if it is a directory
    if stats.isDirectory()
      autoload path, app
    else
      require(path)?(app)