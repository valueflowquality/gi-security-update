module.exports = (dal) ->

  modelName = 'Resource'

  schema =
    systemId: 'ObjectId'
    name: 'String'

  dal.model modelName, schema

  dal.crudFactory dal.model(modelName)