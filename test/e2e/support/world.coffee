assert = require 'assert'
webdriver = require 'selenium-webdriver'
protractor = require 'protractor'
dbhelper = require '../../lib/dbhelper'

worldDefinition = () ->

  ptor = null
  driver = null

  class World
    constructor: (callback) ->
      @browser = ptor
      @By = protractor.By
      @assert = assert
      callback()

  capabilities = webdriver.Capabilities.firefox()
  # .merge
  #   username: process.env.SAUCE_USERNAME
  #   accessKey: process.env.SAUCE_ACCESS_KEY
  #   name: 'gi-security protractor test'
  #   browserName: 'Chrome'
  #   platform: 'Windows 7'
  #   'record-video': true
  #   'tunnel-identifier': process.env.DRONE_BUILD_NUMBER

  @BeforeFeatures (event, callback) ->
    driver = new webdriver.Builder().
    usingServer('http://192.168.1.72:4444/wd/hub').
    withCapabilities(capabilities).build()

    ptor = protractor.wrapDriver driver
    ptor.driver.manage().timeouts().setScriptTimeout 10000
    dbhelper.initializeDB callback

  @AfterFeatures (event, callback) ->
    driver.quit().then (err) ->
      callback err

  @World = World

module.exports = worldDefinition