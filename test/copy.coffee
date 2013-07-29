fs = require 'fs'
pifpaf = require '../index'
should = require 'should'

describe 'Copy', () ->
  beforeEach (done) ->
    prom = pifpaf.rm ['origFile.txt', 'copyFile.txt']
    prom.then () ->
      done()

  afterEach (done) ->
    prom = pifpaf.rm ['origFile.txt', 'copyFile.txt']
    prom.then () ->
      done()

  it 'should copy a non empty file', (done) ->
    fs.writeFile 'origFile.txt', 'Hello world', (err) ->
      if err
        done err
      pifpaf.copy(['origFile.txt', 'copyFile.txt']).then () ->
        console.log "hello world", err
        pifpaf.isFile 'copyFile.txt'
      .then (check) ->
        check.should.eql true
        done()
      .fail (err) ->
        done err

  it 'should copy an empty file', (done) ->
    pifpaf.touch('origFile.txt').then () ->
      pifpaf.copy ['origFile.txt', 'copyFile.txt']
    .then () ->
      pifpaf.isFile 'copyFile.txt'
    .then (check) ->
      check.should.eql true
      done()
    .fail (err) ->
      done err
