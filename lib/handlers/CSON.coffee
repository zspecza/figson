cson = require 'cson-safe'

module.exports =
  extensions: ['.cson']
  parse: cson.parse
  parseSync: cson.parse
  stringify: cson.stringify
  stringifySync: cson.stringify
