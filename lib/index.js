var Q, copy, forFileInList, fs, isDirectory, isFile, isFs, mkdir, path, read, rimraf, rm, touch, write, _;

fs = require('fs');

path = require('path');

Q = require('q');

_ = require('underscore');

rimraf = require('rimraf');

isFs = function(file, check) {
  var prom;
  prom = Q.when(function() {});
  return prom.then(function() {
    var defer;
    defer = Q.defer();
    fs.stat(file, function(err, stat) {
      if (err !== null) {
        if (err.code !== 'ENOENT') {
          return defer.reject(err);
        }
      }
      return defer.resolve(stat);
    });
    return defer.promise;
  }).then(function(stat) {
    if (stat === void 0) {
      return false;
    } else {
      return stat[check]();
    }
  });
};

module.exports.isFile = isFile = function(file) {
  return isFs(file, "isFile");
};

module.exports.isDirectory = isDirectory = function(file) {
  return isFs(file, "isDirectory");
};

forFileInList = function(list, done) {
  var prom;
  prom = Q.when(function() {});
  if (list instanceof Array) {
    _.each(list, function(file) {
      return prom = prom.then(function() {
        return done(file);
      });
    });
  } else {
    prom = prom.then(function() {
      return done(list);
    });
  }
  return prom;
};

module.exports.mkdir = mkdir = function(file) {
  return forFileInList(file, function(file) {
    var parent, prom;
    prom = Q.when(function() {});
    parent = path.dirname(file);
    if (parent !== '.') {
      prom = mkdir(parent);
    }
    return prom.then(function() {
      var defer;
      defer = Q.defer();
      fs.mkdir(file, function(err) {
        if (err !== null && err.code === 'EEXIST') {
          err = null;
          if (err !== null) {
            return defer.reject(err);
          }
        }
        return defer.resolve();
      });
      return defer.promise;
    });
  });
};

module.exports.touch = touch = function(file) {
  return forFileInList(file, function(file) {
    var parent, prom;
    parent = path.dirname(file);
    if (parent !== ".") {
      prom = mkdir(parent);
    } else {
      prom = Q.when(function() {});
    }
    return prom.then(function() {
      return Q.nfcall(fs.open, file, 'a');
    }).then(function(fd) {
      return Q.nfcall(fs.close, fd);
    });
  });
};

module.exports.rm = rm = function(file) {
  return forFileInList(file, function(file) {
    var defer, prom;
    defer = Q.defer();
    prom = defer.promise;
    rimraf(file, function(err) {
      if (err) {
        return defer.reject(err);
      }
      return defer.resolve();
    });
    return prom;
  });
};

module.exports.copy = copy = function(file) {
  var defer, rd, wr;
  defer = Q.defer();
  rd = fs.createReadStream(file[0]);
  wr = fs.createWriteStream(file[1]);
  rd.on("error", function(err) {
    return defer.reject(err);
  });
  wr.on("error", function(err) {
    return defer.reject(err);
  });
  wr.on("close", function(err) {
    if (err) {
      defer.reject(err);
    }
    return defer.resolve();
  });
  rd.pipe(wr);
  return defer.promise;
};

module.exports.read = read = function(file) {
  return Q.nfcall(fs.readFile, file);
};

module.exports.write = write = function(file, buffer) {
  return Q.nfcall(fs.writeFile, file, buffer);
};
