props  = require 'pathval'
fs     = require 'fs'

class Config

  constructor: (@file, @data) ->

  set: (key, val) ->
    props.set(@data, key, val)

  get: (key, val) ->
    props.get(@data, key)

  update: (key, val) ->
    unless @get(key)
      throw new Error "Figson: cannot update non-existent property '#{key}'"
    else
      @set(key, val)

  destroy: (key) ->
    @set(key, undefined)

  save: (callback) ->
    data = undefined
    try
      data = JSON.stringify(@data, null, 2)
      fs.writeFile @file, data, (error) ->
        if error
          callback(error)
        else
          callback(null)
    catch error
      callback(error)

module.exports = Config
