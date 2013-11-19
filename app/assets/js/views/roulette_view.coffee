class GiddyApps.Views.RouletteView extends Backbone.View

  initialize: ->
    @render()

  leave: ->
    @remove()

  render: ->
    @_setup_canvas_stage()
    @_setup_ball()
    this

  spin: ->
    @ball_view.trigger "spin-start"

  stop: ->
    @ball_view.trigger "spin-stop"

  _setup_canvas_stage: ->
    # You could be smart about this and draw it based on the dom elements?
    @stage = new Kinetic.Stage(
      container: "ball-stage"
      width: 325
      height: 325
    )

  _setup_ball: ->
    @ball = new GiddyApps.Models.RouletteBall()
    @ball_view = new GiddyApps.Views.RouletteBallView(el: "#ball-stage", stage: @stage)
