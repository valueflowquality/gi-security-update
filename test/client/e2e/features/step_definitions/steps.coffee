module.exports = ->

  @Given /^I am on the homepage$/, (callback) ->
    @browser.get('http://test.gint-security.com:3000').then ->
      callback()

  @Then /^I should see a welcome message/, (callback) ->
    @browser.findElement(@By.tagName 'p').getText().then (text) =>
      expected = 'This is the gint-security test-suite'
      if text is expected
        callback()
      else
        e = new Error("Expected - " + text + ' - to equal - ' + expected)
        callback.fail e

  @Then /^I should not see a username input box$/, (callback) ->
    @browser.isElementPresent(@By.input 'cred.username').then (usernamePresent) ->
      if usernamePresent
        callback.fail new Error("Username input was present")
      else
        callback()

  @When /^I navigate to the login page/, (callback) ->
    @browser.get('http://test.gint-security.com:3000/login').then ->
      callback()

  @Then /^I should see a username input box$/, (callback) ->
    @browser.isElementPresent(@By.input 'cred.username').then (usernamePresent) ->
      if usernamePresent
        callback()
      else
        callback.fail new Error("Could not find username input")
