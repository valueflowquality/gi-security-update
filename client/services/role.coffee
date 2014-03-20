angular.module('gi.security').factory 'Role'
, ['$resource', '$filter', '$q'
, ($resource, $filter, $q) ->

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

  resource = $resource '/api/roles/:id', {}, methods

  roles = []

  updateMasterList = (role) ->
    replaced = false
    angular.forEach roles, (item, index) ->
      unless replaced
        if item._id is role._id
          replaced = true
          roles[index] = role

    unless replaced
      roles.push role

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


  isInRole = (name, roleIds) ->
    deferred = $q.defer()
    all (roles) ->
      inRole = false
      toCheck = $filter('filter')(roles, (role) ->

        role.name.toLowerCase() is name.toLowerCase()
      )
      angular.forEach toCheck, (role) ->
        angular.forEach roleIds, (id) ->
          if id is role._id
            inRole = true

      deferred.resolve inRole
    deferred.promise

  query: all
  all: all
  get: get
  create: factory
  destroy: destroy
  save: save
  isInRole: isInRole
]