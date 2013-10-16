Feature: login
  
  Scenario: View the home page
    Given I am on the home page
    Then I should see a welcome message
    And I should not see a username input box

  Scenario: View the login page
    Given I am on the login page
    Then I should see a welcome message
    Then I should see a username input box

  Scenario: Allow login with facebook 
    Given facebook is an approved login method
    When I am on the login page
    Then I should see a login with facebook button

  Scenario: Prevent login with facebook
    Given facebook is not an approved login method
    When I am on the login page
    Then I should not see a login with facebook button

  Scenario: View Message on login failure
    Given I am on the login page
    Then I should not see a message telling me login has failed
    When I log in with incorrect details
    Then I should see a message telling me login has failed

  Scenario: Dismiss login failure message
    Given I am on the login page
    And I log in with incorrect details
    When I click to dismiss the login fail message
    Then I should not see a message telling me login has failed
