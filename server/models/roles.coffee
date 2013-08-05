module.exports = (mongoose, crudModelFactory) ->

  modelName = 'Role'

  schema =
    systemId: 'ObjectId'
    name: 'String'

  mongoose.model modelName, schema

  crudModelFactory mongoose.model(modelName)