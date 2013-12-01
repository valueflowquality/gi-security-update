module.exports = (dal) ->

  modelName = 'Environment'

  schemaDefinition =
    systemId: 'ObjectId'
    host: 'String'

  schema = dal.schemaFactory schemaDefinition
  model = dal.modelFactory() modelName, schema

  #This is special - it's a model function
  #that does not filter by systemId (as it is used to find systemIds)
  getForHost = (host, callback) ->
    model.findOne {host: host}, (err, env) ->
      if err
        callback err, null
      else if env
        obj =
          _id: env._id
          systemId: env.systemId
        callback null, obj
      else
        callback modelName + " Not Found", null

  exports = dal.crudFactory model
  exports.forHost = getForHost
  exports