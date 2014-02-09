fs = require 'fs'
path = require 'path'
Q = require 'q'
_ = require 'underscore'
rimraf = require 'rimraf'

isFs = (file, check) ->
  prom = Q.when () ->
  prom.then () ->
    defer = Q.defer()
    fs.stat file, (err, stat) ->
      if err != null
        if err.code != 'ENOENT'
          return defer.reject err
      defer.resolve stat
    defer.promise
  .then (stat) ->
    if stat == undefined
      return false
    else
      stat[check]()

module.exports.isFile = isFile = (file) ->
  isFs file, "isFile"

module.exports.isDirectory = isDirectory = (file) ->
  isFs file, "isDirectory"

forFileInList = (list, done) ->
  prom = Q.when () ->
  if list instanceof Array
    _.each list, (file) ->
      prom = prom.then () ->
        done file
  else
    prom = prom.then () ->
      done list
  prom

module.exports.mkdir = mkdir = (file) ->
  forFileInList file, (file) ->
    parent = path.dirname file
    isDirectory(parent).then (isDir) ->
      if not isDir
        return mkdir parent
    .then () ->
      defer = Q.defer()
      fs.mkdir file, (err) ->
        if err != null and err.code == 'EEXIST'
          err = null
          if err != null
            return defer.reject err
        defer.resolve()
      defer.promise

module.exports.touch = touch = (file) ->
  forFileInList file, (file) ->
    parent = path.dirname file
    if parent != "."
      prom = mkdir parent
    else
      prom = Q.when () ->
    prom.then () ->
      Q.nfcall fs.open, file, 'a'
    .then (fd) ->
      Q.nfcall fs.close, fd

module.exports.rm = rm = (file) ->
  forFileInList file, (file) ->
    defer = Q.defer()
    prom = defer.promise
    rimraf file, (err) ->
      if err
        return defer.reject err
      defer.resolve()
    prom

module.exports.copy = copy = (file) ->
  defer = Q.defer()
  rd = fs.createReadStream file[0]
  wr = fs.createWriteStream file[1]
  rd.on "error", (err) -> defer.reject err
  wr.on "error", (err) -> defer.reject err
  wr.on "close", (err) ->
    if err
      defer.reject err
    defer.resolve()
  rd.pipe wr
  defer.promise

module.exports.read = read = (file) ->
  Q.nfcall fs.readFile, file

module.exports.write = write = (file, buffer) ->
  Q.nfcall fs.writeFile, file, buffer

