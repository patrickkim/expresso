module.exports = (app) ->
  class app.ApplicationController

    # GET /
    @index = (req, res) ->
      options = { title: "test of time", view: "index" }
      res.render('index', options)

    @dumbass = (req, res) ->
      options = { title: "dumbass figure it out of time", view: "index" }
      res.render('doobie', options)