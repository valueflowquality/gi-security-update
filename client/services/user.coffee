angular.module('app').factory 'User'
, ['$resource', ($resource) ->

  methods =
    query:
      method: 'GET'
      params: {}
      isArray: true
    save:
      method: 'PUT'
      params: {}
      isArray: false
    create:
      method: 'POST'
      params: {}
      isArray: false

  resource = $resource '/api/users/:id', {}, methods

  items = []

  updateMasterList = (newItem) ->
    replaced = false
    angular.forEach items, (item, index) ->
      unless replaced
        if newItem._id is item._id
          replaced = true
          items[index] = newItem

    unless replaced
      items.push newItem

  all = (callback) ->
    if items.length == 0
      resource.query (results) ->
        items = results

        callback items if callback
    else
      callback items if callback

  save = (item, success) ->
    if item._id
      console.log 'updating user'
      #we are updating
      resource.save {id: item._id}, item, (result) ->
        updateMasterList result
        success() if success

    else
      console.log 'creating user'
      #we are createing a new object on the server
      resource.create {}, item, (result) ->
        console.log 'got a result ' + result
        updateMasterList result
        success() if success

  get = (params, callback) ->
    resource.get params, (item) ->
      updateMasterList item

      callback item if callback
  
  destroy = (id, callback) ->
    resource.delete {id: id}, () ->
      removed = false
      angular.forEach items, (item, index) ->
        unless removed
           if item._id is id
            removed = true
            items.splice index, 1
            
      callback() if callback

  factory = () ->
    firstName: ''
    lastName: ''

  query: all
  all: all
  get: get
  create: factory
  destroy: destroy
  save: save
]