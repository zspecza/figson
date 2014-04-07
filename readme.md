Figson
======

[![Build Status](https://travis-ci.org/declandewet/figson.svg?branch=master)](https://travis-ci.org/declandewet/figson)

Simple config storage (warning: temporary synchronous API).

> **Note:** This project is in early development, and versioning is a little
  different. [Read this](http://markup.im/#q4_cRZ1Q) for more details.

### Why should you care?

You have written configuration settings into a JSON file, `require()`'d it
into your app and have been happy doing so. Unfortunately, a use case pops
up where you would like to write settings to that file as well. So you
start to replace your `require` calls with a painstaking mess of
`fs.readFile` and `fs.writeFile` calls, coupled together with a few `JSON.parse`
and `JSON.stringify` calls. Messy.

You also would like to interchange your file format to something prettier,
perhaps [CSON](https://github.com/bevry/cson) or [YAML](http://www.yaml.org/).

This module intends to make doing just that a whole lot easier for you.

### WARNING:

Not all of the features described are yet complete and the API operations are
currently performed ***synchronously*** as this module is in very early
development. Please read the note linked at the top of this README to find
out why.

### Installation

```
$ npm install figson --save
```

### Usage

```javascript
var figson = require('figson');
var path = require('path');

// load a JSON file
var config = figson(path.resolve('./config.json'));

// set a property
config.set('foo', 'bar'); // => {"foo": "bar"} (saved to config.json)

// get a property
config.get('foo'); // => "bar"

// update a property
// (this tries to get the property first & checks if it is undefined)
config.update('foo', 'baz'); // => {"foo": "baz"} (saved to config.json)
config.update('fiz', 'buzz'); // => throws an error

// delete a property
config.destroy('foo'); // => {} (saved to config.json)

// deeply nested properties are supported, too!
config.set('foo.bar.baz.bim[0]', 'bash');
/**
 * outputs (saved to config.json):
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
```

Roadmap:
--------

- Add CSON support
- Add YAML support
- Convert to asynchronous API
- Add method chaining
- Refactor how files work
