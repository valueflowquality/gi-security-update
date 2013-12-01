module.exports = (dal) ->

  modelName = 'Resource'

  schemaDefinition =
    systemId: 'ObjectId'
    name: 'String'

  schema = dal.schemaFactory schemaDefinition
  model = dal.modelFactory() modelName, schema

  dal.crudFactory model