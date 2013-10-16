dbhelper = require '../../../lib/dbhelper'

module.exports = () ->
  @Before (done) ->
    dbhelper.initializeDB done