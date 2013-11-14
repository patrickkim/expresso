window.GiddyApps ?= {}


class GiddyApps.Roulette
  constructor: ->
    console.log "constructed!"
    @initialize()

  initialize: ->
    console.log "initialized"
    @_setup_stage()
    @_setup_ball()
    @_setup_spin_animation()

  toggle_spin: ->
    if @is_spinning then @stop() else @spin()

  spin: ->
    console.log "spin the ball"
    @anim.start()
    @is_spinning = true

  stop: ->
    console.log "stop the ball"
    @anim.stop()
    @is_spinning = false

  _setup_stage: ->
    # You could be smart about this and draw it based on the dom elements?
    @stage = new Kinetic.Stage(
        container: "ball-stage"
        width: 325
        height: 325
    )

  _setup_ball: ->
    @ball_layer = new Kinetic.Layer()
    @ball = new Kinetic.Circle(
      x:  @stage.getWidth() / 2
      y: @stage.getHeight() / 2
      radius: 5
      # width: 10
      # height: 20
      offset: [155, 0]
      fill: "#ffffff"
      # stroke: "black"
      # strokeWidth: 1
    )
    @ball_layer.add(@ball);
    @stage.add(@ball_layer);

  _setup_spin_animation: ->
    @anim = new Kinetic.Animation( (frame) =>
      angleDiff = @_rotation_math(frame)
      @ball.rotate angleDiff
      # @ball.setAttr "offsetX", 130
      # Should end up at 77
    , @ball_layer)

  _rotation_math: (frame) ->
    angularSpeed = Math.PI /3
    frame.timeDiff * angularSpeed / 1000