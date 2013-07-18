module.exports = (mongoose, crudModelFactory) ->

  name = 'Role'

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  schema =
    systemId: ObjectId
    name: 'String'

  roleSchema = new Schema schema

  mongoose.model name, roleSchema

  exports = crudModelFactory mongoose.model(name)
  exports.name = name
  exports