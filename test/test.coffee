should                        = require('chai').should()
expect                        = require('chai').expect
fs                            = require 'fs'
path                          = require 'path'
nodefn                        = require 'when/node'
{ends_with, flatten_object}   = require '../lib/util'
figson                        = require '..'

configFileJSON = path.join __dirname, 'fixtures', 'config.json'
configFileCSON = path.join __dirname, 'fixtures', 'config.cson'
configFileYAML = path.join __dirname, 'fixtures', 'config.yml'

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

makeCSON = (fooProp) ->
  return """
  {
    foo: "#{fooProp}"
    long:
      deeply:
        nested:
          property: ["support"]
  }
  """

makeYAML = (fooProp) ->
  return """
  foo: #{fooProp}
  long:
    deeply:
      nested:
        property:
          - support

  """

expose_data = (c) ->
  console.log(c)
  expect(c.data).to.deep.equal
    foo: "bar"
    long:
      deeply:
        nested:
          property: ["support"]

get_property = (c) -> expect(c.get('foo').val()).to.equal('bar')

set_property = (c) -> c.set('fizz', 'buzz'); expect(c.data.fizz).to.equal('buzz')

destroy_property = (c) -> c.destroy('foo'); should.not.exist(c.data.foo)

update_property = (c) -> c.update('foo', 'zoidberg'); expect(c.data.foo).to.equal('zoidberg')

cause_update_error = (c) -> (-> c.update('zar', 'zam')).should.throw(Error)

set_deep_property = (c) -> expect(c.get('long.deeply.nested.property[0]').val()).to.equal('support')

use_find = (c) -> expect(c.find('nested.property[0]').val()).to.equal('support')

chain_methods = (c) ->
  expect(c.get('foo').val()).to.equal('bar')
  expect(c.set('baz').get().val()).to.equal('baz')
  expect(c.set('prop', 'something').get().val()).to.equal('something')
  expect(c.update('something else').get().val()).to.equal('something else')
  should.not.exist(c.destroy().get().val())

describe 'utils', ->

  it 'ends_with should return true if a string ends with another string', ->
    ends_with('this is a string', 'a string').should.equal(true)

  it 'flatten_object should flatten deep objects to one level', ->
    obj =
      deep:
        nested:
          property: 'support'
        with:
          support: [{
            for: 'arrays'
          }]
    flattened_obj =
      'deep.nested.property': 'support'
      'deep.with.support[0].for': 'arrays'

    flatten_object(obj).should.deep.equal(flattened_obj)

describe 'JSON', ->
  afterEach -> fs.writeFileSync configFileJSON, makeJSON 'bar'

  describe 'async', ->

    beforeEach -> @config = nodefn.call(figson.parse, configFileJSON)

    it 'should expose the data object', (done) ->
      @config.then expose_data
             .done (-> done()), done

    it 'should get a property', (done) ->
      @config.then get_property
             .done (-> done()), done

    it 'should set a property', (done) ->
      @config.then set_property
             .done (-> done()), done

    it 'should destroy a property', (done) ->
      @config.then destroy_property
             .done (-> done()), done

    it 'should update a property', (done) ->
      @config.then update_property
             .done (-> done()), done

    it 'should throw an error when updating a non-existent property', (done) ->
      @config.then cause_update_error
             .done (-> done()), done

    it 'should work with deep nested properties and arrays', (done) ->
      @config.then set_deep_property
             .done (-> done()), done

    it 'should work with find syntax', (done) ->
      @config.then use_find
             .done (-> done()), done

    it 'should support method chaining', (done) ->
      @config.then chain_methods
             .done (-> done()), done

    it 'should save to a file', (done) ->
      @config.then (config) ->
               config.update 'foo', 'saved'
               nodefn.call(config.save.bind(config))
             .then -> nodefn.call(fs.readFile, configFileJSON, encoding: 'utf8')
             .then (contents) ->
               contents.should.equal(makeJSON 'saved')
             .done (-> done()), done

  describe 'sync', ->

    beforeEach -> @config = figson.parse(configFileJSON)

    it 'should expose the data object', ->
      expose_data @config

    it 'should get a property', ->
      get_property @config

    it 'should set a property', ->
      set_property @config

    it 'should destroy a property', ->
      destroy_property @config

    it 'should update a property', ->
      update_property @config

    it 'should throw an error when updating a non-existent property', ->
      cause_update_error @config

    it 'should work with deep nested properties and arrays', ->
      set_deep_property @config

    it 'should work with find syntax', ->
      use_find @config

    it 'should support method chaining', ->
      chain_methods @config

    it 'should save to a file', ->
      @config.update 'foo', 'saved'
      @config.save()
      contents = fs.readFileSync configFileJSON, encoding: 'utf8'
      contents.should.equal(makeJSON 'saved')

