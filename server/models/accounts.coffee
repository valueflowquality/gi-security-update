gint = require 'gint-util'
module.exports = (mongoose) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  name = 'Account'

  accountSchema = new Schema {name: 'String'
  , host: 'String'}

  mongoose.model name, accountSchema
  exports = gint.models.crud mongoose.model(name)
  exports.name = name
  exports