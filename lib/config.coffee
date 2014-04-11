props    = require 'pathval'
fs       = require 'fs'

###*
 * @class
###
class Config

  constructor: (@file, @data) ->

  ###*
   * sets the value of a key
   * @param {string} key - the property that is being set
   * @param {(string|number|array|object|null)} val - the value to assign
  ###
  set: (key, val) ->
    props.set(@data, key, val)

  ###*
   * fetches the value of a key
   * @param  {string} key - the property who's value is being fetched
   * @return {(string|number|array|object|null)} - the fetched value
  ###
  get: (key, val) ->
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
   * deletes a property
   * @param  {string} key - the property to delete
  ###
  destroy: (key) ->
    @set(key, undefined)

  ###*
   * saves the current object data to the config file
   * @param  {Config~saveCallback} [callback] - handles async saving of file
  ###
  save: (callback) ->
    if callback?
      fs.writeFile(@file, JSON.stringify(@data, null, 2), callback)
      ###**
       * exposes any errors that happened while saving
       * @callback Config~saveCallback
       * @param {Object} error - an error, if one occured
      ###

    else
      fs.writeFileSync(@file, JSON.stringify(@data, null, 2))

module.exports = Config
