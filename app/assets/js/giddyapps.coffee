window.JST = {}
window.GiddyApps ?= {}

window.GiddyApps =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Utilities: {}

  initialize: (options = {}) ->
    @_setup_game_model()
    @_setup_game_view()

  _setup_game_model: ->
    GiddyApps.game = new GiddyApps.Models.Roulette()

  _setup_game_view: ->
    GiddyApps.game_view = new GiddyApps.Views.RouletteView(roulette: GiddyApps.game)
    $("#game-container").append GiddyApps.game_view.el