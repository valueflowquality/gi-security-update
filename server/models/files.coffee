module.exports = (dal) ->

  modelName = 'File'

  schema =
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

  dal.model modelName, schema
  dal.crudFactory dal.model(modelName)
