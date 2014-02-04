module.exports = (dal) ->

  modelDefinition =
    name: 'Permission'
    schemaDefinition:
      systemId: 'ObjectId'
      userId: 'ObjectId'
      resourceType: 'String'
      restriction: 'Number'
      keys: ['ObjectId']

  modelDefinition.schema = dal.schemaFactory modelDefinition
  model = dal.modelFactory modelDefinition
  dal.crudFactory model