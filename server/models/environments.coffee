module.exports = (mongoose, crudModelFactory) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  name = 'Environment'

  schema =
    systemId: 'ObjectId'
    host: 'String'

  environmentSchema = new Schema schema

  mongoose.model name, environmentSchema
  exports = crudModelFactory mongoose.model(name)
  exports.name = name
  exports