Figson
======

[![Build Status](https://travis-ci.org/declandewet/figson.svg?branch=master)](https://travis-ci.org/declandewet/figson)
[![NPM version](https://badge.fury.io/js/figson.svg)](http://badge.fury.io/js/figson)
[![Dependency Status](https://david-dm.org/declandewet/figson.svg)](https://david-dm.org/declandewet/figson)
[![devDependency Status](https://david-dm.org/declandewet/figson/dev-status.svg)](https://david-dm.org/declandewet/figson#info=devDependencies)
[![Coverage Status](https://coveralls.io/repos/declandewet/figson/badge.png?branch=master)](https://coveralls.io/r/declandewet/figson)

Simple configuration storage.

> **Note:** This project is in early development, and versioning is a little
  different. [Read this](http://markup.im/#q4_cRZ1Q) for more details.

### Why should you care?

This project is in very early development, but already makes working with
JSON configuration files a lot easier.

### Installation

```bash
$ npm install figson --save
```

--------------------------------------------------------------------------------

Usage
-----

### Async Example

```javascript
var figson = require('figson');
var path   = require('path');

figson.parse(path.resolve('./config.json'), function(error, config) {
  if (error) { throw error; }
  config.set('foo', 'bar');
  config.save(function(error) {
    if (error) { throw error; }
  });
});
```

### Sync Example

```javascript
var figson = require('figson');
var path   = require('path');

try {
  var config = figson.parseSync(path.resolve('./config.json');
  config.set('foo', 'bar');
  config.save();
} catch (error) {
  throw error;
}
```

### Figson API

Figson itself exposes two methods:

#### figson.parse(config_file, callback);
Asynchronously reads a JSON file, parses it, and exposes an `error` and a `config`
object to the callback (`function(error, config) {}`). `config_file` is the path
to the file.

#### figson.parseSync(config_file)
Synchronous version of `figson.parse`. Returns a `config` object.

### Config API

The `config` object is basically just a tiny wrapper around the data inside
the JSON file. It exposes a few properties and methods. All of `config`'s methods
are chainable, and accessing a property with a `config` method uses a tiny
DSL string similar to how you would access that property using JavaScript's dot
notation.

#### config.data
An object representing the JSON file.

#### config.val()
Returns the value of the last key/property in the `config` chain.

#### config.get([key])
Retrieves the value of the given `key`. If no key is provided, it retrieves
the value of the last known key in the chain.

`key` is a string containing the object property who's value you want to retrieve.

Example:

```javascript
// { some: { property: 'value1' }}
config.get('some.property').val() // => value1
// or
config.get().val() // => value1
```

#### config.set([key], value)

Sets the `key` to the `value`. If no `key` is given, uses the most recent key
in the chain. The `value` can be a string, number, object, array or null.

Example:

```javascript
// { an: { array: { property: [] }}}
config.set('an.array.property[0]', 'the value') // { an: { array: { property: ['the value'] }}}
// or
config.set('a different value') // { an: { array: { property: ['a different value'] }}}

```

#### config.update([key], value)

First, attempts a `get()` to determine the existence of the given `key` property. If it
exists, it will then call `set()` with the new `value`. Otherwise, throws an error.
Useful if you need to safely set a value. If no `key` is given, updates the
`key` from the last call in the chain.

Example:

```javascript
config.update('foo', 'baz')
config.get('foo').update('baz')
```

#### config.destroy([key])

"deletes" the given `key` property by setting it's value to `undefined`. If no
key is given, it will "delete" the key from the last method in the chain.

Example:

```javascript
config.destroy('foo');
config.get('bar').destroy()
```

#### config.find(partial_key)

This method is useful for accessing properties that are very deeply nested.
Suppose you have an object:

```javascript
{
  a: {
    very: {
      deeply: {
        nested: {
          property: 'value'
        }
      }
    }
  }
}
```

You want to update `a.very.deeply.nested.property` to have the value `foobar`,
but you don't want to have to type out the whole property name. Just use `.find()`!
As long as the property ends with the key you pass to `find()`, it'll work:

```javascript
config.find('nested.property').set('foobar') // done!
```

#### config.save([callback])

This saves the current state of `config.data` to the JSON file. This is a synchronous
operation, but passing in an optional callback (`function(error) {}`) will make it
perform asynchronously.

Example:

```javascript
config.save(); // synchronous

// asynchronous
config.save(function(error) {
  if (error) { throw error; }
});
```

Contributing:
-------------

Please read the [contribution guidelines](https://github.com/declandewet/figson/blob/master/contributing.md).

Roadmap:
--------

- Add custom handler functionality
