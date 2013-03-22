gint = require 'gint-util'
crypto = require 'crypto'
bcrypt = require 'bcrypt'

module.exports = (mongoose) ->
  
  name = 'User'

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId


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
    generateAPISecret (err, secret) =>
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
  
  mongoose.model name, userSchema

  crud = gint.models.crud mongoose.model(name)

  update = (id, json, callback) ->
    delete json.password
    crud.update(id, json, callback)

  findOneByProviderId = (id, callback) ->
    crud.findOneBy 'userIds.providerId', id, callback

  findOrCreate = (json, callback) ->
    findOneByProviderId json.providerId, (err, user) ->
      if user
        console.log 'found user by provider id'
        callback err, user
      else
        console.log 'creating new user'
        crud.create json, (err, user) ->
          callback err, user

  generateAPISecret = (callback) ->
    'in generate api secret'
    crypto.randomBytes 18, (err, buf) ->
      callback err if err
      result = buf.toString 'base64'
      console.log 'result: ' + result
      callback null, result

  create: crud.create
  find: crud.find
  findOneBy: crud.findOneBy
  findById: crud.findById
  findOneByProviderId: findOneByProviderId
  findOrCreate: findOrCreate
  update: update
  destroy: crud.destroy