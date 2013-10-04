assert = require 'assert'
webdriver = require 'selenium-webdriver'
protractor = require 'protractor'
dbhelper = require '../../../../lib/dbhelper'

worldDefinition = () ->

  ptor = null
  driver = null

  class World
    constructor: (callback) ->
      @browser = ptor
      @By = protractor.By
      @assert = assert
      callback()

  capabilities = webdriver.Capabilities.chrome()
  .merge
    username: process.env.SAUCE_USERNAME
    accessKey: process.env.SAUCE_ACCESS_KEY
    name: 'gint-security protractor test'
    browserName: 'Chrome'
    platform: 'Windows 7'
    'record-video': true

  @BeforeFeatures (event, callback) ->
    console.log 'test/client/e2e/features/support/world@BeforeFeatures'
    driver = new webdriver.Builder().
    usingServer('http://192.168.1.72:4445/wd/hub').
    withCapabilities(capabilities).build()

    ptor = protractor.wrapDriver driver
    dbhelper.initializeDB callback

  @AfterFeatures (event, callback) ->
    driver.quit().then (err) ->
      callback err

  @World = World

module.exports = worldDefinition