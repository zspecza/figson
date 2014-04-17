yaml = require 'js-yaml'

module.exports =
  extensions: ['.yml', '.yaml']
  parse: yaml.safeLoad
  parseSync: yaml.safeLoad
  stringify: yaml.safeDump
  stringifySync: yaml.safeDump
