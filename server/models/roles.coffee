gint = require 'gint-util'
module.exports = (mongoose) ->
  name = 'Role'

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  roleSchema = new Schema {name: 'String' }

  mongoose.model name, roleSchema

  crud = gint.models.crud mongoose.model(name)

  create: crud.create
  update: crud.update
  destroy: crud.destroy
  show: crud.show
  find: crud.find