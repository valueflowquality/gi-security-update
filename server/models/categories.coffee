gint = require 'gint-util'
module.exports = (mongoose) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  modelName = 'Category'

  schema =
    siteId: ObjectId
    parentId: ObjectId
    title: 'String'
    pluralTitle: 'String'
    description: 'String'
    detail: 'String'
    moredetail: 'String'
    slug: 'String'
    visible: 'Boolean'
    showOnNav: 'Boolean'
    attributes: [
      name: 'String'
      value: 'String'
    ]

  mongoose.model modelName, schema
  exports = gint.models.crud mongoose.model(modelName)
  exports.name = modelName
  exports