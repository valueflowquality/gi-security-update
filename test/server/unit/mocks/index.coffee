gint = require 'gint-util'

module.exports =
  crudModel: require './crud'
  crudControllerFactory: gint.mocks.crudControllerFactory
  exportsCrudModel: gint.mocks.exportsCrudModel
  crudModelFactory: gint.mocks.crudModelFactory
  mongoose: gint.mocks.mongoose
  sinon: gint.mocks.sinon