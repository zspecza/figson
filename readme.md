Figson
======

[![Build Status](https://travis-ci.org/declandewet/figson.svg?branch=master)](https://travis-ci.org/declandewet/figson)
[![NPM version](https://badge.fury.io/js/figson.svg)](http://badge.fury.io/js/figson)
[![Dependency Status](https://david-dm.org/declandewet/figson.svg)](https://david-dm.org/declandewet/figson)
[![devDependency Status](https://david-dm.org/declandewet/figson/dev-status.svg)](https://david-dm.org/declandewet/figson#info=devDependencies)
[![Coverage Status](https://coveralls.io/repos/declandewet/figson/badge.png?branch=master)](https://coveralls.io/r/declandewet/figson)

Simple config storage (warning: temporary synchronous API).

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

### Asynchronous:

```javascript
var figson = require('figson');
var path = require('path');

// load a JSON file
figson.parse(path.resolve('./config.json'), function(error, config) {

  if (error) { throw error; }

  // we now have access to the config file
  console.log(config.data); // an object representing the file's data

  // set a property
  config.set('foo', 'bar'); // => {"foo": "bar"}

  // get a property
  config.get('foo'); // => "bar"

  // update a property
  // (this tries to get the property first & checks if it is undefined)
  config.update('foo', 'baz'); // => {"foo": "baz"}
  config.update('fiz', 'buzz'); // => throws an error

  // delete a property
  config.destroy('foo'); // => {} (saved to config.json)

  // deeply nested properties are supported, too!
  config.set('foo.bar.baz.bim[0]', 'bash');
  /**
   * outputs:
   * {
   *   "foo": {
   *     "bar": {
   *       "baz": {
   *         "bim": ["bash"]
   *       }
   *     }
   *   }
   * }
   */

  // finally, save the file
  config.save(function(error) {
    if (error) { throw error; }
  });

});
```

### Synchronous:

```javascript
var figson = require('figson');
var path = require('path');

// load a JSON file
var config = figson.parseSync(path.resolve('./config.json'));

// we now have access to the config file
console.log(config.data); // an object representing the file's data

// set a property
config.set('foo', 'bar'); // => {"foo": "bar"}

// get a property
config.get('foo'); // => "bar"

// update a property
// (this tries to get the property first & checks if it is undefined)
config.update('foo', 'baz'); // => {"foo": "baz"}
config.update('fiz', 'buzz'); // => throws an error

// delete a property
config.destroy('foo'); // => {} (saved to config.json)

// deeply nested properties are supported, too!
config.set('foo.bar.baz.bim[0]', 'bash');
/**
 * outputs:
 * {
 *   "foo": {
 *     "bar": {
 *       "baz": {
 *         "bim": ["bash"]
 *       }
 *     }
 *   }
 * }
 */

// finally, save the file
config.save();
```

Roadmap:
--------

- Add CSON support
- Add YAML support
- possibly add XML support?
- Add method chaining
