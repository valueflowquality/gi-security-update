module.exports = (dal) ->

  modelDefinition =
    name: 'Category'
    schemaDefinition:
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
  
  modelDefinition.schema = dal.schemaFactory modelDefinition
  model = dal.modelFactory modelDefinition
  dal.crudFactory model