gi = require 'gi-util-updated'

module.exports =
  crudModel: require './crud'
  crudControllerFactory: gi.mocks.crudControllerFactory
  exportsCrudModel: gi.mocks.exportsCrudModel
  crudModelFactory: gi.mocks.crudModelFactory
  dal: gi.mocks.dal
  sinon: gi.mocks.sinon