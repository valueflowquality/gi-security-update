module.exports = ->

  @Given /^I am on the homepage$/, (callback) ->
    @browser.get('http://test.gint-security.com:3000').then ->
      callback()
  @Then /^I should see a welcome message/, (callback) ->
    @browser.findElement(@By.tagName 'p').getText().then (text) =>
      @assert.equal text, 'This is the landing home page for gint-security example'
      callback()