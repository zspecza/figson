{exec}   = require 'child_process'
{EOL}    = require 'os'

run = (commands) ->
  commands = commands.split("#{EOL}").join ' && '
  child = exec commands
  child.stderr.on 'data', (data) ->
    process.stderr.write data
  child.stdout.on 'data', (data) ->
    process.stdout.write data

task 'build', ->
  run """
      mv lib src
      coffee -o lib -c src
      """

task 'unbuild', ->
  run """
      rm -rf lib
      mv src lib
      """

task 'publish', ->
  run """
      cake build
      npm publish .
      cake unbuild
      """

