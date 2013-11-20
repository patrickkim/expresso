class GiddyApps.Models.RouletteBall extends Backbone.Model

  SPIN_STATES: ["spinning", "descent", "selecting", "selected"]

  initialize: (options = {}) ->
    @roulette =  options.roulette
    @listenTo @roulette, "change:radians", @spin_start

  spin_start: =>
    @_reset_sequences()
    @next_state()
    @trigger "spinning"

  spin_complete: ->
    @trigger "complete"

  next_state: =>
    @set(
      state: @spin_sequences.shift()
      total_spins: _.random(1,3) if @is_spinning()
    )
    @spin_complete() if @is_complete()

  total_spins: ->
    @get("total_spins")

  current_state: ->
    @get("state")

  # NOTE: I think using native array methods is faster than using underscore + string evals?
  is_spinning: ->
    # @current_state() == "spinning"
    @spin_sequences.length == 3

  is_complete: ->
    # @current_state() == "selected"
    @spin_sequences.length == 0

  _reset_sequences: ->
    # @spin_sequences = _(@SPIN_STATES).clone()
    @spin_sequences = @SPIN_STATES.slice(0)
