_ = require "underscore"
Widget = require("../models/widget").Widget

module.exports = (app) ->
  class app.ApplicationController

    # GET /
    @index: (req, res) ->
      options = { title: "test of time", view: "index" }

      console.log "NODEMON TEST! watching me? WORKING? twice"
      test_arr = [0,1,"a",3,4]
      test_under = _(test_arr).indexOf("a")
      options.title = "New Title after underscore: index of 'a' is #{test_under}"

      res.render('index', options)

    @dumbass: (req, res) ->
      options = { title: "dumbass figure it out of time", view: "index" }
      res.render('doobie', options)


    @rick_roll: (req, res) ->

      test_widget = new Widget(
        name: req.body.field_of_one
        desc: req.body.field_of_two
      )
      console.log "test_widget > PREP TO SAVE:".cyan + "#{JSON.stringify(test_widget)}".grey.bold

      test_widget.save()


      options = { title: "dumbass figure it out of time", view: "index" }
      res.render('doobie', options)