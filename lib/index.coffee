nodefn   = require 'when/node'
W        = require 'when'
fs       = require 'fs'

Parser = require './parser'
figson = new Parser()

W.map(nodefn.call(fs.readdir, './lib/handlers/'), (handler) ->
  handler = handler.substr(0, handler.lastIndexOf('.'))
  figson.addHandler handler, require('./handlers/' + handler)
).done(null, console.error.bind(console))

module.exports = figson
