fs       = require 'fs'
Config   = require './config'
nodefn   = require 'when/node'
path     = require 'path'

###*
 * @class Parser
###
class Parser

  constructor: ->
    @handlers = {}
    @handler_map = {}

  addHandler: (name, config) ->
    @handlers[name] = config
    for extension in config.extensions
      @handler_map[extension] = name

  ###*
   * reads in and then parses a file. If callback function is provided,
   * will perform asynchronously. Else, performs synchronously
   * and then returns config object
   * @param  {String} file - path to file being parsed
   * @param  {[Parser~parseCallback]} callback - handles the file
   * @return {Object} - the config object representing the config file
  ###
  parse: (file, callback) =>
    handler = get_handler.call(@, file)
    if callback?
      nodefn.call fs.readFile, file, encoding: 'utf8'
        .then handler.parse
        .then (data) -> callback(null, new Config(handler, data))
        .done null, callback.bind(callback)
        ###**
         * exposes the config object or an error if any
         * @callback Parser~parseCallback
         * @param {Object} error - an error, if one occured
         * @param {Object} config - the config object representing the config file
        ###
    else
      try
        data = fs.readFileSync(file, encoding: 'utf8')
        parsed_data = handler.parseSync data
        return new Config(handler, parsed_data)
      catch error
        throw error

  get_handler = (file) ->
    handler = @handlers[@handler_map[path.extname(file)]]
    handler.file = file
    return handler

module.exports = Parser
