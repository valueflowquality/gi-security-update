module.exports = ->

  @Given /^I am on the homepage$/, (callback) ->
    @browser.get('http://localhost:3000').then ->
      callback()
  @Then /^I should see a welcome message/, (callback) ->
    @browser.findElement(@By.tagName 'p').getText().then (text) =?
      @assert.equal text, 'bob'
      callback()