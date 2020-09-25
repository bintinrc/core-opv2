@OperatorV2 @Core @Routing @TagManagement
Feature: Tag Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Create New Tag on Tag Management Page (uid:20d3f2d8-175b-4b13-8e53-fb6538f81d7a)
    Given Operator V2 cleaning Tag Management by calling API endpoint directly
    Given Operator go to menu Routing -> Tag Management
    When Operator create new tag on Tag Management
    Then Operator verify the new tag is created successfully on Tag Management
    Then Operator V2 cleaning Tag Management by calling API endpoint directly

  Scenario: Operator Update Created Tag on Tag Management Page (uid:76073751-6e4c-4c67-9ba2-eca45cbac413)
    Given Operator V2 cleaning Tag Management by calling API endpoint directly
    Given Operator go to menu Routing -> Tag Management
    When Operator create new tag on Tag Management
    Then Operator verify the new tag is created successfully on Tag Management
    When Operator update tag on Tag Management
    Then Operator verify the tag is updated successfully on Tag Management
    Then Operator V2 cleaning Tag Management by calling API endpoint directly

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
