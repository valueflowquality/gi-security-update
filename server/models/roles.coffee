module.exports = (dal) ->

  modelDefinition =
    name: 'Role'
    schemaDefinition:
      systemId: 'ObjectId'
      name: 'String'

  modelDefinition.schema = dal.schemaFactory modelDefinition
  model = dal.modelFactory modelDefinition

  dal.crudFactory model