gint = require 'gint-util'
module.exports = (mongoose) ->

  Schema = mongoose.Schema
  ObjectId = Schema.Types.ObjectId

  modelName = 'Activity'

  schema =
    systemId: ObjectId
    description: 'String'
    job:
      type: ObjectId
      ref: 'Job'
    user:
      type: ObjectId
      ref: 'User'
    timeStamp:
      type: Date
      default: Date.now
    status:
      type: ObjectId
      ref: 'JobStatus'
    code:
      type: Number
    from: 'Mixed'
    to: 'Mixed'
    parent:
      key:
        type: ObjectId
      resourceType:
        type: String

  activitySchema = new Schema schema

  mongoose.model modelName, activitySchema
  exports = gint.models.crud mongoose.model(modelName)
  exports.name = modelName
  exports