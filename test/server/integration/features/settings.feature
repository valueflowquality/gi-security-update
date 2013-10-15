Feature: Settings
  Background:
    Given there is a public read setting called aPublicReadSetting
    And there is a public read setting called anotherPublicReadSetting
    And there is a private setting called aPrivateSetting

  Scenario: Anonymous users can view public settings
    Given an anonymous api request to get all settings
    Given the request is addressed to a known host
    When the reply is received
    Then it replies with ok
    And it should contain 2 items
    And it should contain a list of only public-read settings