describe 'userName filter', ->
  beforeEach angular.mock.module 'ngResource'
  beforeEach angular.mock.module 'gi.security'

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
    expect($filter('userName')).not.to.be.null
  ]

  it 'should gracefully handle unknown ids'
  , inject [ '$filter', ($filter) ->
    expect($filter('userName')('456'))
    .to.equal '456'
  ]

  it 'should gracefully handle missing ids'
  , inject [ '$filter', ($filter) ->
    expect($filter('userName')())
    .to.equal 'Missing User Id'
  ]

  it 'should convert known ids to user.firstName'
  , inject ['$filter', ($filter) ->
    expect($filter('userName')('123'))
    .to.equal 'Alice'
  ]