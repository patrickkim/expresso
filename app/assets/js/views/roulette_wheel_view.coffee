class GiddyApps.Views.RouletteWheelView extends Backbone.View
  id: "roulette-wheel"
  template: JST["wheel"]

  initialize: (options ={}) ->
    @roulette = options.roulette
    @render()

  leave: ->
    @remove()

  render: ->
    @$el.html @template()
    @_setup_ball_stage()
    @_render_ball()
    this

  _setup_ball_stage: ->
    # NOTE: this is the canvas stage where all the animations will take place.
    # "container" loads this view's #ball-stage element
    @ball_stage = new Kinetic.Stage(
      container: @$("#ball-stage")[0]
      width: 325
      height: 325
    )

  _render_ball: ->
    @ball_view = new GiddyApps.Views.RouletteBallView(el: "#ball-stage", roulette: @roulette)
    @ball_stage.add @ball_view.el
