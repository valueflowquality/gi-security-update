gint = require 'gint-util'
module.exports = (mongoose) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  modelName = 'Account'

  accountSchema = new Schema {name: 'String'
  , host: 'String'}

  mongoose.model modelName, accountSchema
  crud = gint.models.crud mongoose.model(modelName)

  find: crud.find
  findById: crud.findById
  findOneBy: crud.findOneBy
  create: crud.create
  update: crud.update
  destroy: crud.destroy
  name: modelName