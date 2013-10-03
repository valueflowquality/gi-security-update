mongo = require 'mongodb'

sysId = mongo.ObjectID('5240630360d7400b17999999')
aliceId = mongo.ObjectID('5240630360d7400b18000001')

createSystems = (db, cb) ->
  sys =
    name: "securityTest"
    _id: sysId
  db.createCollection 'systems', (err, coll) ->
    coll.insert sys, (err, docs) ->
      cb()

createEnvironments = (db, cb) ->
  env =
    host: 'test.gint-security.com'
    name: 'testenv3'
    systemId: sysId

  db.createCollection 'environments', (err, coll) ->
    coll.insert env, (err, docs) ->
      cb()

createUsers = (db, cb) ->
  alice =
    _id: aliceId
    apiSecret: 'notVerySecret'
    firstName: 'Alice'
    systemId: sysId

  db.createCollection 'users', (err, coll) ->
    coll.insert alice, (err, docs) ->
      cb()

exports.initializeDB = (cb) ->
  mongo.MongoClient.connect 'mongodb://127.0.0.1:27017/gint-security-test', (err, db) ->
    db.dropDatabase (err, ok) ->
      createSystems db, () ->
        createEnvironments db, () ->
          createUsers db, () ->
            db.close()
            cb()