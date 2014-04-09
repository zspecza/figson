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

describe 'basic', ->

  it 'should get a property', ->
    nodefn.call(figson.parse, configFile)
      .then (config) -> config.get('foo').should.equal('bar')
      .done null, console.error.bind(console)

  it 'should set a property', ->
    nodefn.call(figson.parse, configFile)
      .then (config) ->
        config.set('fizz', 'buzz')
        config.data.fizz.should.equal('buzz')
      .done null, console.error.bind(console)

  it 'should destroy a property', ->
    nodefn.call(figson.parse, configFile)
      .then (config) ->
        config.destroy('foo')
        should.not.exist(config.data.foo)
      .done null, console.error.bind(console)

  it 'should update a property', ->
    nodefn.call(figson.parse, configFile)
      .then (config) ->
        config.update('foo', 'zoidberg')
        config.data.foo.should.equal('zoidberg')
      .done null, console.error.bind(console)

  it 'should throw an error when updating a non-existent property', ->
    nodefn.call(figson.parse, configFile)
      .then (config) -> (-> config.update('zar', 'zam')).should.throw(Error)
      .done null, console.error.bind(console)

  it 'should save to a file', ->
    nodefn.call(figson.parse, configFile)
      .then (config) ->
        config.update('foo', 'saved')
        nodefn.call config.save
      .then -> nodefn.call(fs.readFile, configFile, encoding: 'utf8')
      .tap (contents) -> contents.should.equal(makeJSON 'saved')
      .done null, console.error.bind(console)

