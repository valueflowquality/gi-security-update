crypto = require 'crypto'
bcrypt = require 'bcryptjs'
gi = require 'gi-util-updated'

module.exports = (dal) ->

  SALT_WORK_FACTOR = 10

  modelDefinition =
    name: 'Session'
    schemaDefinition: {
      _id: 'String'
    }
    options:
      strict: false

  schema = dal.schemaFactory modelDefinition
  modelDefinition.schema = schema
  model = dal.modelFactory modelDefinition

  exports = model
  exports
