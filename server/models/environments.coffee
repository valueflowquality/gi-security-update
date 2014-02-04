module.exports = (dal) ->

  modelDefinition =
    name: 'Environment'
    schemaDefinition:
      systemId: 'ObjectId'
      host: 'String'

  modelDefinition.schema = dal.schemaFactory modelDefinition
  model = dal.modelFactory modelDefinition
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
        callback model.modelName + " Not Found", null

  exports = dal.crudFactory model
  exports.forHost = getForHost
  exports