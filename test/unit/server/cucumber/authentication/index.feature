Feature: gint-security.authentication
  Scenario: Public Exports publicRead(req, res, next)
    Given the authentication module is required
    When it is initialized with an express app
    Then it exports a publicReadAction function

Feature: publicRead(req, res, next) middleware
  Background:
    Given the authentication module is required
    And it is initialized with an express app
    And a request to a known host

  Scenario: Anonymous users can get all public read resources
    Given an anonymous request to GET /api/aResource
    When this is passed through the publicReadAction middleware
    Then the request should have a publicRead acl filter applied
    And the request should have a systemId
    And the request should be allowed
  
  Scenario: Anoynmous users can get specific public read resources
    Given an anonymous request to GET /api/aResource/1
    When this is passed through the publicReadAction middleware
    Then the request should have a publicRead acl filter applied
    And the request should have a systemId
    And the request should be allowed

  Scenario: Anonymous users can count public read resources
    Given an anonymous request to GET /api/aResource/count
    When this is passed through the publicReadAction middleware
    Then the request should have a publicRead acl filter applied
    And the request should have a systemId
    And the request should be allowed

  Scenario: Anonymous users cannot create public read resources
    Given an anonymous request to POST /api/aResource
    When this is passed through the publicReadAction middleware
    Then the request should be dissalowed

  Scenario: Anonymous users cannot update public read resources
    Given an anonymous request to PUT /api/aResource/1
    When this is passed through the publicReadAction middleware
    Then the request should be dissalowed

  Scenario: Anonymous users cannot delete public read resources
    Given an anonymous request to DELETE /api/aResource/1
    When this is passed through the publicReadAction middleware
    Then the request should be dissalowed