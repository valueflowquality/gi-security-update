gint = require 'gint-util'
module.exports = (model) ->
  crudController  = gint.controllers.crud(model)
    
  create = (req, res) ->
    req.body.user = req.user.id
    crudController.create req, res

  name: model.name
  index: crudController.index
  create: create
  update: crudController.update
  destroy: crudController.destroy
  show: crudController.show