Lapis Azurai
===========

The source repository for [Lapis Azurai](http://winds.blue/about).

# Compiling
The git repository doesn't include the compiled files, necessary for actually playing. If you just want to play the game, check the [development blog](http://winds.blue/) for the latest download.

The rest of this section is dedicated to setting up a development environment so you can modify the source. It will assume at least vague familiarity on your part with command line, and that you're running Linux. Instructions will vary for other environments.

The game's source code resides in, surprise surprise, the /src directory. It is written in [Coffeescript](http://coffeescript.org/) and CSS, and runs in a web browser. Browsers don't know how to handle coffeescript though - it needs to be compiled to javascript first, and all the files moved into their proper locations.

For that, you'll need to install [NodeJS](http://nodejs.org/) and [Grunt](http://gruntjs.com/) (which can be installed via NPM: `npm install -g grunt-cli`). With those two pieces of software installed, use npm to pull in all the other development dependencies from the command line:

```
$ cd /wherever/you/downloaded/the/repository
$ npm install
```

Now you should be able to build the game:

```
$ grunt full-build
```

`grunt lib` minifies all the external libraries, while `grunt compile` copies the game js and css. `grunt dump` regenerates dump.html from the coffeescript sources. `grunt sprites` compiles the spritesheets, and is by far the slowest part of the full-build process - fortunately, you won't need to re-run it unless you change the images or fiddle with a character's colors. It accepts people's names as an argument - `grunt sprites:Natalie` will compile images only for her.

The default grunt task (invoked with just `grunt`) compiles all of the game's Coffeescript and copies the css into the "/public/game" directory. It then monitors the files in "/src" for changes and recompiles as necessary for as long as you leave it running in the background.

If that all went well (no errors), you can now open "/public/index.html" and it will load your new freshly compiled copy of the game. For the development you can use the task `grunt dev` to start a process which opens a new window and refreshes the browser automatically on changes :)

# License

## tl;dr
Share all you like, upload pictures to image boards, make a torrent. Give credit (a link to "created by BlueWinds at http://winds.blue" is enough).

Use the game engine to make your own stuff, but ask me first if you want to use my characters or art in a commercial manner.

## Longer
* Everything in the "/src/content" folder is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 License](http://creativecommons.org/licenses/by-nc-sa/4.0/)
  That means you can copy and distribute this folder (and any graphics, text, characters, etc. within) freely, as long as you (A) give credit (B) do not sell it (C) do not include it in another work that is being *sold*.
  If you do include it, or a derivative of it in another work, that work must be similarly licensed.
* All code in the "/src/engine" folder is licensed under [the GPL v2](http://www.gnu.org/licenses/gpl.txt)
  This means that you can redistribute this folder freely as long as you (A) give credit.
  If you do include it (or a derivative of it) in another work, that work must be freely licensed.
* Each library in the "/src/lib" directory has its own license. See the header of each file there for details (most are MIT or public domain).
