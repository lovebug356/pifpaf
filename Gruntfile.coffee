path = require 'path'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      release:
        src: [
          './lib'
        ]
    mochaTest:
      files: ['./lib/test/**/*.js']
    mochaTestConfig:
      options:
        reporter: 'spec'
    coffee:
      scripts:
        files: [
          cwd: './src'
          src: ['./**/*.coffee']
          dest: './lib'
          expand: true
          ext: '.js'
        ,
          cwd: './'
          src: ['./test/**/*.coffee']
          dest: './lib'
          expand: true
          ext: '.js'
        ]
        options:
          bare: true
    watch:
      build:
        files: ['./src/**/*.coffee', './test/**/*.coffee']
        tasks: ['default']
      test:
        files: ['./src/**/*.coffee', './test/**/*.coffee']
        tasks: ['test']

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.registerTask 'default', [
    'clean'
    'coffee:scripts'
  ]

  grunt.registerTask 'build', [
    'default'
  ]

  grunt.registerTask 'test', [
    'default'
    'mochaTest'
  ]
