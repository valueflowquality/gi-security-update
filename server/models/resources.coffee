module.exports = (mongoose, crudModelFactory) ->

  modelName = 'Resource'

  schema =
    systemId: 'ObjectId'
    name: 'String'

  mongoose.model modelName, schema

  crudModelFactory mongoose.model(modelName)