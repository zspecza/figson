cson = require 'cson'

module.exports =
  extensions: ['.cson']
  parse: cson.parse
  parseSync: cson.parseSync
  stringify: cson.stringify
  stringifySync: cson.stringifySync
