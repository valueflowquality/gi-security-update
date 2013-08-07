module.exports = (mongoose, crudModelFactory) ->

  modelName = 'Permission'

  schema =
    systemId: 'ObjectId'
    userId: 'ObjectId'
    resourceType: 'String'
    restriction: 'Number'
    keys: ['ObjectId']

  mongoose.model modelName, schema

  crudModelFactory mongoose.model(modelName)