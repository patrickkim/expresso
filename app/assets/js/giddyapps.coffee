window.GiddyApps ?= {}

window.GiddyApps =

  initialize: (options = {}) ->
    console.log "!"
    GiddyApps.roulette = new GiddyApps.Roulette()

    $("#toggle-spin").on "click", -> GiddyApps.roulette.toggle_spin()