module.exports = (dal) ->

  modelName = 'Role'

  schema =
    systemId: 'ObjectId'
    name: 'String'

  dal.model modelName, schema

  dal.crudFactory dal.model(modelName)