gint = require 'gint-util'
module.exports = (mongoose) ->

  name = 'Role'

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  roleSchema = new Schema {name: 'String' }

  mongoose.model name, roleSchema

  exports = gint.models.crud mongoose.model(name)
  exports.name = name
  exports