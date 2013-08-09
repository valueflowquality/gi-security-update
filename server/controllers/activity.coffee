gint = require 'gint-util'

module.exports = (model, crudControllerFactory) ->
  crud  = crudControllerFactory(model)
    
  create = (req, res) ->
    req.body.user = req.user.id
    crud.create req, res

  exports = gint.common.extend {}, crud
  exports.create = create
  exports