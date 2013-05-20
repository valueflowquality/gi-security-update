angular.module('app').factory 'Setting'
, ['$resource', 'Crud'
, ($resource, Crud) ->

  crudService = Crud.factory 'settings', true

  create = () ->
    key: ''
    value: ''

  save: crudService.save
  get: crudService.get
  destroy: crudService.destroy
  getCached: crudService.getCached
  query: crudService.all
  all: crudService.all
  create: create
]
