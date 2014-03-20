crypto = require 'crypto'
bcrypt = require 'bcrypt'
gi = require 'gi-util'

module.exports = (dal) ->
  SALT_WORK_FACTOR = 10

  modelDefinition =
    name: 'User'
    schemaDefinition:
      systemId: 'ObjectId'
      firstName: 'String'
      lastName: 'String'
      email: 'String'
      password: 'String'
      apiSecret: 'String'
      userIds: [{provider: 'String', providerId: 'String'}]
      roles: [{type: 'ObjectId', ref: 'Role'}]
      
  schema = dal.schemaFactory modelDefinition
  modelDefinition.schema = schema

  schema.virtual('name').get () ->
    @firstName + ' ' + @lastName

  schema.virtual('name').set (name) ->
    split = name.split ' '
    @firstName = split[0]
    @lastName = split[1]

  schema.methods.resetAPISecret = (callback) ->
    crypto.randomBytes 18, (err, buf) =>
      if err
        callback err
      else
        @apiSecret = buf.toString 'base64'
        @save callback

 
  schema.methods.comparePassword = (candidate, callback) ->
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

  schema.pre 'save', (next) ->
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

  model = dal.modelFactory modelDefinition
  crud = dal.crudFactory model

  update = (id, json, callback) ->
    crud.findById id, json.systemId, (err, user) ->
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

  findOneByProviderId = (id, systemId, callback) ->
    crud.findOneBy 'userIds.providerId', id, systemId, callback

  findOrCreate = (json, callback) ->
    findOneByProviderId json.providerId, json.systemId (err, user) ->
      if user
        callback err, user
      else
        crud.create json, (err, user) ->
          callback err, user

  resetAPISecret = (id, systemId, callback) ->
    crud.findById id, systemId, (err, user) ->
      if err
        callback err
      else if user?
        user.resetAPISecret callback
      else
        callback 'cannot find user'

  exports = gi.common.extend {}, crud
  exports.update = update
  exports.findOrCreate = findOrCreate
  exports.findOneByProviderId = findOneByProviderId
  exports.resetAPISecret = resetAPISecret
  exports