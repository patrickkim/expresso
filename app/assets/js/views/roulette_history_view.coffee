class GiddyApps.Views.RouletteHistoryView extends Backbone.View
  id: "roulette-history"
  template: JST["history"]

  initialize: (options ={}) ->
    @roulette = options.roulette

    @listenTo @roulette, "spin-complete", @render_number
    @render()

  leave: ->
    @remove()

  render: ->
    @$el.html @template()
    this

  render_number: =>
    @$("#selected-numbers").append """
      <li class='n-#{@roulette.selected_number()}'>
        <span>#{@roulette.selected_number()}</span>
      </li>
    """