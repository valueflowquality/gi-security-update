module.exports = (dal) ->

  modelName = 'Category'

  schema =
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

  dal.model modelName, schema, 'categories'
  dal.crudFactory dal.model(modelName)