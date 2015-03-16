# Remark Starterify

:rocket: Fast develop & deploy [Remark](https://github.com/gnab/remark) slideshow based on [react-starterify](https://github.com/chitacan/react-starterify)

## Usage

Make sure you have [node](https://nodejs.org/), [gulp](https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md), [bower](http://bower.io/#install-bower) :hand:

Before to get started, clone this project. (remove `./git` to fresh start)

    $ git clone chitacan/remark-starterify
    $ cd remark-starterify
    $ rm -rf .git/
    $ npm install && bower install

Start developing with

    $ gulp watch

Build with

    $ gulp build

Depoly to `gh-pages` with

    $ gulp deploy

## Make Slideshow

* To make slideshow, edit `app/content/slide.md` ([see](https://github.com/gnab/remark/wiki/Markdown))
* To make script component(with [react](http://facebook.github.io/react/)), edit `app/scripts/app.coffee`
