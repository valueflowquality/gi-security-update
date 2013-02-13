angular.module('app').factory 'Role'
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

  resource = $resource '/api/role/:id', {}, methods

  roles = []

  updateMasterList = (role) ->
    replaced = false
    angular.forEach roles, (item, index) ->
      unless replaced
        if item._id is role._id
          replaced = true
          roles[index] = role

    unless replaced
      console.log 'pushing to roles ' + roles.length
      roles.push role
      console.log 'roles: ' + roles.length

  all = (callback) ->
    if roles.length == 0
      resource.query (results) ->
        roles = results

        callback roles if callback
    else
      callback roles if callback

  save = (role, success) ->
    if role._id
      console.log 'updating role'
      #we are updating
      resource.save {}, role, (result) ->
        updateMasterList result
        success() if success

    else
      console.log 'creating role'
      #we are createing a new object on the server
      resource.create {}, role, (result) ->
        console.log 'got a result ' + result
        updateMasterList result
        success() if success

  get = (params, callback) ->
    resource.get params, (role) ->
      updateMasterList role

      callback role if callback
  
  destroy = (id, callback) ->
    resource.delete {id: id}, () ->
      removed = false
      angular.forEach roles, (item, index) ->
        unless removed
           if item._id is id
            removed = true
            roles.splice index, 1
            
      callback() if callback

  factory = () ->
    name: ''

  query: all
  all: all
  get: get
  create: factory
  destroy: destroy
  save: save
]