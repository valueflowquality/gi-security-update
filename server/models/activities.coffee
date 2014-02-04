module.exports = (dal) ->

  modelDefinition =
    name: 'Activity'
    schemaDefinition:
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

  modelDefinition.schema = dal.schemaFactory modelDefinition
  model = dal.modelFactory modelDefinition
  dal.crudFactory model