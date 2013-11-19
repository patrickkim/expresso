class GiddyApps.Views.RouletteBallView extends Backbone.View

  DOUBLE_ZERO_WHEEL: ["0","28","9","26","30","11","7","20","32","17","5","22","34","15","3","24","36","13","1","00","27","10","25","29","12","8","19","31","18","6","21","33","16","4","23","35","14","2"]
  RADIANS_PER_NUM: (2 * Math.PI) / 38
  SPEED: 2 * Math.PI / 1000

  initialize: (options = {}) ->
    @stage = options.stage
    @on "spin-start", @spin_start
    @on "spin-stop", @spin_stop
    @render()

  leave: ->
    @remove()

  render: ->
    @_setup_ball()
    this

  spin_start: =>
    @_randomize_to_number()
    @_reset_ball()
    @_animate_spin()

  _reset_ball: ->
    return unless @tween
    @tween.reset()
    @ball_el.setAttrs(rotation: 0, offsetX: 155)

  _setup_ball: ->
    # NOTE: Make this configurable
    @ball_el = new Kinetic.Circle(
      x:  @stage.getWidth() / 2
      y: @stage.getHeight() / 2
      radius: 5
      fill: "#ffffff"
      stroke: "#bbbbbb"
      strokeWidth: 1
      offset: [155,0]
    )

    # NOTE: consider augmenting el to return canvas el instead of dom el?
    # and moving the stage manipulation up on the parent view.
    @ball_layer = new Kinetic.Layer()
    @ball_layer.add(@ball_el)
    @stage.add(@ball_layer)

  velocity: 2 * Math.PI

  _animate_spin: ->
    rando = _.random(1,5)
    @tween = new Kinetic.Tween(
      node: @ball_el
      rotation: @velocity * rando
      offsetX: 150
      duration: rando
      easing: Kinetic.Easings.Linear
      onFinish: => @_animate_descent()
    )
    @tween.play()

  _animate_descent: ->
    rotation_amt = @ball_el.getRotation() + @_radians_for(@selected_num) + @velocity
    @tween = new Kinetic.Tween(
      node: @ball_el
      rotation: rotation_amt
      duration: 1 + @_radians_for(@selected_num) / @velocity
      offsetX: 96
      easing: Kinetic.Easings.Linear
      onFinish: => @_animate_selection()
    )
    @tween.play()

  _animate_selection: ->
    rotation_amt = @ball_el.getRotation() + @velocity
    @tween = new Kinetic.Tween(
      node: @ball_el
      rotation: rotation_amt
      duration: 3
      offsetX: 76
      easing: Kinetic.Easings.EaseOut
      onFinish: =>
        console.log "Selected #{@selected_num}"
    )
    @tween.play()

  # MOVE this to MODEL
  _randomize_to_number: ->
    @selected_num = _(@DOUBLE_ZERO_WHEEL).sample()
    # @radians_at_stop = (@random_spins * 2 * Math.PI) + @_radians_for(@selected_num)

  _radians_for: (str_num) ->
    num_pos = _(@DOUBLE_ZERO_WHEEL).indexOf(str_num)
    @RADIANS_PER_NUM * num_pos
