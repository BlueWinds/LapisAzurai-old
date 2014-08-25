LapisAzurai
===========

The source repository for [the game](site.brothels.im).

# Compiling
The git repository doesn't include the compiled files, necessary for actually playing. If you just want to play the game, check the [development blog](site.brothels.im) for the latest download.

The rest of this section is dedicated to setting up a development environment so you can modify the source. It will assume at least vague familiarity on your part with command line, and that you're running Linux. Instructions will vary for other environments.

The game's source code resides in, surprise surprise, the /src directory. It is written in [Coffeescript](coffeescript.org) and CSS, and runs in a web browser. Browsers don't know how to handle coffeescript though - it needs to be compiled to javascript first, and all the files moved into their proper locations.

For that, you'll need to install [NodeJS](nodejs.org) and [Grunt](gruntjs.com) (which can be installed via NPM: `npm install -g grunt-cli`). With those two pieces of software installed, use npm to pull in all the other development dependencies from the command line:

```
$ cd /wherever/you/downloaded/the/repository
$ npm install
```

Now you should be able to build the game:

```
grunt full-build
```

`grunt lib` minifies all the external libraries, while `grunt compile` copies the game js and css. `grunt sprites` compiles the spritesheets, and is by far the slowest part of the full-build process - fortunately, you won't need to re-run it unless you change the images or fiddle with a character's colors.

The default grunt task (invoked with just `grunt`) compiles all of the game's Coffeescript and copies its css into the /game directory. It then monitors all the .coffee and .css files for changes and recompiles as necessary for as long as you leave it running. It also compresses all the game's images (without lowering their quality). This will be very much faster on subsequent runs - it only updates images that have changed.

If that all went well, you can now open index.html and it will load your new freshly compiled copy of the game. :)
