path = require 'path'
sinon = require 'sinon'
assert = require 'assert'

dir =  path.normalize __dirname + '../../../../server'

module.exports = () ->

  describe 'Routes', ->

    assertRestfulForResource = (resource, security, controllerName) ->
      module = require(dir + '/routes')

      app =
        get: sinon.spy()
        post: sinon.spy()
        del: sinon.spy()
        put: sinon.spy()
        middleware:
          publicAction: sinon.spy()
          userAction: sinon.spy()
          adminAction: sinon.spy()

        controllers:
          user:
            showMe: sinon.spy()
            updateMe: sinon.spy()
            destroyMe: sinon.spy()
            index: sinon.spy()
          role: sinon.spy()
          setting: sinon.spy()
          activity: sinon.spy()
          category: sinon.spy()
          environment: sinon.spy()
          permission: sinon.spy()
          resource: sinon.spy()

      rest =
        routeResource: sinon.spy()

      securityFilter = app.middleware.publicAction
      if security is 'user'
        securityFilter = app.middleware.userAction
      else if security is 'admin'
        securityFilter = app.middleware.adminAction

      module.configure app, rest

      assert rest.routeResource.calledWith(resource, app)
      , 'routeResource not called for ' + resource
      
      assert rest.routeResource.calledWith(resource, app, securityFilter)
      , 'routeResource ' + resource + ' not called with correct security filter'
      
      assert rest.routeResource.calledWith(
        resource, app, securityFilter, app.controllers[controllerName]
      ), 'routeResource ' + resource + ' not called on correct controller'

    it 'exports a RESTful role resource', (done) ->
      assertRestfulForResource 'roles', 'user', 'role'
      done()

    it 'exports a RESTful users resource', (done) ->
      assertRestfulForResource 'users', 'user', 'user'
      done()

    it 'exports a RESTful settings resource', (done) ->
      assertRestfulForResource 'settings', 'user', 'setting'
      done()

    it 'exports a RESTful activities resource', (done) ->
      assertRestfulForResource 'activities', 'user', 'activity'
      done()

    it 'exports a Restful categories resource', (done) ->
      assertRestfulForResource 'categories', 'user', 'category'
      done()

    it 'exports a Restful systems resource', (done) ->
      assertRestfulForResource 'systems', 'user', 'system'
      done()
    
    it 'exports a Restful environments resource', (done) ->
      assertRestfulForResource 'environments', 'user', 'environment'
      done()
    
    it 'exports a Restful files resource', (done) ->
      assertRestfulForResource 'files', 'user', 'file'
      done()

    it 'exports a Restful permission resource', (done) ->
      assertRestfulForResource 'permissions', 'user', 'permission'
      done()

    it 'exports a Restful resource resource', (done) ->
      assertRestfulForResource 'resources', 'user', 'resource'
      done()