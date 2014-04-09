fs       = require 'fs'
Config   = require './config'
nodefn   = require 'when/node'

class Parser

  parse: (file, callback) ->
    nodefn.call fs.readFile, file, endoding: 'utf8'
      .then JSON.parse
      .then (data) -> callback(null, new Config(file, data))
      .done null, callback.bind(callback)

module.exports = Parser
