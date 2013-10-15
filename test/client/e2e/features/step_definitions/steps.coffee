dbhelper = require '../../../../lib/dbhelper'
module.exports = ->

  @Given /^I (?:am on|navigate to|visit) the (.*) page$/, (page, callback) ->
    path = '/'
    if page isnt 'home'
      path += page

    @browser.get('http://test.gint-security.com:3000' + path).then ->
      callback()

  @When /^facebook (is|is not) an approved login method$/
  , (approved, callback) ->
    allowFacebookLogin = false
    if approved is 'is'
      allowFacebookLogin = true

    dbhelper.setSetting 'loginWithFacebook', allowFacebookLogin
    , 'public-read', callback

  @Then /^I should see a welcome message/, (callback) ->
    @browser.findElement(@By.tagName 'p').getText().then (text) =>
      expected = 'This is the gint-security test-suite'
      if text is expected
        callback()
      else
        e = new Error("Expected - " + text + ' - to equal - ' + expected)
        callback.fail e

  @Then /^I (should|should not) see a username input box$/, (which, callback) ->
    shouldI = false
    if which is 'should'
      shouldI = true

    @browser.isElementPresent(@By.input 'cred.username')
    .then (usernamePresent) ->
      if usernamePresent isnt shouldI
        message = "Username input incorrectly shown"
        if shouldI
          message = "Could not find username input"
        callback.fail new Error(message)
      else
        callback()

  @Then /^I (should|should not) see a login with facebook button$/
  , (which, callback) ->
    shouldI = false
    if which is 'should'
      shouldI = true

    @browser.isElementPresent(@By.css "div.loginWithFacebook")
    .then (imgPresent) ->
      if imgPresent isnt shouldI
        message = "Login With facebook button should not be present"
        if shouldI
          message = "Could not find Login with facebook button"
        callback.fail new Error(message)
      else
        callback()