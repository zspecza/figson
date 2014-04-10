fs       = require 'fs'
Config   = require './config'
nodefn   = require 'when/node'

class Parser

  parse: (file, callback) ->
    nodefn.call fs.readFile, file, encoding: 'utf8'
      .then JSON.parse
      .then (data) -> callback(null, new Config(file, data))
      .done null, callback.bind(callback)

  parseSync: (file) ->
    try
      data = fs.readFileSync(file, encoding: 'utf8')
      parsed_data = JSON.parse data
      return new Config(file, parsed_data)
    catch error
      throw error

module.exports = Parser
