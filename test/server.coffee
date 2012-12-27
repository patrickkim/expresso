
global.chai   = require 'chai'
global.assert = chai.assert
global.expect = chai.expect
global.should = chai.should()
global.sinon  = require 'sinon'
global.async  = require 'async'
global.test   = it
global._      = require "underscore"

require "colors"
auto_loader = require "#{__dirname}/../util/auto_loader"
test_path = "#{__dirname}"

# global.app    = Tower.Application.instance()
# Initialize the app before everything.
# before (done) ->
#   console.log test
#   app.initialize done

# # Run this before each action
# beforeEach (done) ->
#   if Tower.isClient
#     Tower.StoreMemory.clean(done)
#   else
#     Tower.StoreMongodb.clean(done)

console.log "Starting up Mocha Tests...".cyan

describe "Example Mocha Tests (not connecteded to anything)", ->
  describe "regular javascript stuff?", ->
    it "(Array) should return -1 when the value is not present", ->
      expect([1, 2, 3].indexOf(5)).to.equal -1

    it "expect that 10 is 10!", ->
      expect(10).to.equal 10

    it "expect there to be no spoon!", ->
      expect("fork").not.to.equal "spoon"

  describe "underscore works?", ->
    it "should use underscore contains.", ->
      sample_array = ['a','b','c',1,2,3]
      result = _(sample_array).contains(1)

      result.should.be.ok
      result.should.be.true

  auto_loader.autoload("#{test_path}/spec")
