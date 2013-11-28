module.exports = (dal) ->

  modelName = 'Permission'

  schema =
    systemId: 'ObjectId'
    userId: 'ObjectId'
    resourceType: 'String'
    restriction: 'Number'
    keys: ['ObjectId']

  dal.model modelName, schema

  dal.crudFactory dal.model(modelName)