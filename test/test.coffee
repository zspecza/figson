should   = require('chai').should()
fs       = require 'fs'
path     = require 'path'
figson   = require '..'
EOL      = require('os').EOL

testPath = path.join __dirname, 'fixtures'
configFile = path.join testPath, 'config.json'

before ->
  @config = figson configFile

afterEach ->
  fs.writeFileSync configFile, "{#{EOL}  \"foo\": \"bar\"#{EOL}}"

describe 'basic figson functionality', ->

  it 'should parse a json file', ->
    @config.data.foo.should.equal('bar')

  it 'should set a key', ->
    @config.set 'baz', 'buz'
    @config.data.baz.should.equal('buz')

  it 'should get a key', ->
    @config.get('baz').should.equal('buz')

  it 'should destroy a key', ->
    @config.destroy('baz')
    should.not.exist @config.data.baz

  it 'should update a key', ->
    @config.update('foo', '50cent')
    @config.data.foo.should.equal('50cent')

  it 'should throw an error when updating a non-existent key', ->
    should.Throw -> @config.update('fred')

describe 'works with different types', ->

  it 'should set an array', ->
    arr = ['one', 2, 'three']
    @config.set 'arr', arr
    @config.data.arr.should.equal(arr)

  it 'should set an object', ->
    obj = { name: 'Jim' }
    @config.set 'person', obj
    @config.data.person.should.equal(obj)

describe 'complex figson functionality', ->

  it 'should support deep properties', ->
    @config.set('this.is.deeply.nested', 'one')
    @config.get('this.is.deeply.nested').should.equal 'one'

  it 'should support deep array properties', ->
    @config.set('this.is.deeply.arr[0]', 'first item')
    @config.get('this.is.deeply.arr[0]').should.equal 'first item'
