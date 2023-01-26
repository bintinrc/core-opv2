@OperatorV2 @CoreV2 @PickupAppointment @BulkUpdatePickupJobs
Feature: Pickup Appointment Job - Bulk update on pickup jobs page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  Scenario: Bulk select on Pickup Jobs page result table - select all shown
    When Operator goes to Pickup Jobs Page
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page

  Scenario: Bulk select on Pickup Jobs page result table - select all shown filtered
    When Operator goes to Pickup Jobs Page
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    And Operator filters on the table with values below:
      | status | Ready for Routing |
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page
    And Operator filters on the table with values below:
      | status | Clear All |
    Then Operator verify number of selected row is not updated


  Scenario: Bulk select on Pickup Jobs page result table - clear selection
    When Operator goes to Pickup Jobs Page
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page
    Given  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Clear Selection" button on Pickup Jobs page
    Then Operator verify the number of selected rows is "0"


  Scenario: Bulk select on Pickup Jobs page result table - display only selected
    When Operator goes to Pickup Jobs Page
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Display only selected" button on Pickup Jobs page
    Then Operator verify the number of selected rows is "1"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op