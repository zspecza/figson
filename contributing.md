How to Contribute
=================

> **N.B.** - Please include tests in your contribution if required.

Commands
--------

> **Note**: remember to run `npm install` before executing these commands.

- `npm run build` - renames `lib/` to `src/` and then compiles the CoffeeScript
  from `src/` into `lib/`
- `npm run unbuild` - removes `lib/` and renames `src/` to `lib/`
- `npm run release` - runs `npm run build`, then `npm publish .`, then `npm run unbuild`
- `npm run test` - runs the tests

Goal
----

The goal with this library is to create a package that can handle saving to
and reading from configuration files. Right now, it works with JSON; but the
ultimate goal here is to be able to write adapters that map parsing logic
to different file extensions, so that different file formats can be parsed. JSON,
YAML and CSON are already baked-in and supported.

Needs Refactoring
-----------------

There are certain parts of this module that could be done a lot more efficiently.
If you can make these parts better, you are welcome to.

- `flatten_object` - This needs to be made more efficient.
  [link](https://github.com/declandewet/figson/blob/master/lib/util.coffee#L8-L21)

- `find` - This needs to be made more efficient.
  [link](https://github.com/declandewet/figson/blob/master/lib/config.coffee#L27-L34)

- `destroy` - This currently only "destroys" a property by setting it's value
  to `undefined`. It would be nice if it actually deleted the property entirely.
  [link](https://github.com/declandewet/figson/blob/master/lib/config.coffee#L86-L89)

Miscellaneous
-------------

The current way you pass a file path to `figson.parse` kind of requires you
to resolve that path to an absolute path first. For example:

```javascript
var figson = require('figson');
var path   = require('path');

figson.parse(path.resolve('./config.json'), function(error, config) {

});
```

It would be nice to not have to resolve that path, and I feel like this could
be done using Node's `module.parent`, so that this syntax will work:

```javascript
var figson = require('figson');

figson.parse('./config.js', function(error, config) {

});
```

If you know how to do this, please submit a PR! :)
