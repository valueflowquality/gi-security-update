gint = require 'gint-util'
module.exports = (mongoose) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  name = 'System'

  schema =
    name: 'String'
    attributes: [
    	key: 'String'
    	category: 'String'
    	value: 'String'
    ]

  systemSchema = new Schema schema

  mongoose.model name, systemSchema
  exports = gint.models.crud mongoose.model(name)
  exports.name = name
  exports