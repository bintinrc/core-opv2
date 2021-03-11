@OperatorV2 @Driver @Messaging @Debug
Feature: Messaging

  @LaunchBrowser @ShouldAlwaysRun @Debug
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Driver by First Name (uid:f87966e7-8c79-4770-81a0-53157b0a15dc)
    And DB Operator find drivers by "Driver" first name
    And API Operator find drivers by "Driver" first name
    Then Drivers found by first name using API and DB are the same
    When Operator opens Messaging panel
    And Operator enters "Driver" into Add Driver field on Messaging panel
    Then Drivers found on Messaging panel and in DB are the same

  Scenario: Search Driver by Driver Type Given Less Than 100 Drivers Listed Use Same Type (uid:f31378ea-f465-4de6-96bf-f4f0cb795e80)
    Given Operator refresh page
    And DB Operator find drivers by "{driver-type-name-2}" driver type name
    When Operator opens Messaging panel
    And Operator selects "{driver-type-name-2}" drivers group on Messaging panel
    Then Count of selected drivers is less than 100 on Messaging panel
    And All selected drivers belongs to selected group

  Scenario: Search Driver by Driver Type Given More Than 100 Drivers Listed Use Same Type (uid:dc3045fa-6807-4f19-a603-ea5a4429d88e)
    Given Operator refresh page
    And DB Operator find drivers by "{driver-type-name}" driver type name
    When Operator opens Messaging panel
    And Operator selects "{driver-type-name}" drivers group on Messaging panel
    Then Count of selected drivers is greater than 100 on Messaging panel
    And All selected drivers belongs to selected group


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
