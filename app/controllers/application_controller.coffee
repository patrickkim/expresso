# -- Mongoose models and stuff loading.. add this to common
mongoose = require "mongoose"
db_address = "localhost/nodesample-dev"

mongoose.connection.on "open", (ref) ->
  console.log "Connected to mongo server!".green

mongoose.connection.on "error", (err) ->
  console.log "Could not connect to mongo server!".yellow
  console.log err.message.red

try
  mongoose.connect("mongodb://#{db_address}")
  db = mongoose.connection
  console.log "Started connection on " + "mongodb://#{db_address}".cyan + ", waiting for it to open...".grey

catch err
  console.log "Setting up failed to connect to #{db_address}".red, err.message


_ = require "underscore"

Widget = require "../models/widget"

module.exports = (app) ->
  class app.ApplicationController

    # GET /
    @index: (req, res) ->
      options = { title: "test of time", view: "index" }

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
        updated_at: Date.now()
      )

      test_widget.save (error, data) ->
        if error
          console.log "ERROR:".red + error.red
        else
          console.log "SAVED! \n\n".magenta + data + "\n"

      options = { title: "dumbass figure it out of time", view: "index" }
      res.render('doobie', options)