expect = require('chai').expect

sinon = require 'sinon'
proxyquire = require 'proxyquire'
path = require 'path'
permissionFilter = require './permissionFilter'

module.exports = () ->
  describe 'Authentication', ->
    describe 'Public', ->
      dir =  path.normalize __dirname + '../../../../../server'
      permissionsMiddlewareSpy = sinon.spy()
      basic =
        routes: sinon.spy()
      facebook =
        routes: sinon.spy()

      passport =
        initialize: () ->
          return 'passport-initialize'
        session: () ->
          return 'passport-session'

      stubs =
       './permissionFilter': sinon.stub().returns permissionsMiddlewareSpy
       './hmac': sinon.spy()
       './play': sinon.spy()
       './basic': sinon.stub().returns basic
       './facebook': sinon.stub().returns facebook
       'passport': passport

      authenticationModule = proxyquire dir + '/authentication', stubs

      app =
        use: sinon.spy()
        get: sinon.spy()
        post: ->
        router: 'app-router'
        models:
          users: 'users'
          environments:
            forHost: ->
          settings:
            get: ->

      afterEach (done) ->
        permissionsMiddlewareSpy.reset()
        done()

      it 'Exports a factory function', (done) ->
        expect(authenticationModule).to.be.a('function')
        done()

      describe 'Factory Function: (app, options) -> { middleware }', ->
        authentication = authenticationModule app, {}
        
        describe 'Initialisation', (done) ->
          it 'Uses permissionFilter', (done) ->
            expect(stubs['./permissionFilter'].calledWithExactly(app))
            .to.be.true
            done()

          it 'requires basic authenticaion', (done) ->
            expect(stubs['./basic'].callCount).to.equal 1
            expect(stubs['./basic'].calledWithExactly app.models.users)
            .to.be.true
            done()

          it 'requires facebook authenticaion', (done) ->
            expect(stubs['./facebook'].callCount).to.equal 1
            expect(stubs['./facebook'].calledWithExactly app.models.users)
            .to.be.true
            done()

          it 'requires hmac authenticaion', (done) ->
            expect(stubs['./hmac'].callCount).to.equal 1
            expect(stubs['./hmac'].calledWithExactly app.models.users)
            .to.be.true
            done()

          it 'requires play authenticaion', (done) ->
            expect(stubs['./play'].callCount).to.equal 1
            expect(stubs['./play'].calledWithExactly app.models.users)
            .to.be.true
            done()

          it 'makes the app use passport intialize', (done) ->
            expect(app.use.getCall(0).args[0]).to.equal 'passport-initialize'
            done()

          it 'makes the app use passport session', (done) ->
            expect(app.use.getCall(1).args[0]).to.equal 'passport-session'
            done()

          it 'makes the app use the apps router', (done) ->
            expect(app.use.calledWith app.router).to.be.true
            done()

          it 'creates an api route for loginstatus', (done) ->
            expect(app.get.calledWith '/api/loginstatus', sinon.match.func)
            .to.be.true
            done()

          it 'creates an api route for logout', (done) ->
            expect(app.get.calledWith '/api/logout', sinon.match.func)
            .to.be.true
            done()

          it 'configures the routes defined in basic strategy', (done) ->
            expect(basic.routes.calledWith app, sinon.match.func)
            .to.be.true
            done()

          it 'configures the routes defined in facebook stratgegy', (done) ->
            expect(facebook.routes.calledWith app, sinon.match.func)
            .to.be.true
            done()

        describe 'Public Exports (Connect Middleware)', ->

          it 'userAction', (done) ->
            expect(authentication).to.have.ownProperty 'userAction'
            expect(authentication.userAction).to.be.a 'function'
            done()

          it 'publicAction', (done) ->
            expect(authentication).to.have.ownProperty 'publicAction'
            expect(authentication.publicAction).to.be.a 'function'
            done()

          it 'adminAction', (done) ->
            expect(authentication).to.have.ownProperty 'adminAction'
            expect(authentication.adminAction).to.be.a 'function'
            done()

          it 'sysAdminAction', (done) ->
            expect(authentication).to.have.ownProperty 'sysAdminAction'
            expect(authentication.sysAdminAction).to.be.a 'function'
            done()

          describe 'publicAction: Function(req, res, next) -> void', ->
            beforeEach (done) ->
              sinon.stub authentication, '_systemCheck'
              done()
            
            afterEach (done) ->
              authentication._systemCheck.restore()
              done()

            it 'passes args through systemCheck', (done) ->
              authentication.publicAction {a: 'b'}, {c : 'd'}, {e: 'f'}
              expect(authentication._systemCheck.calledWithExactly(
                {a: 'b'}, {c : 'd'}, {e: 'f'}
              )).to.be.true
              done()

          describe 'userAction: Function(req, res, next) -> void', ->
            req =
              isAuthenticated = () ->
                false
            beforeEach (done) ->
              sinon.stub authentication, 'publicAction'
              sinon.stub authentication, '_hmacAuth'
              sinon.stub authentication, '_playAuth'
              done()
            
            afterEach (done) ->
              authentication.publicAction.restore()
              authentication._hmacAuth.restore()
              authentication._playAuth.restore()
              done()

            it 'passes args through publicAction', (done) ->
              req.isAuthenticated = () ->
                true
              authentication.publicAction.callsArg 2
              authentication.userAction req, {c : 'd'}
              
              expect(authentication.publicAction.calledWith(
                req, {c : 'd'}
              )).to.be.true
              done()

            it 'passes to permissionsMiddleware if req is authenticated'
            , (done) ->
              req.isAuthenticated = () ->
                true

              authentication.publicAction.callsArg 2
              authentication.userAction req, {a: 'b'}, {c: 'd'}
              expect(permissionsMiddlewareSpy.calledWithExactly(
                req, {a: 'b'}, {c: 'd'})).to.be.true
              done()

            it 'attempts hmac Authentication if req is not authenticated'
            , (done) ->
              req.isAuthenticated = () ->
                false

              authentication.publicAction.callsArg 2
              authentication._hmacAuth.callsArgWith 2, null, {user: 'object'}
              authentication.userAction req, {a: 'b'}, {c: 'd'}
              expect(authentication._hmacAuth.calledWith(
                req, {a: 'b'}
              )).to.be.true
              done()

            it 'calls PermissionsMiddleware if hmacAuthentication returns' +
            ' a user and no error', (done) ->
              req.isAuthenticated = () ->
                false

              authentication.publicAction.callsArg 2
              authentication._hmacAuth.callsArgWith 2, null, {user: 'object'}
              authentication.userAction req, {a: 'b'}, {c: 'd'}
              expect(permissionsMiddlewareSpy.calledWithExactly(
                req, {a: 'b'}, {c: 'd'})).to.be.true
              done()

            it 'attempts play Authentication if hmacAuthenticaiton returns' +
            ' an error', (done) ->
              req.isAuthenticated = () ->
                false

              authentication.publicAction.callsArg 2
              authentication._hmacAuth.callsArgWith 2, "an error"
              , {user: 'object'}
              authentication.userAction req, {a: 'b'}, {c: 'd'}
              expect(authentication._playAuth.calledWith(
                req, {a: 'b'}
              )).to.be.true
              done()

            it 'attempts play Authentication if hmacAuthenticaiton returns' +
            ' no user', (done) ->
              req.isAuthenticated = () ->
                false

              authentication.publicAction.callsArg 2
              authentication._hmacAuth.callsArgWith 2, null, null
              authentication.userAction req, {a: 'b'}, {c: 'd'}
              expect(authentication._playAuth.calledWith(
                req, {a: 'b'}
              )).to.be.true
              done()

            it 'calls PermissionsMiddleware if playAuthentication returns' +
            ' a user and no error', (done) ->
              req.isAuthenticated = () ->
                false

              authentication.publicAction.callsArg 2
              authentication._hmacAuth.callsArgWith 2, "an error", null
              authentication._playAuth.callsArgWith 2, null, {user: 'object'}
              authentication.userAction req, {a: 'b'}, {c: 'd'}
              expect(permissionsMiddlewareSpy.calledWithExactly(
                req, {a: 'b'}, {c: 'd'})).to.be.true
              done()

            it 'calls res.json if playAuthentication returns' +
            ' an error', (done) ->
              req.isAuthenticated = () ->
                false
              
              res =
                json: sinon.spy()

              authentication.publicAction.callsArg 2
              authentication._hmacAuth.callsArgWith 2, "an error", null
              authentication._playAuth.callsArgWith 2, "another error"
              , {user: 'object'}
              authentication.userAction req, res, {c: 'd'}
              expect(permissionsMiddlewareSpy.called).to.be.false
              expect(res.json.calledWith 401, {}).to.be.true
              done()

            it 'calls res.json if playAuthentication returns' +
            ' no user', (done) ->
              req.isAuthenticated = () ->
                false
              
              res =
                json: sinon.spy()

              authentication.publicAction.callsArg 2
              authentication._hmacAuth.callsArgWith 2, "an error", null
              authentication._playAuth.callsArgWith 2, null, null
              authentication.userAction req, res, {c: 'd'}
              expect(permissionsMiddlewareSpy.called).to.be.false
              expect(res.json.calledWith 401, {}).to.be.true
              done()
              
        describe 'Private Functions', ->
          it '_getSystemStrategies', (done) ->
            expect(authentication).to.have.ownProperty '_getSystemStrategies'
            expect(authentication._getSystemStrategies).to.be.a 'function'
            done()

          it '_systemCheck', (done) ->
            expect(authentication).to.have.ownProperty '_systemCheck'
            expect(authentication._systemCheck).to.be.a 'function'
            done()
          
          it '_hmacAuth', (done) ->
            expect(authentication).to.have.ownProperty '_hmacAuth'
            expect(authentication._hmacAuth).to.be.a 'function'
            done()
          
          it '_playAuth', (done) ->
            expect(authentication).to.have.ownProperty '_playAuth'
            expect(authentication._playAuth).to.be.a 'function'
            done()

          describe '_getSystemStrategies: Function(req, done) -> void', ->
            req =
              systemId: "a sys id"
              environmentId: "an env id"
            
            beforeEach (done) ->
              sinon.stub app.models.settings, 'get'
              done()

            afterEach (done) ->
              app.models.settings.get.restore()
              done()

            it 'gets login with Facebook setting', (done) ->
              authentication._getSystemStrategies req, "done"
              expect(
                app.models.settings.get.calledWith 'loginWithFacebook'
                , req.systemId
                , req.environmentId
                , sinon.match.func
              ).to.be.true
              done()

            it 'gets login with Hmac setting', (done) ->
              authentication._getSystemStrategies req, "done"
              expect(
                app.models.settings.get.calledWith 'loginWithHmac'
                , req.systemId
                , req.environmentId
                , sinon.match.func
              ).to.be.true
              done()

            it 'gets login with Play setting', (done) ->
              authentication._getSystemStrategies req, "done"
              expect(
                app.models.settings.get.calledWith 'loginWithPlay'
                , req.systemId
                , req.environmentId
                , sinon.match.func
              ).to.be.true
              done()


            it 'calls back with any errors', (done) ->
              app.models.settings.get.callsArgWith 3, "an error", null
              authentication._getSystemStrategies req,  (err, result) ->
                expect(err).to.equal 'an error'
                expect(result).to.not.exist
                done()

            it 'calls back with the result', (done) ->
              setting =
                key: 'loginWithFacebook'
                value: true
              app.models.settings.get.callsArgWith 3, null, setting
              authentication._getSystemStrategies req,  (err, result) ->
                expect(result[0]).to.equal 'facebook'
                expect(result[1]).to.equal 'Hmac'
                expect(result[2]).to.equal 'Play'
                expect(err).to.not.exist
                done()

          describe '_systemCheck: Function(req, res, next) -> void', ->
            req = null
            res = null
            environment = null
            
            beforeEach (done) ->
              req =
                host: 'test.gint-security.com'
              
              res =
                json: sinon.spy()

              environment =
                _id: "an environment Id"
                systemId: "a systemId"

              sinon.stub app.models.environments, 'forHost'
              sinon.stub authentication, '_getSystemStrategies'
              done()

            afterEach ->
              app.models.environments.forHost.restore()
              authentication._getSystemStrategies.restore()

            it 'returns 500 error if no request', (done) ->
              authentication._systemCheck null, res, null
              expect(res.json.calledWith 500
                , {message: 'host not found on request object'}
              ).to.be.true
              done()

            it 'returns 500 error if no request.host', (done) ->
              req = {}
              authentication._systemCheck req, res, null
              expect(res.json.calledWith 500
                , {message: 'host not found on request object'}
              ).to.be.true
              done()

            it 'tries to find an environment matching the host', (done) ->
              authentication._systemCheck req, res, null
              expect(app.models.environments.forHost.calledWith req.host
                , sinon.match.func
              ).to.be.true
              done()

            it 'returns a 500 error and a message if this fails', (done) ->
              app.models.environments.forHost.callsArgWith 1, "an error", null
              authentication._systemCheck req, res, null
              expect(res.json.calledWith 500
                , {message: "an error"}
              ).to.be.true
              done()

            it 'returns not found if no environment', (done) ->
              app.models.environments.forHost.callsArgWith 1, null, null
              authentication._systemCheck req, res, null
              expect(res.json.calledWith 404
                , {message: "environment not found"}
              ).to.be.true
              done()

            it 'sets systemId on request if env found', (done) ->
              app.models.environments.forHost.callsArgWith 1, null, environment
              authentication._systemCheck req, res, null
              expect(req.systemId).to.equal environment.systemId
              done()

            it 'sets environmentId on request if env found', (done) ->
              app.models.environments.forHost.callsArgWith 1, null, environment
              authentication._systemCheck req, res, null
              expect(req.environmentId).to.equal environment._id
              done()

            it 'gets systemStrategies', (done) ->
              app.models.environments.forHost.callsArgWith 1, null, environment
              authentication._systemCheck req, res, null
              expect(authentication._getSystemStrategies.called).to.be.true
              reqArg = authentication._getSystemStrategies.getCall(0).args[0]
              expect(reqArg.systemId).to.equal environment.systemId
              expect(reqArg.environmentId).to.equal environment._id
              expect(reqArg).to.deep.equal req
              done()

            it 'does not set req.strategies if _getSystemStrategies errors'
            , (done) ->
              app.models.environments.forHost.callsArgWith 1, null, environment
              authentication._getSystemStrategies.callsArgWith 1
              , "an error", {some: 'thing'}
              authentication._systemCheck req, res, ->
                expect(req.strategies).to.not.exist
                done()
            
            it 'does not set req.strategies if _getSystemStrategies is null'
            , (done) ->
              app.models.environments.forHost.callsArgWith 1, null, environment
              authentication._getSystemStrategies.callsArgWith 1
              authentication._systemCheck req, res, ->
                expect(req.strategies).to.not.exist
                done()
            
            it 'sets req.strategies otherwise', (done) ->
              app.models.environments.forHost.callsArgWith 1, null, environment
              authentication._getSystemStrategies.callsArgWith 1
              , null, 'something'
              authentication._systemCheck req, res, ->
                expect(req.strategies).to.equal 'something'
                done()

          describe '_hmacAuth: Function(req, res, next) -> void', ->
            req =
              strategies: ['some other strategy']

            it 'Checks if Hmac is a supported strategy', (done) ->
              authentication._hmacAuth req, null, (err, result) ->
                expect(err).to.equal 'Hmac strategy not supported'
                expect(result).to.not.exist
                done()

          describe '_playAuth: Function(req, res, next) -> void', ->
            req =
              strategies: ['some other strategy']
            it 'Checks if Play is a supported strategy', (done) ->
              authentication._playAuth req, null, (err, result) ->
                expect(err).to.equal 'Play strategy not supported'
                expect(result).to.not.exist
                done()

    describe 'Private', ->
      permissionFilter()