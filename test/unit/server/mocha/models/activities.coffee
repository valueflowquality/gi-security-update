path = require 'path'
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'
sinon = mocks.sinon
dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Activities', ->
    modelFactory = require(dir + '/models/activities')
    model = null
    expectedDefinition =
      name: 'Activity'
      schemaDefinition:
        systemId: 'ObjectId'
        description: 'String'
        job:
          type: 'ObjectId'
          ref: 'Job'
        user:
          type: 'ObjectId'
          ref: 'User'
        timeStamp:
          type: 'Date'
          default: Date.now
        status:
          type: 'ObjectId'
          ref: 'JobStatus'
        code: 'Number'
        from: 'Mixed'
        to: 'Mixed'
        parent:
          key: 'ObjectId'
          resourceType: 'String'

    it 'Exports a factory function', (done) ->
      expect(modelFactory).to.be.a 'function'
      done()

    describe 'Constructor: (dal) -> { object }', ->
      beforeEach (done) ->
        sinon.spy mocks.dal, 'schemaFactory'
        sinon.spy mocks.dal, 'modelFactory'
        model = modelFactory mocks.dal
        done()
      
      afterEach (done) ->
        mocks.dal.modelFactory.restore()
        mocks.dal.schemaFactory.restore()
        done()

      it 'Creates an Activity schema', (done) ->
        expect(mocks.dal.schemaFactory.calledWithMatch(expectedDefinition))
        .to.be.true
        done()

      it 'Creates an Activity model', (done) ->
        returnedDefinition = mocks.dal.schemaFactory.returnValues[0]
        expect(mocks.dal.modelFactory.calledWithMatch(expectedDefinition))
        .to.be.true
        done()

    describe 'Schema', ->
      schema = null

      beforeEach ->
        sinon.spy mocks.dal, 'schemaFactory'
        model = modelFactory mocks.dal
        schema = mocks.dal.schemaFactory.returnValues[0]

      afterEach ->
        mocks.dal.schemaFactory.restore()

      it 'systemId: ObjectId', (done) ->
        expect(schema).to.have.property 'systemId', 'ObjectId'
        done()

      it 'description: String', (done) ->
        expect(schema).to.have.property 'description', 'String'
        done()

      it 'job: Object', (done) ->
        expect(schema).to.have.property 'job'
        expect(schema.job).to.be.an 'object'
        expect(schema.job).to.deep.equal {type: 'ObjectId', ref: 'Job'}
        done()

      it 'user: Object', (done) ->
        expect(schema).to.have.property 'user'
        expect(schema.user).to.be.an 'object'
        expect(schema.user).to.deep.equal {type: 'ObjectId', ref: 'User'}
        done()

      it 'timeStamp: Date default Date.now', (done) ->
        expect(schema).to.have.property 'timeStamp'
        expect(schema.timeStamp).to.be.an 'object'
        expect(schema.timeStamp).to.deep.equal {type: 'Date', default: Date.now}
        done()

      it 'status: Object', (done) ->
        expect(schema).to.have.property 'status'
        expect(schema.status).to.be.an 'object'
        expect(schema.status).to.deep.equal {type: 'ObjectId', ref: 'JobStatus'}
        done()

      it 'code: Number', (done) ->
        expect(schema).to.have.property 'code', 'Number'
        done()

      it 'from: Mixed', (done) ->
        expect(schema).to.have.property 'from', 'Mixed'
        done()

      it 'to: Mixed', (done) ->
        expect(schema).to.have.property 'to', 'Mixed'
        done()
    
      it 'parent: Object', (done) ->
        expect(schema).to.have.property 'parent'
        expect(schema.parent).to.be.an 'object'
        expect(schema.parent).to.deep.equal {key: 'ObjectId'
        , resourceType: 'String'}
        done()



    describe 'Exports',  ->
      mut = require(dir + '/models/activities')(mocks.dal)
      mocks.exportsCrudModel 'Activity', mut