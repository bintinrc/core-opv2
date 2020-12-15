@OperatorV2 @Core @Addressing
Feature: Addressing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteAddress
  Scenario: Operator Adds New Address on Addressing Page (uid:a15fc921-f0d4-4f69-a13e-64cbac92df84)
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    And Operator searches the address that has been made on Addressing Page
    Then Operator verifies the address exists on Addressing Page

  @DeleteAddress
  Scenario: Operator Searches Address on Addressing Page (uid:40b89573-88d3-4e72-89a3-6fba0c42730b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    And Operator searches the address that has been made on Addressing Page
    Then Operator verifies the address exists on Addressing Page

  @DeleteAddress
  Scenario: Operator Deletes Address on Addressing Page (uid:4ea12392-c48c-43a0-8ffc-cc56d41cd8c0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    And Operator searches the address that has been made on Addressing Page
    Then Operator verifies the address exists on Addressing Page
    When Operator delete the address that has been made on Addressing Page
    Then Operator verifies the address does not exist anymore on Addressing Page

  @DeleteAddress
  Scenario: Operator Edits Address on Addressing Page (uid:2b28baed-74ae-48e4-a508-56a2aa4dfc6b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    And Operator searches the address that has been made on Addressing Page
    And Operator edits the address on Addressing Page
    And Operator searches the address that has been edited on Addressing Page
    Then Operator verifies the address has been changed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op