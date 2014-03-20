angular.module('gi.security').factory 'User'
, ['$resource', '$http', '$q', 'Auth'
, ($resource, $http, $q, Auth) ->

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
  itemsById = {}

  updateMasterList = (newItem) ->
    replaced = false
    angular.forEach items, (item, index) ->
      unless replaced
        if newItem._id is item._id
          replaced = true
          items[index] = newItem

    unless replaced
      items.push newItem

    itemsById[newItem._id] = newItem
    return

  all = (callback) ->
    if items.length == 0
      resource.query (results) ->
        items = results
        angular.forEach results, (item, index) ->
          itemsById[item._id] = item
          return

        callback items if callback
    else
      callback items if callback

  save = (item, success) ->
    if item._id
      #we are updating
      resource.save {id: item._id}, item, (result) ->
        updateMasterList result
        success() if success

    else
      #we are createing a new object on the server
      resource.create {}, item, (result) ->
        updateMasterList result
        success() if success
  
  getByIdSync = (id) ->
    itemsById[id]

  get = (params, callback) ->
    resource.get params, (item) ->
      updateMasterList item

      callback item if callback
  
  destroy = (id, callback) ->
    resource.delete {id: id}, () ->
      removed = false
      delete itemsById[id]
      angular.forEach items, (item, index) ->
        unless removed
           if item._id is id
            removed = true
            items.splice index, 1
            
      callback() if callback

  register = (item) ->
    $http.post '/api/user/register', item

  login = (cred) ->
    deferred = $q.defer()
    $http.post('/api/login', cred).success( () ->
      Auth.loginConfirmed()
      deferred.resolve()
    ).error () ->
      Auth.loginChanged()
      deferred.reject()
    deferred.promise

  factory = () ->
    firstName: ''
    lastName: ''
    roles: []

  query: all
  all: all
  get: get
  getSync: getByIdSync
  create: factory
  destroy: destroy
  save: save
  register: register
  login: login
]