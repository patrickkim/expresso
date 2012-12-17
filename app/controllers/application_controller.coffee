module.exports = (app) ->
  class app.ApplicationController

    # GET /
    @index: (req, res) ->
      options = { title: "test of time", view: "index" }
      res.render('index', options)

    @dumbass: (req, res) ->
      options = { title: "dumbass figure it out of time", view: "index" }
      res.render('doobie', options)

    @rick_roll: (req, res) ->
      console.log req.body.field_of_one
      console.log req.body.field_of_two
      console.log "TESTING noddemon!"
      options = { title: "dumbass figure it out of time", view: "index" }
      res.render('doobie', options)