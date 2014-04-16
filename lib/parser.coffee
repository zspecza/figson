fs       = require 'fs'
Config   = require './config'
nodefn   = require 'when/node'

###*
 * @class Parser
###
class Parser

  ###*
   * asynchronously reads in and then parses a file
   * @param  {String} file - path to file being parsed
   * @param  {Parser~parseCallback} callback - handles the file
  ###
  parse: (file, callback) ->
    nodefn.call fs.readFile, file, encoding: 'utf8'
      .then JSON.parse
      .then (data) -> callback(null, new Config(file, data))
      .done null, callback.bind(callback)
      ###**
       * exposes the config object or an error if any
       * @callback Parser~parseCallback
       * @param {Object} error - an error, if one occured
       * @param {Object} config - the config object representing the config file
      ###

  ###*
   * synchronously reads in and then parses a file
   * @param  {String} file - path to file being parsed
   * @return {Object} - the config object representing the config file
  ###
  parseSync: (file) ->
    try
      data = fs.readFileSync(file, encoding: 'utf8')
      parsed_data = JSON.parse data
      return new Config(file, parsed_data)
    catch error
      throw error

module.exports = Parser
