class GiddyApps.Views.RouletteBallView extends Backbone.View

  # NOTE: Canvas Ball View using kinetic.js
  STAGE_DIMENSION: 318
  VELOCITY: 2 * Math.PI
  OFFSET_X: 155
  FINAL_OFFSET: 76

  initialize: (options = {}) ->
    @roulette = options.roulette
    @ball = @roulette.get("ball")

    @listenTo @ball, "change:state", @animate_ball
    @render()

  leave: ->
    @remove()

  render: ->
    # NOTE: this.el returns the canvas layer instead of the dom_el
    @_setup_kinetic_ball()
    @_render_kinetic_ball()
    this

  animate_ball: =>
    return if @ball.is_complete()
    @_reset_ball() if @ball.is_spinning()

    @_setup_tween(@_tween_for_state())
    @tween.play()

  _next_state: ->
    @ball.next_state()

  _setup_tween: (tween_options) ->
    # TODO: there's probably a better way to merge this into options.
    @tween = new Kinetic.Tween(
      node: @ball_el
      rotation: tween_options.rotation
      offsetX: tween_options.offsetX
      duration: tween_options.duration
      easing: tween_options.easing
      onFinish: => @_next_state()
    )

  _setup_kinetic_ball: ->
    @ball_el = new Kinetic.Circle(
      x: @STAGE_DIMENSION/2
      y: @STAGE_DIMENSION/2
      radius: 5
      fill: "#ffffff"
      stroke: "#bbbbbb"
      strokeWidth: 1
      offsetX: @OFFSET_X
      # offset: [@OFFSET_X,0]
    )

  _render_kinetic_ball: ->
    @el = new Kinetic.Layer()
    @el.add @ball_el

  _reset_ball: ->
    return unless @tween
    @tween.reset()
    @ball_el.setAttrs(rotation: 0, offsetX: 155)

  # NOTE: Can this be done better?
  _tween_for_state: ->
    # @TWEENS_FOR_STATES[@ball.current_state()]
    switch @ball.current_state()
      when "spinning" then {
        rotation: @ball.total_spins() * @VELOCITY
        offsetX: @OFFSET_X - 5
        duration: @ball.total_spins()
        easing: Kinetic.Easings.Linear
      }
      when "descent" then {
        rotation: @ball_el.getRotation() + @roulette.selected_radians() + @VELOCITY
        offsetX: @OFFSET_X - ( _.random(35,55))
        duration: 1 + @roulette.selected_radians() / @VELOCITY
        easing: Kinetic.Easings.Linear
      }
      when "selecting" then {
        rotation: @ball_el.getRotation() + @VELOCITY
        offsetX: @FINAL_OFFSET
        duration: _.random(2,5)
        easing: Kinetic.Easings.EaseOut
      }
      else { doobie: "doo" }
