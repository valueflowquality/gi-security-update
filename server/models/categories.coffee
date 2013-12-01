module.exports = (dal) ->

  modelName = 'Category'

  schemaDefinition =
    systemId: 'ObjectId'
    parentId: 'ObjectId'
    title: 'String'
    pluralTitle: 'String'
    description: 'String'
    detail: 'String'
    moredetail: 'String'
    slug: 'String'
    visible: 'Boolean'
    showOnNav: 'Boolean'
    order: 'Number'
    attributes: [
      name: 'String'
      value: 'String'
    ]
  
  schema = dal.schemaFactory schemaDefinition
  model = dal.modelFactory() modelName, schema
  dal.crudFactory model