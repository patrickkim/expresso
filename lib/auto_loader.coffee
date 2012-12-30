fs = require 'fs'

# Recursively require a folder’s files
exports.autoload = autoload = (dir, app) ->
  fs.readdirSync(dir).forEach (file) ->

    # Ignore .ds, .git system files.
    if file.match(/^\.\w+/)
      console.log "=> ".grey + "Skipping File! #{file} in #{dir}".yellow
      return

    path = "#{dir}/#{file}"
    stats = fs.lstatSync(path)

    # Go through the loop again if it is a directory
    if stats.isDirectory()
      autoload path, app
    else
      console.log "=> Loading: #{path}".grey
      require(path)?(app)