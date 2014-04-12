props                         = require 'pathval'
fs                            = require 'fs'
{flatten_object, ends_with}   = require './util'

###*
 * @class Config
###
class Config

  constructor: (@file, @data) ->
    @_value_of_previous_key = ''
    @_previous_key = ''
    @_value_of_current_key = ''
    @_current_key = ''

  ###*
   * gets the value of the key in the previous chain
   * @return {(string|number|array|object|null)} - the fetched value
  ###
  val: ->
    @_value_of_current_key

  ###*
   * finds a key that ends with given text
   * @param  {String} partial_key - the key suffix to look for
  ###
  find: (partial_key) ->
    flattened_data = flatten_object @data
    key = undefined
    for own k of flattened_data
      if ends_with(k, partial_key)
        key = k
        break
    @get(key)

  ###*
   * sets the value of a key
   * @param {string} [key] - the property that is being set
   * @param {(string|number|array|object|null)} val - the value to assign
  ###
  set: (args...) ->
    if args.length > 1
      track.call(@, args[0], props.set(@data, args[0], args[1]))
    else if args.length is 1
      track.call(@, @_current_key, props.set(@data, @_current_key, args[0]))
    else
      throw new Error "Figson: .set() expects an argument: [key], value"
    return this

  ###*
   * fetches a key
   * @param  {string} key - the property being fetched
  ###
  get: (key) ->
    if key?
      track.call(@, key, props.get(@data, key))
    else
      track.call(@, @_current_key, props.get(@data, @_current_key))
    return this

  ###*
   * updates a key - first gets, checks for existence, then either
   * sets the key or throws an error if the key does not exist
   * @param  {string} [key] - the property to update
   * @param  {(string|number|array|object|null)} val - the value to update with
  ###
  update: (args...) ->
    key = undefined
    val = undefined
    if args.length is 1
      val = args[0]
      key = @_current_key
    else
      val = args[1]
      key = args[0]
    unless @get(key).val()
      throw new Error "Figson: cannot update non-existent property '#{key}'"
    else
      @set(key, val)
    return this

  ###*
   * deletes a property
   * @param  {string} key - the property to delete
  ###
  destroy: (key) ->
    if key? then @set(key, undefined)
    else @set(@_current_key, undefined)
    return this

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
    return this

  ###*
   * maintains the internal structure, required for chaining to work
   * @api private
   * @param  {String} key - the key being tracked
   * @param  {[type]} val - the value of the key being tracked
  ###
  track = (key, val) ->
    @_value_of_previous_key = @_value_of_current_key
    @_previous_key = @_current_key
    @_value_of_current_key = val
    @_current_key = key

module.exports = Config
