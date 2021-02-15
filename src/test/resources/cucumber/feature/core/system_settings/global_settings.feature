@OperatorV2 @Core @SystemSettings @GlobalSettings
Feature: Global Settings

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @RestoreInboundSettings
  Scenario: Operator Set Global Inbound Weight Settings - Weight Tollerance (uid:6d7fa00e-5af8-4831-9edf-16bd18faf707)
    When Operator go to menu System Settings -> Global Settings
    And Operator save inbound settings from Global Settings page
    And Operator set Weight Tolerance value to "44" on Global Settings page
    And Operator save Weight Tolerance settings on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies Weight Tolerance value is "44" on Global Settings page
    And DB Operator verify 'inbound_weight_tolerance' parameter is "44"

  @RestoreInboundSettings
  Scenario: Operator Set Global Inbound Weight Settings - Weight Limit (uid:9adccb4b-c7c7-49e3-91cf-3890d6ac4c4f)
    When Operator go to menu System Settings -> Global Settings
    And Operator save inbound settings from Global Settings page
    And Operator set Weight Limit value to "44" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies Weight Limit value is "44" on Global Settings page
    And DB Operator verify 'inbound_max_weight' parameter is "44"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op