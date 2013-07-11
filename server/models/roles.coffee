gint = require 'gint-util'
module.exports = (mongoose) ->

  name = 'Role'

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  schema =
  	systemId: ObjectId
  	name: 'String'

  roleSchema = new Schema schema

  mongoose.model name, roleSchema

  exports = gint.models.crud mongoose.model(name)
  exports.name = name
  exports