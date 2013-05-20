gint = require 'gint-util'
module.exports = (mongoose) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  name = 'Setting'

  schema = new Schema {key: 'String'
  , value: 'String'}

  mongoose.model name, schema
  exports = gint.models.crud mongoose.model(name)
  exports.name = name
  exports