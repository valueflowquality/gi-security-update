module.exports = (mongoose) ->
  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  util = require 'util'
  crypto = require 'crypto'

  userSchema = new Schema {first_name: 'String'
  , last_name: 'String'
  , api_secret: 'String'
  , user_ids: [{ provider: 'String', provider_id: 'String'}] }

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
        callback()

  mongoose.model 'Users', userSchema