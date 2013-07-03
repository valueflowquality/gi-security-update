describe 'userName filter', ->
  beforeEach module 'ngResource'
  beforeEach module 'ui'
  beforeEach module 'app'

  #Mock (/ override) the User service that will be injected
  beforeEach(module(($provide) ->
    $provide.factory('User', () ->
      getSync = (id) ->
        if id is '123'
          return {firstName: 'Alice'}
        else
          null
      getSync: getSync
    )
    return
  ))

  it 'should have a userName filter'
  , inject ['$filter', ($filter) ->
    expect($filter('userName')).not.toBeNull()
  ]

  it 'should gracefully handle unknown ids'
  , inject [ '$filter', ($filter) ->
    expect($filter('userName')('456'))
    .toEqual('456')
  ]

  it 'should gracefully handle missing ids'
  , inject [ '$filter', ($filter) ->
    expect($filter('userName')())
    .toEqual('Missing User Id')
  ]

  it 'should convert known ids to user.firstName'
  , inject ['$filter', ($filter) ->
    expect($filter('userName')('123'))
    .toEqual('Alice')
  ]