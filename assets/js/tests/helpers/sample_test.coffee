describe "more advanced test examples", ->
  beforeEach ->
    @pot_of_tea = { tea: ['oolong', 'earl grey', 'chai']}

  it "a pot of tea should exist", ->
    apot_of_tea = { tea: ['oolong', 'earl grey', 'chai']}

    console.log "running a test!"
    @pot_of_tea.should.exist

  it "there should be 3 teas in the pot", ->
    tea_mix = @pot_of_tea.tea
    tea_mix.length.should.equal(3)

  it "oolong should be the first tea.", ->
    first_tea = _(@pot_of_tea.tea).first()
