@MileZero @Loyalty
Feature: Shipper Billing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Loyalty - upload file - child account - empty email (uid:a53bbdfc-c918-4eac-add9-6ff1651afb54)
    When Operator go to menu Shipper -> Loyalty Creation
    And Operator add shipper with empty email to csv file for loyalty creation
    And Operator upload csv file for loyalty creation
    Then Operator check result message "We've detected some errors in the file. Please correct them and upload" displayed
    And Operator refresh page

  Scenario: Loyalty - upload file - child account - empty phone number (uid:5b88b5cc-a5b1-4986-8b88-6b6038bdbdf9)
    When Operator go to menu Shipper -> Loyalty Creation
    And Operator add shipper with empty phone number to csv file for loyalty creation
    And Operator upload csv file for loyalty creation
    Then Operator check result message "We've detected some errors in the file. Please correct them and upload" displayed
    And Operator refresh page

  Scenario: Loyalty - upload file - child account - empty email and phone number (uid:a01b5199-3634-4053-945b-443ccc2df173)
    When Operator go to menu Shipper -> Loyalty Creation
    And Operator add shipper with empty email and phone number to csv file for loyalty creation
    And Operator upload csv file for loyalty creation
    Then Operator check result message "We've detected some errors in the file. Please correct them and upload" displayed
    And Operator refresh page

  @DeleteShipper
  Scenario: Loyalty - upload file - parent and child account (uid:e282bad5-6918-4ca6-9053-b45ab709611c)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Corporate HQ          |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | isCorporateReturn            | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator go to menu Shipper -> All Shippers
    And Operator open Edit Shipper Page of created shipper
    And Operator add created shipper to new csv file for loyalty creation
    And Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created
    And API Operator get b2b sub shippers for master shipper id "KEY_LEGACY_SHIPPER_ID"
    And Operator go to menu Shipper -> Loyalty Creation
    And Operator add created sub shipper to csv file for loyalty creation
    And Operator upload csv file for loyalty creation
    And Operator loyalty creation confirmation
    Then Operator check result message "All membership accounts have been created!" displayed
    And Operator refresh page

  Scenario: Loyalty - upload file - child/parent account exist (uid:f923f67d-fb6b-49b1-bd32-a5f8d58aa281)
    When Operator go to menu Shipper -> Loyalty Creation
    And Operator upload csv file for loyalty creation
    And Operator loyalty creation confirmation
    Then Operator check result message "Membership account creation was only partially successful" displayed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
