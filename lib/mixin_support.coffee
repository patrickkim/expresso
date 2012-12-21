#Mixin support
Function::mixin = (module) ->
  _.extend this.prototype, module
  if @::initialize && module.included
    @::_wrapped_initialize = @::initialize
    @::initialize = ->
      @_wrapped_initialize.apply(@, arguments)
      @included() # modeled after ruby modules, calls the 'included' method on the module, if it exists

  return this