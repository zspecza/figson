fs       = require 'fs'
Config   = require './config'

class Parser

  parse: (file, callback) ->
    fs.readFile file, encoding: 'utf8', (error, contents) ->
      if error
        callback(error, null)
      else
        data = undefined
        try
          data = JSON.parse(contents)
          callback(null, new Config(file, data))
        catch error
          callback(error, null)

module.exports = Parser
