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
YAML and CSON are planned to be baked-in, but it should be possible to write
an adapter to handle any file (XML, for example). If you can add this functionality
before I do, please feel free to submit a pull request (with tests!).

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
