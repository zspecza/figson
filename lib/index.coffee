nodefn   = require 'when/node'
W        = require 'when'
fs       = require 'fs'
Parser   = require './parser'
figson   = new Parser()

json_handler = require './handlers/JSON'
cson_handler = require './handlers/CSON'
yaml_handler = require './handlers/YAML'

# add file type handlers
figson.addHandler 'JSON', json_handler
figson.addHandler 'CSON', cson_handler
figson.addHandler 'YAML', yaml_handler

module.exports = figson
