pifpaf = require '../index'
should = require 'should'

describe 'Mkdir', () ->
  beforeEach (done) ->
    prom = pifpaf.rm ['test-mkdir', 'test-structure']
    prom.then () ->
      done()

  afterEach (done) ->
    prom = pifpaf.rm ['test-mkdir', 'test-structure']
    prom.then () ->
      done()

  it 'should mkdir a folder', (done) ->
    pifpaf.mkdir('test-mkdir').then () ->
      pifpaf.isDirectory 'test-mkdir'
    .then (check) ->
      check.should.eql true
      done()
    .fail (err) ->
      done err

  it 'should create the full folder structure if needed', (done) ->
    pifpaf.mkdir('test-structure/mkdir').then () ->
      pifpaf.isDirectory 'test-structure'
    .then (check) ->
      check.should.eql true
      pifpaf.isDirectory 'test-structure/mkdir'
    .then (check) ->
      check.should.eql true
      done()
    .fail (err) ->
      done err

  it 'should create all folders in a list', (done) ->
    pifpaf.mkdir(['test-structure', 'test-mkdir']).then () ->
      pifpaf.isDirectory 'test-structure'
    .then (check) ->
      check.should.eql true
      pifpaf.isDirectory 'test-mkdir'
    .then (check) ->
      check.should.eql true
      done()
    .fail (err) ->
      done err

