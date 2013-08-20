assert = require('chai').assert
expect = require('chai').expect

sinon = require 'sinon'
proxyquire = require 'proxyquire'
path = require 'path'

module.exports = () ->
  describe 'Authentication', ->
    dir =  path.normalize __dirname + '../../../../server'
    permissionsMiddlewareSpy = sinon.spy()
    stubs =
     './permissionFilter': sinon.stub().returns permissionsMiddlewareSpy
    authenticationModule = proxyquire dir + '/authentication', stubs

    app =
      use: ->
      get: ->
      models:
        users: 'users'

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

        describe '_systemCheck: Function(req, res, next) -> void', ->
          it 'Has no tests yet', (done) ->
            done()

        describe '_hmacAuth: Function(req, res, next) -> void', ->
          it 'Has no tests yet', (done) ->
            done()

        describe '_playAuth: Function(req, res, next) -> void', ->
          it 'Has no tests yet', (done) ->
            done()
