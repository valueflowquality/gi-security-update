path = require 'path'
expect = require('chai').expect
sinon = require 'sinon'

module.exports = () ->
  describe 'permissionFilter: Module', ->

    describe 'Public', ->
      dir =  path.normalize __dirname + '../../../../../server'
      app =
        models:
          permissions:
            find: ->

      permissionFilterModule = require dir + '/authentication/permissionFilter'

      it 'Exports a factory function', (done) ->
        expect(permissionFilterModule).to.be.a('function')
        done()

      describe 'Factory Function: (app) ->  Function (req, res, next) -> void'
      , ->
        permissionFilter = permissionFilterModule app
        
        beforeEach (done) ->
          sinon.stub app.models.permissions, 'find'
          done()

        afterEach (done) ->
          app.models.permissions.find.restore()
          done()

        it 'returns an annoymous Connect Middleware function', (done)->
          expect(permissionFilter).to.be.a 'function'
          done()

        describe 'Function(req, res, next) -> void', ->
          req =
            systemId: '123'
            user:
              id: 'user1'
          res =
            json: sinon.spy()
         
          afterEach (done) ->
            res.json.reset()
            done()

          it 'adds req.systemId to query sent to permissions find', (done) ->
            permissionFilter req
            expectedOptions =
              query:
                systemId: '123'
                userId: 'user1'
            expect(app.models.permissions.find.calledWith(expectedOptions))
            .to.be.true
            done()

          it 'returns 500 and the error message if permissions.find errors'
          , (done) ->
            app.models.permissions.find.callsArgWith 1, "an error", null

            permissionFilter req, res
            expect(res.json.calledWith(500, {message: "an error"}))
            .to.be.true
            done()

          it 'calls next if permission.find returns no results'
          , (done) ->
            app.models.permissions.find.callsArgWith 1, null, null
            spy = sinon.spy()
            permissionFilter req, res, spy
            expect(spy.calledOnce).to.be.true
            expect(req.gintFilter).to.not.exist
            done()

          it 'creates a gintFilter obj on req if permission.find has results'
          , (done) ->
            app.models.permissions.find.callsArgWith 1, null, []
            spy = sinon.spy()
            permissionFilter req, res, spy
            expect(req.gintFilter).to.exist
            expect(spy.calledOnce).to.be.true
            done()

          it 'creates a property on gintFilter of each results resourceType'
          , (done) ->
            results = [{resourceType: 'a'}, {resourceType: 'b'}]
            app.models.permissions.find.callsArgWith 1, null, results
            spy = sinon.spy()
            permissionFilter req, res, spy
            expect(req.gintFilter).to.have.ownProperty 'a'
            expect(req.gintFilter).to.have.ownProperty 'b'
            expect(spy.calledOnce).to.be.true
            done()

          it 'sets $nin filter to be an array if (result.restriction xor 1)'
          , (done) ->
            results = [{resourceType: 'a', restriction: 1}]
            app.models.permissions.find.callsArgWith 1, null, results
            spy = sinon.spy()
            permissionFilter req, res, spy
            expect(req.gintFilter.a).to.have.ownProperty '$nin'
            expect(req.gintFilter.a.$nin).to.be.an 'array'
            expect(spy.calledOnce).to.be.true
            done()
          
          it 'sets $nin filter to be an array of result.keys'
          , (done) ->
            results =
              [{resourceType: 'a', restriction: 3, keys: ['a', 'b', 'c']}]
            app.models.permissions.find.callsArgWith 1, null, results
            spy = sinon.spy()
            permissionFilter req, res, spy
            expect(req.gintFilter.a).to.have.ownProperty '$nin'
            expect(req.gintFilter.a.$nin).to.deep.equal ['a', 'b', 'c']
            expect(spy.calledOnce).to.be.true
            done()
          
          it 'sets resourceTypeFilter.create to be true if ' +
          '(result.restriction xor 2)', (done) ->
            results =
              [{resourceType: 'a', restriction: 2, keys: ['a', 'b', 'c']}]
            app.models.permissions.find.callsArgWith 1, null, results
            spy = sinon.spy()
            permissionFilter req, res, spy
            expect(req.gintFilter.a.create).to.be.true
            expect(req.gintFilter.a.$nin).to.not.exist
            expect(spy.calledOnce).to.be.true
            done()

          it 'sets resourceTypeFilter.create and $nin if ' +
          'result.restriction has bits 1 and 2', (done) ->
            results =
              [{resourceType: 'a', restriction: 3, keys: ['a', 'b', 'c']}]
            app.models.permissions.find.callsArgWith 1, null, results
            spy = sinon.spy()
            permissionFilter req, res, spy
            expect(req.gintFilter.a.create).to.be.true
            expect(req.gintFilter.a.$nin).to.deep.equal ['a', 'b', 'c']
            expect(spy.calledOnce).to.be.true
            done()

          it 'sets $in filter to be an array if (result.restriction xor 4)'
          , (done) ->
            results = [{resourceType: 'a', restriction: 4}]
            app.models.permissions.find.callsArgWith 1, null, results
            spy = sinon.spy()
            permissionFilter req, res, spy
            expect(req.gintFilter.a).to.have.ownProperty '$in'
            expect(req.gintFilter.a.$in).to.be.an 'array'
            expect(spy.calledOnce).to.be.true
            done()
          
          it 'sets $in filter to be an array of result.keys'
          , (done) ->
            results =
              [{resourceType: 'a', restriction: 4, keys: ['a', 'b', 'c']}]
            app.models.permissions.find.callsArgWith 1, null, results
            spy = sinon.spy()
            permissionFilter req, res, spy
            expect(req.gintFilter.a).to.have.ownProperty '$in'
            expect(req.gintFilter.a.$in).to.deep.equal ['a', 'b', 'c']
            expect(req.gintFilter.a.create).to.not.exist
            expect(spy.calledOnce).to.be.true
            done()

          it 'sets $in $nin and create if requested (this is a bad idea)'
          , (done) ->
            results =
              [{resourceType: 'a', restriction: 7, keys: ['a', 'b', 'c']}]
            app.models.permissions.find.callsArgWith 1, null, results
            spy = sinon.spy()
            permissionFilter req, res, spy
            expect(req.gintFilter.a).to.have.ownProperty '$in'
            expect(req.gintFilter.a.$in).to.deep.equal ['a', 'b', 'c']
            expect(req.gintFilter.a).to.have.ownProperty '$nin'
            expect(req.gintFilter.a.$nin).to.deep.equal ['a', 'b', 'c']
            expect(req.gintFilter.a.create).to.be.true
            expect(spy.calledOnce).to.be.true

            done()