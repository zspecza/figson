_   = require 'lodash'

###*
 * flattens a deep object into a shallow figson-style config parse syntax object
 * @param  {Object} ob - the deep object to flatten
 * @return {Object} - the newly flattened object
###
exports.flatten_object = (ob) ->
  to_return = {}
  flag = false
  for own i of ob
    if _.isArray(ob[i]) then to_return["#{i}[#{y}]"] = x for x, y in ob[i]
    else if _.isObject(ob[i])
        flat_object = exports.flatten_object(ob[i])
        to_return["#{i}.#{x}"] = flat_object[x] for own x of flat_object
    else
      to_return[i] = ob[i]
  for own i of to_return
    if _.isObject(to_return[i]) then flag = true ; break
  if flag is true then to_return = exports.flatten_object(to_return)
  else to_return

###*
 * detects if a string ends with another string
 * @param  {String} str - the string to search
 * @param  {String} ends - the suffix to look for
 * @return {Boolean} - true if the string ends with the suffix
###
exports.ends_with = (str, ends) ->
  if ends is '' then true
  if not str? or not ends? then false
  str = String(str)
  ends = String(ends)
  str.length >= ends.length and str.slice(str.length - ends.length) is ends
