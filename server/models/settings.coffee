module.exports = (mongoose, crudModelFactory) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  name = 'Setting'

  schema =
    key: 'String'
    value: 'String'
    parent:
      key:
        type: ObjectId
      resourceType:
        type: 'String'

  settingSchema = new Schema schema

  mongoose.model name, settingSchema
  exports = crudModelFactory mongoose.model(name)
  exports.name = name
  exports