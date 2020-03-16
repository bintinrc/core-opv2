@OperatorV2 @OperatorV2Part1 @BulkOrders
Feature: Bulk Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator find Bulk Order
    Given API Operator retrieve information about Bulk Order with ID "{bulk-order-id}"
    When Operator go to menu New Features -> Bulk Order
    And Operator search for created Bulk Order on Bulk Orders page
    Then Operator verify created Bulk Order on Bulk Orders page

  Scenario: Bulk ID - See detail inside bulk id
    Given API Operator retrieve information about Bulk Order with ID "{bulk-order-id}"
    When Operator go to menu New Features -> Bulk Order
    And Operator search for created Bulk Order on Bulk Orders page
    Then Operator verify details of created Bulk Order on Bulk Orders page

  Scenario: Bulk ID - Print detail bulk id
    Given API Operator retrieve information about Bulk Order with ID "{bulk-order-id}"
    When Operator go to menu New Features -> Bulk Order
    And Operator search for created Bulk Order on Bulk Orders page
    Then Operator print created Bulk Order on Bulk Orders page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
