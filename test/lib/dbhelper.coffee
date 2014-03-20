mongo = require 'mongodb'

sysId = mongo.ObjectID('5240630360d7400b17999999')
aliceId = mongo.ObjectID('5240630360d7400b18000001')
adminRoleId = mongo.ObjectID('5240630360d7400b18000002')
adminId = mongo.ObjectID('5240630360d7400b18000003')

createSystems = (db, cb) ->
  sys =
    name: "securityTest"
    _id: sysId
  db.createCollection 'systems', (err, coll) ->
    coll.insert sys, (err, docs) ->
      cb()

createEnvironments = (db, cb) ->
  env =
    host: 'test.gi-security.com'
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

  admin =
    _id: adminId
    apiSecret: 'notVerySecret'
    firstName: 'Admin'
    systemId: sysId
    roles: [adminRoleId]

  db.createCollection 'users', (err, coll) ->
    coll.insert alice, (err, docs) ->
      coll.insert admin, (err, docs) ->
        cb()

createRoles = (db, cb) ->
  admin =
    _id: adminRoleId
    systemId: sysId
    name: 'Admin'

  db.createCollection 'roles', (err, coll) ->
    coll.insert admin, (err, docs) ->
      cb()

wrapDbFunction = (dbFunction, cb) ->
  mongo.MongoClient.connect 'mongodb://127.0.0.1:27017/gi-security-test'
  , (err, db) ->
    dbFunction db, () ->
      db.close()
      cb()

exports.setSetting = (key, value, acl, cb) ->

  if not cb?
    cb = acl
    acl = null

  setting =
    key: key
    systemId: sysId
    acl: acl
    parent:
      key: sysId
      resourceType: 'system'
  update =
    $set:
      value: value
  options =
    upsert: true

  wrapDbFunction (db, callback) ->
    db.createCollection 'settings', (err, coll) ->
      coll.update setting, update, options, callback
  , cb

exports.initializeDB = (cb) ->
  wrapDbFunction (db, callback) ->
    db.dropDatabase (err, ok) ->
      createSystems db, () ->
        createEnvironments db, () ->
          createRoles db, () ->
            createUsers db, callback
  , cb