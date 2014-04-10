should   = require('chai').should()
fs       = require 'fs'
path     = require 'path'
nodefn   = require 'when/node'
figson   = require '..'

testPath = path.join __dirname, 'fixtures'
configFile = path.join testPath, 'config.json'

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

afterEach -> fs.writeFileSync configFile, makeJSON 'bar'

describe 'basic async', ->

  it 'should expose the data object', (done) ->
    nodefn.call(figson.parse, configFile)
      .then (config) ->
        config.data.should.deep.equal(JSON.parse(makeJSON('bar')))
      .done (-> done()), done

  it 'should get a property', (done) ->
    nodefn.call(figson.parse, configFile)
      .then (config) -> config.get('foo').should.equal('bar')
      .done (-> done()), done

  it 'should set a property', (done) ->
    nodefn.call(figson.parse, configFile)
      .then (config) ->
        config.set('fizz', 'buzz')
        config.data.fizz.should.equal('buzz')
      .done (-> done()), done

  it 'should destroy a property', (done) ->
    nodefn.call(figson.parse, configFile)
      .then (config) ->
        config.destroy('foo')
        should.not.exist(config.data.foo)
      .done (-> done()), done

  it 'should update a property', (done) ->
    nodefn.call(figson.parse, configFile)
      .then (config) ->
        config.update('foo', 'zoidberg')
        config.data.foo.should.equal('zoidberg')
      .done (-> done()), done

  it 'should throw an error when updating a non-existent property', (done) ->
    nodefn.call(figson.parse, configFile)
      .then (config) -> (-> config.update('zar', 'zam')).should.throw(Error)
      .done (-> done()), done

  it 'should work with deep nested properties and arrays', (done) ->
    nodefn.call figson.parse, configFile
      .then (config) ->
        config.get('long.deeply.nested.property[0]').should.equal('support')
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

describe 'basic sync', ->

  it 'should expose the data object', ->
    config = figson.parseSync(configFile)
    config.data.should.deep.equal(JSON.parse(makeJSON('bar')))

  it 'should get a property', ->
    config = figson.parseSync(configFile)
    config.get('foo').should.equal('bar')

  it 'should set a property', ->
    config = figson.parseSync(configFile)
    config.set('fizz', 'buzz')
    config.data.fizz.should.equal('buzz')

  it 'should destroy a property', ->
    config = figson.parseSync(configFile)
    config.destroy('foo')
    should.not.exist(config.data.foo)

  it 'should update a property', ->
    config = figson.parseSync(configFile)
    config.update('foo', 'zoidberg')
    config.data.foo.should.equal('zoidberg')

  it 'should throw an error when updating a non-existent property', ->
    config = figson.parseSync(configFile)
    (-> config.update('zar', 'zam')).should.throw(Error)

  it 'should work with deep nested properties and arrays', ->
    config = figson.parseSync(configFile)
    config.get('long.deeply.nested.property[0]').should.equal('support')

  it 'should save to a file', ->
    config = figson.parseSync(configFile)
    config.update 'foo', 'saved'
    config.save()
    contents = fs.readFileSync configFile, encoding: 'utf8'
    contents.should.equal(makeJSON 'saved')
