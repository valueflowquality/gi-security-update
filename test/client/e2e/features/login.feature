Feature: login
  
  Scenario: View the home page
    Given I am on the homepage
    Then I should see a welcome message
    And I should not see a username input box

  Scenario: View the login page
    Given I am on the homepage
    When I navigate to the login page
    Then I should see a username input box

  Scenario: Allow login with facebook 
    Given I am on the login page
    When facebook is an approved login method
    Then I should see a login with facebook button

  Scenario: Prevent login with facebook
    Given I am on the login page
    When facebook is not an approved login method
    Then I should not see a login with facebook button