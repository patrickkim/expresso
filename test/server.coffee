global.chai   = require 'chai'
global.assert = chai.assert
global.expect = chai.expect
global.should = chai.should()
global.sinon  = require 'sinon'
global.async  = require 'async'
global.test   = it
global._      = require "underscore"


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


describe "Example Mocha Tests (not connecteded to anything)", ->
  describe "regular javascript stuff?", ->
    it "(Array) should return -1 when the value is not present", ->
      expect([1, 2, 3].indexOf(5)).to.equal -1

    it "expect that 10 is 10!", ->
      expect(10).to.equal 10

    it "expect there to be no spoon!", ->
      expect("fork").not.to.equal "spoon"

  describe "global usage of underscore", ->
    it "should use underscore contains.", ->
      sample_array = ['a','b','c',1,2,3]
      result = _(sample_array).contains(1)

      result.should.be.ok
      result.should.be.true


  describe "more advanced test examples", ->
    beforeEach ->
      @pot_of_tea = { tea: ['oolong', 'earl grey', 'chai']}

    it "a pot of tea should exist", ->
      @pot_of_tea.should.exist

    it "there should be 3 teas in the pot", ->
      tea_mix = @pot_of_tea.tea
      tea_mix.length.should.equal(3)

    it "oolong should be the first tea.", ->
      first_tea = _(@pot_of_tea.tea).first()
