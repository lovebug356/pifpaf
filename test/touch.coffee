pifpaf = require '../index'

describe 'Touch', () ->
  beforeEach (done) ->
    pifpaf.rm(['test-touch', 'test-touch.txt', 'test.txt']).then () ->
      done()
    .fail (err) ->
      done err

  afterEach (done) ->
    pifpaf.rm(['test-touch', 'test-touch.txt', 'test.txt']).then () ->
      done()
    .fail (err) ->
      done err

  it 'should touch a file', (done) ->
    pifpaf.isFile('test-touch.txt').then (check) ->
      check.should.eql false
      pifpaf.touch 'test-touch.txt'
    .then () ->
      pifpaf.isFile 'test-touch.txt'
    .then (check) ->
      check.should.eql true
      done()
    .fail (err) ->
      done err

  it 'should create the folder structure of files if needed', (done) ->
    pifpaf.touch('test-touch/test.txt').then () ->
      pifpaf.isDirectory 'test-touch'
    .then (check) ->
      check.should.eql true
      pifpaf.isFile 'test-touch/test.txt'
    .then (check) ->
      check.should.eql true
      done()
    .fail (err) ->
      done err

  it 'should touch all files if a list is provided', (done) ->
    pifpaf.isFile('test.txt').then (check) ->
      check.should.eql false
      pifpaf.touch ['test-touch/test.txt', 'test.txt']
    .then () ->
      pifpaf.isFile 'test-touch/test.txt'
    .then (check) ->
      check.should.eql true
      pifpaf.isFile 'test.txt'
    .then (check) ->
      check.should.eql true
      done()
    .fail (err) ->
      done err
