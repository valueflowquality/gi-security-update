module.exports = (mongoose) ->
  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  util = require 'util'
  crypto = require 'crypto'
  bcrypt = require 'bcrypt'
  SALT_WORK_FACTOR = 10

  userSchema = new Schema {firstName: 'String'
  , lastName: 'String'
  , email: 'String'
  , password: 'String'
  , apiSecret: 'String'
  , userIds: [{ provider: 'String', providerId: 'String'}]
  , roles: [{type: ObjectId, ref: 'Role'}] }

  userSchema.virtual('name').get () ->
    @firstName + ' ' + @lastName

  userSchema.virtual('name').set (name) ->
    split = name.split ' '
    @firstName = split[0]
    @lastName = split[1]

  userSchema.methods.resetAPISecret = (callback) ->
    console.log 'in reset api secret'
    generateAPISecret (err, secret) =>
      console.log 'in generate callback ' + util.inspect(@)
      if err
        callback err
      else
        @api_secret = secret
        callback() if callback

  userSchema.methods.comparePassword = (candidate, callback) ->
    bcrypt.compare candidate, @password, (err, isMatch) ->
      if err
        return callback(err)
      callback null, isMatch

  userSchema.pre 'save', (next) ->
    user = @

    if (not user.password?) or (user.password is '')
      @password = 'notSet'
      return next()

    if not @isModified('password')
      return next()
    bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
      if err
        return next(err)
      bcrypt.hash user.password, salt, (err, hash) ->
        if err
          return next(err)

        user.password = hash
        next()

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
    obj.save (err, json) ->
      callback err, json

  update = (id, json, callback) ->
    delete json.password
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
    User.findOne { 'userIds.providerId' : id }, (err, user) ->
      callback err, user

  findOrCreate = (json, callback) ->
    findOneByProviderId json.providerId, (err, user) ->
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