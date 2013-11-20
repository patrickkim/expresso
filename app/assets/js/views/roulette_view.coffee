class GiddyApps.Views.RouletteView extends Backbone.View
  id: "roulette"
  template: JST["roulette_template"]

  events:
    "click #spin": "spin"

  initialize: (options ={}) ->
    @roulette = options.roulette
    @render()

  leave: ->
    @remove()

  render: ->
    @$el.html @template()
    @_render_wheel()
    @_render_history()
    this

  spin: =>
    @roulette.spin()

  _render_wheel: ->
    @wheel_view = new GiddyApps.Views.RouletteWheelView(roulette: @roulette)
    @$el.append @wheel_view.el

  _render_history: ->
    @history_view = new GiddyApps.Views.RouletteHistoryView(roulette: @roulette)
    @$el.append @history_view.el
