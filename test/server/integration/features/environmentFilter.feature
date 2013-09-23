Feature: Checks requests have an environment
  Background:
    Given a request to get all users
    And a valid expiry date

  Scenario: 
    When the request is addressed to an unknown host
    But is from a valid user
    And has a valid message signature
    Then it returns with error message Environment Not Found in the response body
    And it replies with a server error

  Scenario: 
    When the request is addressed to a known host
    And is from an unknown user
    But has a valid message signature
    Then it returns nothing in the message body
    And it replies with unauthorized

  Scenario:
    When the request is addressed to a known host
    And is from a valid user
    And has a valid message signature
    When the reply is received
    Then it returns the list of users in the message body
    And it replies with ok