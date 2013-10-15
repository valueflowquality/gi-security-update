async = require 'async'
expect = require('chai').expect
dbHelper = require '../../../../lib/dbhelper'

module.exports = () ->
  @World = require('../support/world').World

  @Given /^there is a public read setting called (.*)$/, (key, next) ->
    dbHelper.setSetting key, "a value", 'public-read', next

  @Given /^there is a private setting called (.*)$/, (key, next) ->
    dbHelper.setSetting key, "a value", next

  @Then /^it should contain a list of only public\-read settings$/, (next) ->
    async.map @res.body, (setting, cb) ->
      expect(setting.acl, setting.key + " was not public-read")
      .to.equal 'public-read'
      cb()
    , (err) ->
      next()