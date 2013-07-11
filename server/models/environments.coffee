gint = require 'gint-util'
module.exports = (mongoose) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  name = 'Environment'

  schema =
  	systemId: 'ObjectId'
  	host: 'String'

  environmentSchema = new Schema schema

  mongoose.model name, environmentSchema
  exports = gint.models.crud mongoose.model(name)
  exports.name = name
  exports