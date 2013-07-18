crypto = require 'crypto'
bcrypt = require 'bcrypt'

module.exports = (mongoose, crudModelFactory) ->
  
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
    if candidate?
      if @password?
        bcrypt.compare candidate, @password, (err, isMatch) ->
          if err
            return callback(err)
          callback null, isMatch
      else
        callback 'password authentication is not enabled for this user', false
    else
      callback 'password does not meet minimum requirements', false

  userSchema.pre 'save', (next) ->
    user = @

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

  crud = crudModelFactory mongoose.model(name)

  update = (id, json, callback) ->
    crud.findById id, (err, user) ->
      if err
        callback err, null
      else
        if user
          #call save in case the password has changed
          if json.password
            user.password = json.password
            user.save (err, savedUser) ->
              if savedUser and savedUser.password
                json.password = savedUser.password
              crud.update id, json, callback
          else
            crud.update id, json, callback
        else
          callback 'user not found', null

  findOneByProviderId = (id, callback) ->
    crud.findOneBy 'userIds.providerId', id, callback

  findOrCreate = (json, callback) ->
    findOneByProviderId json.providerId, (err, user) ->
      if user
        callback err, user
      else
        crud.create json, (err, user) ->
          callback err, user

  generateAPISecret = (callback) ->
    'in generate api secret'
    crypto.randomBytes 18, (err, buf) ->
      callback err if err
      result = buf.toString 'base64'
      callback null, result

  create: crud.create
  find: crud.find
  findOneBy: crud.findOneBy
  findById: crud.findById
  findOneByProviderId: findOneByProviderId
  findOrCreate: findOrCreate
  update: update
  destroy: crud.destroy