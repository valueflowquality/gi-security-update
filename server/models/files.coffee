module.exports = (dal) ->

  modelName = 'File'

  schemaDefinition =
    systemId: 'ObjectId'
    parentId: 'String'
    parentType: 'String'
    name: 'String'
    sequence: 'Number'
    primary: 'Boolean'
    exclude: 'Boolean'
    order: 'Number'
    title: 'String'
    description: 'String'
    size: 'Long'
    s3alternates: ['String']
    
  schema = dal.schemaFactory schemaDefinition
  model = dal.modelFactory() modelName, schema
  dal.crudFactory model
