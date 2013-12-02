module.exports = (dal) ->

  modelDefinition =
    name: 'System'
    schemaDefinition:
      name: 'String'
      attributes: [
        key: 'String'
        category: 'String'
        value: 'String'
      ]

  modelDefinition.schema = dal.schemaFactory modelDefinition
  model = dal.modelFactory modelDefinition

  #This is special - it's a model function
  #that does not filter by systemId (as it is used to find systemIds)
  all = (cb) ->
    model.find {}, (err, obj) ->
      cb err, obj

  exports = dal.crudFactory model
  exports.all = all
  exports