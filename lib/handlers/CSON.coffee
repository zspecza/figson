cson = require 'cson-safe'

old_stringify = cson.stringify

cson.stringify = (args...) ->
  str = old_stringify(args...)
  new_str =
    str
      .replace(/\,/g, '')
      .replace(/\"(\w+)\"\:/g, '$1:')
      .replace(/(?:\{|\})/g, '')
      .replace(/\:\ +/g, ':')
      .replace(/\:(\"|\[)/g, ': $1')
      .trim()
  '{\n  ' + new_str + '\n}'

module.exports =
  extensions: ['.cson']
  parse: cson.parse
  parseSync: cson.parse
  stringify: cson.stringify
  stringifySync: cson.stringify
