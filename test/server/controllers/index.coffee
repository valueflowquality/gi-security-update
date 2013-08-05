assert = require('chai').assert
expect = require('chai').expect

sinon = require 'sinon'
proxyquire = require 'proxyquire'
path = require 'path'

user = require './user'
activity = require './activity'

module.exports = () ->
  describe 'Controllers', ->
    controllers = null
    stubs = null
    app =
      models:
        users: 'users'
        roles: 'roles'
        settings: 'settings'
        categories: 'categories'
        systems: 'system'
        environments: 'environments'
        files: 'files'
        activities: 'activities'
      controllers:
        crud: sinon.stub().returnsArg 0


    beforeEach (done) ->
      dir =  path.normalize __dirname + '../../../../server'

      stubs =
        './user': sinon.stub().returnsArg 0
        './activity': sinon.stub().returnsArg 0
        './file': sinon.stub().returnsArg 0


      mongooseMock = sinon.spy()
      crudModelFactoryMock = sinon.spy()

      controllers = proxyquire(dir + '/controllers', stubs)(app)

      done()

    it 'exports user controller', (done) ->
      assert stubs['./user'].calledWith(app.models.users, app.controllers.crud), 'user controller not initialized'
      assert.property controllers, 'user', 'Controllers does not export user'
      expect(controllers.user).to.equal app.models.users
      done()

    it 'exports activity controller', (done) ->
      assert stubs['./activity'].calledWith(app.models.activities, app.controllers.crud), 'activity controller not initialized'
      assert.property controllers, 'activity', 'Controllers does not export activity'
      expect(controllers.activity).to.equal app.models.activities
      done()

    it 'exports file controller', (done) ->
      assert stubs['./file'].calledWith(app.models, app.controllers.crud), 'file controller not initialized'
      assert.property controllers, 'file', 'Controllers does not export user'
      expect(controllers.file.files).to.equal app.models.files
      done()

    it 'exports crud role controller', (done) ->
      assert app.controllers.crud.calledWith(app.models.roles), 'crud controller factory not called for role'
      assert.property controllers, 'role', 'Controllers does not export role'
      expect(controllers.role).to.equal app.models.roles
      done()

    it 'exports crud setting controller', (done) ->
      assert app.controllers.crud.calledWith(app.models.settings), 'crud controller factory not called for setting'
      assert.property controllers, 'setting', 'Controllers does not export setting'
      expect(controllers.setting).to.equal app.models.settings
      done()

    it 'exports crud category controller', (done) ->
      assert app.controllers.crud.calledWith(app.models.categories), 'crud controller factory not called for category'
      assert.property controllers, 'category', 'Controllers does not export category'
      expect(controllers.category).to.equal app.models.categories
      done()

    it 'exports crud system controller', (done) ->
      assert app.controllers.crud.calledWith(app.models.categories), 'crud controller factory not called for system'
      assert.property controllers, 'category', 'Controllers does not export system'
      expect(controllers.system).to.equal app.models.systems
      done()

    it 'exports crud environment controller', (done) ->
      assert app.controllers.crud.calledWith(app.models.environments), 'crud controller factory not called for environment'
      assert.property controllers, 'environment', 'Controllers does not export environment'
      expect(controllers.environment).to.equal app.models.environments
      done()

    activity()
    user()