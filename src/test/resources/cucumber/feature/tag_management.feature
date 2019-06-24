@OperatorV2 @OperatorV2Part1 @TagManagement @Saas @CWF @SIT
Feature: Tag Management

  @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator create, update and delete tag on Tag Management menu. (uid:a49a930e-1fb2-4a0c-8a8f-8bbccc5d87cc)
    Given Operator V2 cleaning Tag Management by calling API endpoint directly
    Given Operator go to menu Routing -> Tag Management
    When Operator create new tag on Tag Management
    Then Operator verify the new tag is created successfully on Tag Management
    When Operator update tag on Tag Management
    Then Operator verify the tag is updated successfully on Tag Management
    Then Operator V2 cleaning Tag Management by calling API endpoint directly
# This 2 steps below is removed because KH said the ops want that button to be removed.
#    When Operator delete tag on Tag Management
#    Then Operator verify the tag is deleted successfully on Tag Management

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
