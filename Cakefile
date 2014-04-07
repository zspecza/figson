{exec}   = require 'child_process'

run = (commands) ->
  commands = commands.split('\n').join ' && '
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

