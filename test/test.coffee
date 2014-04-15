should   = require('chai').should()
fs       = require 'fs'
path     = require 'path'
nodefn   = require 'when/node'
figson   = require '..'

configFile = path.join __dirname, 'fixtures', 'config.json'

makeJSON = (fooProp) ->
  return """
  {
    "foo": "#{fooProp}",
    "long": {
      "deeply": {
        "nested": {
          "property": [
            "support"
          ]
        }
      }
    }
  }
  """

expose_data = (c) -> c.data.should.deep.equal(JSON.parse(makeJSON('bar')))

get_property = (c) -> c.get('foo').val().should.equal('bar')

set_property = (c) -> c.set('fizz', 'buzz'); c.data.fizz.should.equal('buzz')

destroy_property = (c) -> c.destroy('foo'); should.not.exist(c.data.foo)

update_property = (c) -> c.update('foo', 'zoidberg'); c.data.foo.should.equal('zoidberg')

cause_update_error = (c) -> (-> c.update('zar', 'zam')).should.throw(Error)

set_deep_property = (c) -> c.get('long.deeply.nested.property[0]').val().should.equal('support')

describe 'async', ->

  afterEach -> fs.writeFileSync configFile, makeJSON 'bar'

  it 'should expose the data object', (done) ->
    nodefn.call(figson.parse, configFile)
      .then expose_data
      .done (-> done()), done

  it 'should get a property', (done) ->
    nodefn.call(figson.parse, configFile)
      .then get_property
      .done (-> done()), done

  it 'should set a property', (done) ->
    nodefn.call(figson.parse, configFile)
      .then set_property
      .done (-> done()), done

  it 'should destroy a property', (done) ->
    nodefn.call(figson.parse, configFile)
      .then destroy_property
      .done (-> done()), done

  it 'should update a property', (done) ->
    nodefn.call(figson.parse, configFile)
      .then update_property
      .done (-> done()), done

  it 'should throw an error when updating a non-existent property', (done) ->
    nodefn.call(figson.parse, configFile)
      .then cause_update_error
      .done (-> done()), done

  it 'should work with deep nested properties and arrays', (done) ->
    nodefn.call figson.parse, configFile
      .then set_deep_property
      .done (-> done()), done

  it 'should save to a file', (done) ->
    nodefn.call(figson.parse, configFile)
      .then (config) ->
        config.update 'foo', 'saved'
        nodefn.call(config.save.bind(config))
      .then -> nodefn.call(fs.readFile, configFile, encoding: 'utf8')
      .then (contents) ->
        contents.should.equal(makeJSON 'saved')
      .done (-> done()), done

describe 'sync', ->

  afterEach -> fs.writeFileSync configFile, makeJSON 'bar'

  it 'should expose the data object', ->
    config = figson.parseSync(configFile)
    expose_data config

  it 'should get a property', ->
    config = figson.parseSync(configFile)
    get_property config

  it 'should set a property', ->
    config = figson.parseSync(configFile)
    set_property config

  it 'should destroy a property', ->
    config = figson.parseSync(configFile)
    destroy_property config

  it 'should update a property', ->
    config = figson.parseSync(configFile)
    update_property config

  it 'should throw an error when updating a non-existent property', ->
    config = figson.parseSync(configFile)
    cause_update_error config

  it 'should work with deep nested properties and arrays', ->
    config = figson.parseSync(configFile)
    set_deep_property config

  it 'should save to a file', ->
    config = figson.parseSync(configFile)
    config.update 'foo', 'saved'
    config.save()
    contents = fs.readFileSync configFile, encoding: 'utf8'
    contents.should.equal(makeJSON 'saved')
