mongo = require 'mongodb'

createSystems = (db, cb) ->
  sys =
    name: "securityTest"

  db.createCollection 'systems', (err, coll) ->
    coll.insert sys, (err, docs) ->
      cb docs[0]._id

createEnvironments = (sysId, db, cb) ->
  env =
    host: 'test.gintsecurity.com'
    name: 'testenv3'
    systemId: sysId

  db.createCollection 'environments', (err, coll) ->
    coll.insert env, (err, docs) ->
      cb docs[0]._id

createUsers = (sysId, db, cb) ->
  alice =
    _id: mongo.ObjectID('5240630360d7400b18000001')
    apiSecret: 'notVerySecret'
    firstName: 'alice'
    systemId: sysId

  db.createCollection 'users', (err, coll) ->
    coll.insert alice, (err, docs) ->
      cb docs[0]._id

initializeDB = (cb) ->
  mongo.MongoClient.connect 'mongodb://127.0.0.1:27017/wssTest', (err, db) ->
    db.dropDatabase (err, ok) ->
      createSystems db, (sysId) ->
        createEnvironments sysId, db, (envId) ->
          createUsers sysId, db, () ->
            db.close()
            cb()

module.exports = () ->
  @Before (done) ->
    initializeDB done