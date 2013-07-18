module.exports = (mongoose, crudModelFactory) ->

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
  exports = crudModelFactory mongoose.model(name)
  exports.name = name
  exports