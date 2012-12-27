module.exports = (app) ->
  # Index
  app.get '/', app.ApplicationController.index
  app.get '/dumbass',  app.ApplicationController.dumbass
  app.post '/form-test', app.ApplicationController.rick_roll

  # Error handling (No previous route found. Assuming it’s a 404)
  app.get '/*', (req, res) ->
    NotFound res

  NotFound = (res) ->
    res.render '404', status: 404, view: 'four-o-four'

  # -- 500 status
  app.use (err, req, res, next) ->
    console.log err
    res.status(500).send err

  # -- 404 status
  app.use (req, res, next) ->
    console.log "404"
    res.status(404).end()