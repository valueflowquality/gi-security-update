module.exports = (mongoose) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  util = require 'util'
  crypto = require 'crypto'

  userSchema = new Schema {first_name: 'String'
  , last_name: 'String'
  , api_secret: 'String'
  , user_ids: [{ provider: 'String', provider_id: 'String'}]
  , roles: [{type: ObjectId, ref: 'Role'}] }

  userSchema.virtual('name').get () ->
    @first_name + ' ' + @last_name

  userSchema.virtual('name').set (name) ->
    split = name.split ' '
    @first_name = split[0]
    @last_name = split[1]

  userSchema.methods.resetAPISecret = (callback) ->
    console.log 'in reset api secret'
    generateAPISecret (err, secret) =>
      console.log 'in generate callback ' + util.inspect(@)
      if err
        callback err
      else
        @api_secret = secret
        callback() if callback

  mongoose.model 'Users', userSchema

  User = mongoose.model 'Users'

  find = (options, callback) ->
    max = options?.max or 10000
    sort = options?.sort or {}
    query = options?.query or {}
    if max < 1
      callback
    else
      User.find().sort(sort).limit(max).exec callback

  create = (json, callback) ->
    obj = new User json
    obj.save (err, user) ->
      callback err, user

  update = (id, json, callback) ->
    User.findByIdAndUpdate(id, json, callback)

  destroy =  (id, callback) ->
    User.findOne { _id : id}, (err, user) ->
      if err
        callback err
      else
        user.remove (err) ->
          callback err

  findById = (id, callback) ->
    User.findOne { _id : id}, (err, user) ->
      callback err, user

  findOneByProviderId = (id, callback) ->
    User.findOne { 'user_ids.provider_id' : id }, (err, user) ->
      callback err, user

  findOrCreate = (json, callback) ->
    console.log 'find or create'
    findOneByProviderId json.provider_id, (err, user) ->
      if user
        console.log 'found user by provider id'
        callback err, user
      else
        console.log 'creating new user'
        create json, (err, user) ->
          callback err, user

  generateAPISecret = (callback) ->
    'in generate api secret'
    crypto.randomBytes 18, (err, buf) ->
      callback err if err
      result = buf.toString 'base64'
      console.log 'result: ' + result
      callback null, result

  create: create
  find: find
  findOrCreate: findOrCreate
  findById: findById
  findOneByProviderId: findOneByProviderId
  update: update
  destroy: destroy