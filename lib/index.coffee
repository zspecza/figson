nodefn   = require 'when/node'
W        = require 'when'
fs       = require 'fs'
Parser   = require './parser'
figson   = new Parser()

# read the `./lib/handlers/` directory and iterate each file as 'handler'
W.map(nodefn.call(fs.readdir, './lib/handlers/'), (handler) ->

  # remove the file extension from the handler filename
  handler = handler.substr(0, handler.lastIndexOf('.'))

  # add the handler to Figson's internal handler store
  figson.addHandler handler, require('./handlers/' + handler)

).done(null, console.error.bind(console))

module.exports = figson
