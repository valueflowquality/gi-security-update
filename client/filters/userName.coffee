angular.module('gi.security').filter 'userName'
, ['giUser'
, (User) ->
  (id) ->
    result = 'Missing User Id'
    if id
      user = User.getSync id
      if user
        result = user.firstName
      else
        result = id
    result
]
