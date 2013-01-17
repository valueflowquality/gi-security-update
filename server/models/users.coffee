module.exports = (mongoose) ->
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

  update = (json, callback) ->
    callback 'not implemented'
    #essentially here we need to iterate

  destroy =  (id, callback) ->
    User.findOne { _id : id}, (err, user) ->
      if err
        callback err
      else
        user.remove (err) ->
          callback err

  findOneById = (id, callback) ->
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
  findOneById: findOneById
  findOneByProviderId: findOneByProviderId
  update: update
  destroy: destroy