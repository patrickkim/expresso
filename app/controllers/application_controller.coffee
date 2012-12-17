_ = require "underscore"

module.exports = (app) ->
  class app.ApplicationController

    # GET /
    @index: (req, res) ->
      options = { title: "test of time", view: "index" }

      test_arr = [0,1,"a",3,4]
      console.log "testing underscore..."
      test_under = _(test_arr).indexOf("a")
      console.log "tested array indexof: #{test_under}, if you see 2 UNDERSCORE works"

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