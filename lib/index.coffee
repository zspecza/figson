props   = require 'pathval'
fs      = require 'fs'
path    = require 'path'
_       = require 'lodash'

class Figson

  constructor: (@configFile) ->
    unless @configFile
      throw new Error "Figson: configuration file expected, but not received."
    @compress = false
    @indentor = 2
    parse.call(@)

  ###*
   * sets the value of a key
   * @param {string} key - the property that is being set
   * @param {(string|number|array|object|null)} val - the value to assign
  ###
  set: (key, val) ->
    props.set(@data, key, val)
    save.call(@)

  ###*
   * fetches the value of a key
   * @param  {string} key - the property who's value is being fetched
   * @return {(string|number|array|object|null)} - the fetched value
  ###
  get: (key) ->
    props.get(@data, key)

  ###*
   * updates a key - first gets, checks for existence, then either
   * sets the key or throws an error if the key does not exist
   * @param  {string} key - the property to update
   * @param  {(string|number|array|object|null)} val - the value to update with
  ###
  update: (key, val) ->
    unless @get(key)
      throw new Error "Figson: cannot update non-existent property '#{key}'"
    else
      @set(key, val)

  ###*
   * deletes a property of an object and saves to disk
   * @param  {string} key - the property to delete
  ###
  destroy: (key) ->
    @set(key, undefined)
    save.call(@)

  ###*
   * converts JSON to javascript object
   * @api private
   * @return {object} - object heirarchy of parsed JSON data
  ###
  parse = ->
    @data = JSON.parse readFile.call(@)

  ###*
   * reads in a file
   * @api private
   * @return {string} file contents
  ###
  readFile = ->
    fs.readFileSync(@configFile)

  ###*
   * saves the current object data to the config file
   * @api private
  ###
  save = ->
    fs.writeFileSync(@configFile, stringify.call(@))

  ###*
   * stringify converts javascript object to JSON
   * @api private
   * @return {json} json representation of data object
  ###
  stringify = ->
    if @compress
      JSON.stringify(@data)
    else
      JSON.stringify(@data, null, @indentor)

module.exports = (f) -> new Figson(f)
