module.exports = (mongoose, crudModelFactory) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  name = 'Environment'

  schema =
    systemId: 'ObjectId'
    host: 'String'

  environmentSchema = new Schema schema
  mongoose.model name, environmentSchema
  model = mongoose.model(name)

  #This is special - it's the only model function
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
        callback "Environment Not Found", null

  exports = crudModelFactory model
  exports.forHost = getForHost
  exports.name = name
  exports