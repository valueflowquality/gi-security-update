module.exports = (dal) ->

  modelName = 'Activity'

  schemaDefinition =
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

  schema = dal.schemaFactory schemaDefinition
  model = dal.modelFactory() modelName, schema

  dal.crudFactory model