module.exports = (dal) ->

  name = 'System'

  schema =
    name: 'String'
    attributes: [
      key: 'String'
      category: 'String'
      value: 'String'
    ]

  model = dal.model name, schema

  #This is special - it's a model function
  #that does not filter by systemId (as it is used to find systemIds)
  all = (cb) ->
    model.find {}, (err, obj) ->
      cb err, obj

  exports = dal.crudFactory model
  exports.all = all
  exports