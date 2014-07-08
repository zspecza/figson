fs       = require 'fs'
Config   = require './config'
nodefn   = require 'when/node'
path     = require 'path'

###*
 * @class Parser
###
class Parser

  constructor: ->
    @handlers = {} # internal filetype handler store
    @handler_map = {} # maps file extensions to handlers

  ###*
   * reads in and then parses a file. If callback function is provided,
   * will perform asynchronously. Else, performs synchronously
   * and then returns config object
   * @param  {String} file - path to file being parsed
   * @param  {[Parser~parseCallback]} callback - handles the file
   * @return {Object} - the config object representing the config file
  ###
  parse: (file, callback) =>
    file    = path.resolve(file)
    handler = get_handler.call(@, file)
    if callback?
      nodefn.call fs.readFile, file, encoding: 'utf8'
        .then handler.parse
        .then (data) -> callback(null, new Config(handler, data))
        .catch callback.bind(callback)
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

  ###*
   * adds a configuration type handler to figson, this allows you to register
   * other filetypes as configuration. Just specify a name and pass in a
   * config object that looks like this:
   * {
   *   extensions: [string] # the file extensions this handler should handle
   *   parse: fn # the function definition to use when parsing asynchronously
   *   parseSync: fn # the synchronous version of parse
   *   stringify: fn # the function definition to use when serializing to a string asynchronously
   *   stringifySync: fn the synchronous version of stringify
   * }
   * @param {String} name - the name of the handler
   * @param {Object} config - the handler object
  ###
  addHandler: (name, config) ->
    @handlers[name] = config # add the handler to handler store
    for extension in config.extensions
      @handler_map[extension] = name # map the handler's extensions to the handler

  ###*
   * matches a file's extension to the correct data handler
   * @api private
   * @param  {String} file - the config file's path
   * @return {Object} handler - the handler object to use for parsing this file
  ###
  get_handler = (file) ->
    handler = @handlers[@handler_map[path.extname(file)]]
    handler.file = file
    return handler

module.exports = Parser
