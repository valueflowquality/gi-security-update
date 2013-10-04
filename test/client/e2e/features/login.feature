Feature: login
  
  Scenario: View the home page
    Given I am on the homepage
    Then I should see a welcome message

  Scenario: View the login page
    Given I am on the homepage
    Then I should not see a username input box
    When I navigate to the login page
    Then I should see a username input box