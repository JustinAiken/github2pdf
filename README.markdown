# Github2PDF
#### Turn your github repos into PDF's!

Just give a repo and watch it turn all the github web views into nice juicy files ready for printing!

Send your greatest work off to a publisher, get it bound in fancy leather, and peruse your source code whenever you want to pull the book off your mahogany shelf.

### What it looks like:
Each file 'printed' off github will look like this:

![Screenshot](doc/screenshot.png)

### Usage:

1. Install phantomjs: `brew install phantomjs`
2. Clone the project: `git clone git@github.com:JustinAiken/github2pdf.git`
3. Go to the project directory: `cd github2pdf`
4. Run: `phantomjs github2pdf.coffee rails activerecord`
8. ???
9. Profit!

### But it does have one small problem:

Despite being called github2pdf, it's actually github2png, since PhantomJS has an [outstanding issue](https://github.com/ariya/phantomjs/issues/10465) where clipRect is ignored with PDF's.  So for now, we're write to .png instead.

## Credits

Original author: [Justin Aiken](https://github.com/JustinAiken)

## Links

* [Source](https://github.com/JustinAiken/github2pdf)
* [Bug Tracker](https://github.com/JustinAiken/github2pdf/issues)

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Commit, do not mess with rakefile, version, or history.
  * If you want to have your own version, that is fine but bump version in a commit by itself so I can ignore when I pull
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2013 Justin Aiken MIT license (see LICENSE for details).
