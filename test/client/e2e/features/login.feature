Feature: login

  Scenario: View the login page
    Given I am on the homepage
    When I navigate to the login page
    Then I should see a username input box