describe 'YAML', ->
  afterEach -> fs.writeFileSync configFileYAML, makeYAML 'bar'

  describe 'async', ->

    beforeEach -> @config = nodefn.call(figson.parse, configFileYAML)

    it 'should expose the data object', (done) ->
      @config.then expose_data
             .done (-> done()), done

    it 'should get a property', (done) ->
      @config.then get_property
             .done (-> done()), done

    it 'should set a property', (done) ->
      @config.then set_property
             .done (-> done()), done

    it 'should destroy a property', (done) ->
      @config.then destroy_property
             .done (-> done()), done

    it 'should update a property', (done) ->
      @config.then update_property
             .done (-> done()), done

    it 'should throw an error when updating a non-existent property', (done) ->
      @config.then cause_update_error
             .done (-> done()), done

    it 'should work with deep nested properties and arrays', (done) ->
      @config.then set_deep_property
             .done (-> done()), done

    it 'should work with find syntax', (done) ->
      @config.then use_find
             .done (-> done()), done

    it 'should support method chaining', (done) ->
      @config.then chain_methods
             .done (-> done()), done

    it 'should save to a file', (done) ->
      @config.then (config) ->
               config.update 'foo', 'saved'
               nodefn.call(config.save.bind(config))
             .then -> nodefn.call(fs.readFile, configFileYAML, encoding: 'utf8')
             .then (contents) ->
               contents.should.equal(makeYAML 'saved')
             .done (-> done()), done

  describe 'sync', ->

    beforeEach -> @config = figson.parse(configFileYAML)

    it 'should expose the data object', ->
      expose_data @config

    it 'should get a property', ->
      get_property @config

    it 'should set a property', ->
      set_property @config

    it 'should destroy a property', ->
      destroy_property @config

    it 'should update a property', ->
      update_property @config

    it 'should throw an error when updating a non-existent property', ->
      cause_update_error @config

    it 'should work with deep nested properties and arrays', ->
      set_deep_property @config

    it 'should work with find syntax', ->
      use_find @config

    it 'should support method chaining', ->
      chain_methods @config

    it 'should save to a file', ->
      @config.update 'foo', 'saved'
      @config.save()
      contents = fs.readFileSync configFileYAML, encoding: 'utf8'
      contents.should.equal(makeYAML 'saved')

describe.only 'CSON', ->
  afterEach -> fs.writeFileSync configFileCSON, makeCSON 'bar'

  describe 'async', ->

    beforeEach ->
      @config = nodefn.call(figson.parse, configFileCSON)

    it 'should expose the data object', (done) ->
      @config.then expose_data
             .done (-> done()), done

    it 'should get a property', (done) ->
      @config.then get_property
             .done (-> done()), done

    it 'should set a property', (done) ->
      @config.then set_property
             .done (-> done()), done

    it 'should destroy a property', (done) ->
      @config.then destroy_property
             .done (-> done()), done

    it 'should update a property', (done) ->
      @config.then update_property
             .done (-> done()), done

    it 'should throw an error when updating a non-existent property', (done) ->
      @config.then cause_update_error
             .done (-> done()), done

    it 'should work with deep nested properties and arrays', (done) ->
      @config.then set_deep_property
             .done (-> done()), done

    it 'should work with find syntax', (done) ->
      @config.then use_find
             .done (-> done()), done

    it 'should support method chaining', (done) ->
      @config.then chain_methods
             .done (-> done()), done

    it 'should save to a file', (done) ->
      @config.then (config) ->
               config.update 'foo', 'saved'
               nodefn.call(config.save.bind(config))
             .then -> nodefn.call(fs.readFile, configFileCSON, encoding: 'utf8')
             .then (contents) ->
               contents.should.equal(makeCSON 'saved')
             .done (-> done()), done

  describe 'sync', ->

    beforeEach -> @config = figson.parse(configFileCSON)

    it 'should expose the data object', ->
      expose_data @config

    it 'should get a property', ->
      get_property @config

    it 'should set a property', ->
      set_property @config

    it 'should destroy a property', ->
      destroy_property @config

    it 'should update a property', ->
      update_property @config

    it 'should throw an error when updating a non-existent property', ->
      cause_update_error @config

    it 'should work with deep nested properties and arrays', ->
      set_deep_property @config

    it 'should work with find syntax', ->
      use_find @config

    it 'should support method chaining', ->
      chain_methods @config

    it 'should save to a file', ->
      @config.update 'foo', 'saved'
      @config.save()
      contents = fs.readFileSync configFileCSON, encoding: 'utf8'
      contents.should.equal(makeCSON 'saved')
