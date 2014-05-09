'use strict'

gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
gutil   = require 'gulp-util'
less    = require 'gulp-less'
path    = require 'path'
bower   = require 'gulp-bower'
connect = require 'gulp-connect'

gulp.task 'coffee', ->
    gulp.src ['./app/scripts/*.coffee', './app/scripts/**/*.coffee']
        .pipe(coffee({bare: true}).on('error', gutil.log))
        .pipe(gulp.dest('./dist/scripts/'))

gulp.task 'less', ->
    gulp.src ['./app/styles/*.less']
        .pipe(less({paths: [ path.join(__dirname, 'less', 'includes')]}))
        .pipe(gulp.dest('./dist/styles/'))

gulp.task 'views', ->
    gulp.src ['./app/views/*.html']
        .pipe(gulp.dest('./dist/views/'))

gulp.task 'index', ->
    gulp.src ['./app/index.html']
        .pipe(gulp.dest('./dist/'))

gulp.task 'bower', ->
    bower()
        .pipe(gulp.dest('./dist/bower_components/'))

gulp.task 'watch', ->
    gulp.watch [
        './dist/*.html',
        './dist/**/*.html',
        './dist/**/*.js',
        './dist/**/*.css',
        './dist/**/**/*.js'
    ] , (event)->
        gulp.src(event.path)
            .pipe(connect.reload())

    gulp.watch [
        'app/scripts/*.coffee',
        'app/scripts/**/*.coffee'
    ] , ['coffee']

    gulp.watch [
        'app/styles/*.less'
    ] , ['less']

    gulp.watch [
        'app/views/*.html'
    ] , ['views']

    gulp.watch [
        'app/index.html'
    ] , ['index']

    gulp.watch [
        'app/bower_components/**/*'
    ] , ['bower']

gulp.task 'connect', ->
    connect.server({
        root: ['dist'],
        port: 9000,
        livereload: true
    })

gulp.task 'default', ['connect', 'coffee', 'less', 'views', 'index', 'bower', 'watch']
