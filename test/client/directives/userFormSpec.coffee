describe 'userForm', () ->

  beforeEach module 'ngResource'
  beforeEach module 'ui'
  beforeEach module 'app'
 
  #Mock (/ override) the Role service that will be used by the directive
  beforeEach(module(($provide) ->
    $provide.factory('Role', () ->
      all = (callback) ->
        callback []

      all: all
    )
    return
  ))

  elm = {}
  scope = {}
  spy = sinon.spy()

  beforeEach inject(($rootScope, $compile) ->
    # we might move this tpl into an html file as well...
    elm = angular.element( '<div>' +
        '<userform user="selectedUser" ' +
        '          title="User Details" ' +
        '          submit-text="Save Changes" '+
        '          submit="saveUser(user)" ' +
        '          destroy="deleteUser(role)">' +
        '</userform> ' +
    '</div>' )

    scope = $rootScope
    scope.saveUser = spy

    $compile(elm)(scope)
    scope.$digest()
  )

  it 'should call role service when save changes is clicked', () ->
    buttons = elm.find 'button'
    expect(spy.called).toBe(false)
    buttons.eq(0).click()
    expect(spy.called).toBe(true)
