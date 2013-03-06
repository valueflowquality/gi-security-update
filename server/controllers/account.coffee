gint = require 'gint-util'
module.exports = (model) ->
  crudController  = gint.controllers.crud(model)
  
  name: model.name
  index: crudController.index
  create: crudController.create
  update: crudController.update
  destroy: crudController.destroy
  show: crudController.show