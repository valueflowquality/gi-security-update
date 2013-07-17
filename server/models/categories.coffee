gint = require 'gint-util'
module.exports = (mongoose) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  modelName = 'Category'

  schema =
    systemId: ObjectId
    parentId: ObjectId
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

  categorySchema = new Schema schema

  mongoose.model modelName, categorySchema, 'categories'
  exports = gint.models.crud mongoose.model(modelName)
  exports.name = modelName
  exports