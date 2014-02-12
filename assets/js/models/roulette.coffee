class GiddyApps.Models.Roulette extends Backbone.Model

  # NOTE: This reference could be done better.
  SINGLE_ZERO_WHEEL:
    numbers: ["0","32","15","19","4","21","2","25","17","34","6","27","13","36","11","30","8","23","10","5","24","16","33","1","20","14","31","9","22","18","29","7","28","12","35","3","26"]
    radians_per_num: (2 * Math.PI) / 37

  DOUBLE_ZERO_WHEEL:
    numbers: ["0","28","9","26","30","11","7","20","32","17","5","22","34","15","3","24","36","13","1","00","27","10","25","29","12","8","19","31","18","6","21","33","16","4","23","35","14","2"]
    radians_per_num: (2 * Math.PI) / 38

  RADIANS: (2 * Math.PI) / 38

  initialize: (options = {}) ->
    console.log "Hello, Roulette Game Model Here!"
    @_init_wheel()
    @_init_ball()

    @listenTo @_ball(), "complete", @spin_complete

  spin: ->
    # NOTE/TODO: you can change the order to respond to the ball.
    console.log "spin-start"
    @select_number()
    @trigger "spin-start"

  spin_complete: =>
    @trigger "spin-complete"
    console.log "spin complete! selected: #{@selected_number()}"

  select_number: ->
    @set "number", _(@_wheel_numbers()).sample()
    @set "radians", @_radians_for_number()

  selected_number: ->
    @get("number")

  selected_radians: ->
    @get("radians")

  _ball: ->
    @get("ball")

  _radians_for_number: ->
    num_pos = _(@_wheel_numbers()).indexOf(@selected_number())
    @_wheel_radians() * num_pos

  _wheel_numbers: ->
    @get("wheel").numbers

  _wheel_radians: ->
    # NOTE: This could be better
    @get("wheel").radians_per_num

  _init_wheel: ->
    @set(wheel: @DOUBLE_ZERO_WHEEL)

  _init_ball: ->
    @set(ball: new GiddyApps.Models.RouletteBall(roulette: this))
