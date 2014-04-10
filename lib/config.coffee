props    = require 'pathval'
fs       = require 'fs'

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
    if callback?
      fs.writeFile(@file, JSON.stringify(@data, null, 2), callback)
    else
      fs.writeFileSync(@file, JSON.stringify(@data, null, 2))

module.exports = Config
