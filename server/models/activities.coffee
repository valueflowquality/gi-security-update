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
    code: 'Number'
    from: 'Mixed'
    to: 'Mixed'
    parent:
      key: 'ObjectId'
      resourceType: 'String'

  mongoose.model modelName, schema

  crudModelFactory mongoose.model(modelName)