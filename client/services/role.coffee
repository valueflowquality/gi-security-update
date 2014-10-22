angular.module('gi.security').factory 'Role'
, ['$filter', '$q', 'giCrud'
, ($filter, $q, Crud) ->

  crud = Crud.factory 'roles'

  isInRole = (name, roleIds) ->
    deferred = $q.defer()
    crud.all().then (roles) ->
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

  crud.isInRole = isInRole
  crud
]
