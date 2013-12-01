module.exports = (dal) ->

  modelName = 'Permission'

  schemaDefinition =
    systemId: 'ObjectId'
    userId: 'ObjectId'
    resourceType: 'String'
    restriction: 'Number'
    keys: ['ObjectId']

  schema = dal.schemaFactory schemaDefinition
  model = dal.modelFactory() modelName, schema

  dal.crudFactory model