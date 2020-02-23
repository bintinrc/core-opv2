@OperatorV2 @OperatorV2Part1 @Addressing
Feature: Addressing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator adds new address on Addressing Page (uid:baee8a52-1dc5-4064-92b4-aeddfbd7a445)
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    And Operator searches the address that has been made on Addressing Page
    Then Operator verifies the address exists on Addressing Page
    When Operator delete the address that has been made on Addressing Page
    Then Operator verifies the address does not exist anymore on Addressing Page

  Scenario: Operator searches address on Addressing Page (uid:3301502a-65ce-4e64-9a90-d8a06acaa554)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    And Operator searches the address that has been made on Addressing Page
    Then Operator verifies the address exists on Addressing Page
    When Operator delete the address that has been made on Addressing Page
    Then Operator verifies the address does not exist anymore on Addressing Page

  Scenario: Operator deletes address on Addressing Page (uid:5d78f636-fa3d-4ab3-b084-476d5f686a49)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    And Operator searches the address that has been made on Addressing Page
    Then Operator verifies the address exists on Addressing Page
    When Operator delete the address that has been made on Addressing Page
    Then Operator verifies the address does not exist anymore on Addressing Page

  Scenario: Operator edits address on Addressing Page (uid:e6861e4e-7257-4038-bedd-0e2c0a02dd39)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    And Operator searches the address that has been made on Addressing Page
    And Operator edits the address on Addressing Page
    And Operator searches the address that has been edited on Addressing Page
    Then Operator verifies the address has been changed
    When Operator delete the address that has been made on Addressing Page
    Then Operator verifies the address does not exist anymore on Addressing Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser @Debug
    Given no-op
