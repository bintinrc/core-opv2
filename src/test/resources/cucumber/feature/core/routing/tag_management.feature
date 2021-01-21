@OperatorV2 @Core @Routing @TagManagement
Feature: Tag Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteTags
  Scenario: Operator Create New Tag on Tag Management Page (uid:20d3f2d8-175b-4b13-8e53-fb6538f81d7a)
    Given Operator go to menu Routing -> Tag Management
    When Operator create new route tag on Tag Management page:
      | name        | AAA                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    Then Operator verify the new tag is created successfully on Tag Management

  @DeleteRouteTags
  Scenario: Operator Update Created Tag on Tag Management Page (uid:76073751-6e4c-4c67-9ba2-eca45cbac413)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route tag:
      | name        | AAA                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    When Operator go to menu Routing -> Tag Management
    And Operator update created tag on Tag Management page:
      | name        | AAB                                                                                        |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. [EDITED] |
    Then Operator verify the tag is updated successfully on Tag Management

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op