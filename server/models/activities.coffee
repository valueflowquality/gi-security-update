module.exports = (mongoose, crudModelFactory) ->

  modelName = 'Activity'

  schema =
    systemId: 'ObjectId'
    description: 'String'
    job:
      type: 'ObjectId'
      ref: 'Job'
    user:
      type: 'ObjectId'
      ref: 'User'
    timeStamp:
      type: 'Date'
      default: Date.now
    status:
      type: 'ObjectId'
      ref: 'JobStatus'
    code:
      type: 'Number'
    from: 'Mixed'
    to: 'Mixed'
    parent:
      key:
        type: 'ObjectId'
      resourceType:
        type: 'String'

  mongoose.model modelName, schema

  exports = crudModelFactory mongoose.model(modelName)
  exports.name = modelName
  exports