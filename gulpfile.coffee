gulp         = require 'gulp'
changed      = require 'gulp-changed'
sass         = require 'gulp-sass'
csso         = require 'gulp-csso'
autoprefixer = require 'gulp-autoprefixer'
notify       = require 'gulp-notify'
uglify       = require 'gulp-uglify'
concat       = require 'gulp-concat-util'
addsrc       = require 'gulp-add-src'
sourcemaps   = require 'gulp-sourcemaps'
deploy       = require 'gulp-gh-pages'

browserify   = require 'browserify'
watchify     = require 'watchify'
source       = require 'vinyl-source-stream'
buffer       = require 'vinyl-buffer'
babelify     = require 'babelify'
del          = require 'del'
browserSync  = require 'browser-sync'
reactify     = require 'coffee-reactify'

reload = browserSync.reload

P  =
  app    : './app/scripts/app.coffee'
  scss   : './app/styles/main.scss'
  slide  : './app/content/slide.md'
  image  : './app/images/*'
  remark : './bower_components/remark/out/remark.min.js'
  bundle : 'app.js'
  distJs : 'dist/js'
  distCss: 'dist/css'
  distImg: 'dist/img'

gulp.task 'clean', (cb) ->
  del ['dist'], cb

gulp.task 'browserSync', ->
  browserSync
    server: baseDir: './'

gulp.task 'watchify', ->
  bundler = watchify browserify P.app, watchify.args

  rebundle = ->
    bundler
      .bundle()
      .on 'error', notify.onError()
      .pipe source P.bundle
      .pipe buffer()
      # append remark.min.js
      .pipe addsrc P.remark
      .pipe concat P.bundle
      .pipe gulp.dest P.distJs
      .pipe reload stream: true

  bundler
    .transform extension: 'coffee', reactify
    .transform babelify
    .on 'update', rebundle
  rebundle()

gulp.task 'browserify', ->
  browserify P.app
    .transform extension: 'coffee', reactify
    .transform babelify
    .bundle()
    .pipe source P.bundle
    .pipe buffer()
    # append remark.min.js
    .pipe addsrc P.remark
    .pipe concat P.bundle
    .pipe sourcemaps.init loadMaps: true
    .pipe uglify()
    .pipe sourcemaps.write './'
    .pipe gulp.dest P.distJs

gulp.task 'styles', ->
  gulp.src P.scss
    .pipe changed P.distCss
    .pipe sass errLogToConsole: true
    .on 'error', notify.onError()
    .pipe autoprefixer 'last 1 version'
    .pipe csso()
    .pipe gulp.dest P.distCss
    .pipe reload stream: true

gulp.task 'slide', ->
  gulp.src P.slide
    .pipe changed 'dist'
    .pipe gulp.dest 'dist'
    .pipe reload stream: true

gulp.task 'image', ->
  gulp.src P.image
    .pipe gulp.dest P.distImg

gulp.task 'watchTask', ->
  gulp.watch P.scss, ['styles']
  gulp.watch P.slide, ['slide']

gulp.task 'watch', ['clean'], ->
  gulp.start ['browserSync', 'watchTask', 'watchify', 'slide', 'styles', 'image']

gulp.task 'build', ['clean'], ->
  process.env.NODE_ENV = 'production'
  gulp.start ['browserify', 'slide', 'styles', 'image']

gulp.task 'deploy', ['build'],  ->
  gulp.src './dist/**/*'
    .pipe deploy()

gulp.task 'default', ->
  console.log 'Run "gulp watch or gulp build"'
