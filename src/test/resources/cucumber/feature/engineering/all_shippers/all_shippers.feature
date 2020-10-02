@OperatorV2 @Engineering @AllShippers
Feature: All Shippers

  @LaunchBrowser @ShouldAlwaysRun @EnableClearCache
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ResetWindow
  Scenario: Create Normal Shipper V4 - All Mandatory Field is Filled (uid:92953139-5c34-4299-91a1-ff0997220d79)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    And Operator go back to Shipper List page
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the shipper is deleted successfully

  @ResetWindow
  Scenario: Update Shipper Settings - Any version of Normal Shipper (uid:f87c4563-9730-43bd-b177-980e61c7a252)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    And Operator go back to Shipper List page
    When Operator update Shipper's basic settings
    And Operator go back to Shipper List page
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify Shipper's basic settings is updated successfully
    And Operator go back to Shipper List page
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the shipper is deleted successfully

  Scenario: Search Shipper By Filters - Liaison Email (uid:a0f6cd70-6b16-47b8-8248-6d1d1b41356b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Liaison Email" filter
    Then Operator searches the "Liaison Email" field with "Ninja" keyword
    Then Operator verifies that the results have keyword "Ninja" in "Liaison Email" column

  Scenario: Search Shipper By Filters - Email (uid:ee5ee0d5-0931-4610-9f02-877b81bd62cb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Email" filter
    Then Operator searches the "Email" field with "Ninja" keyword
    Then Operator verifies that the results have keyword "Ninja" in "Email" column

  Scenario: Search Shipper By Filters - Contact (uid:1ffb06aa-bf56-4d22-9096-9d005d66ab59)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Contact" filter
    Then Operator searches the "Contact" field with "12345" keyword
    Then Operator verifies that the results have keyword "12345" in "Contact" column

  Scenario: Search Shipper By Filters - Active (uid:c6087386-0629-4113-9baf-3a8550fde66b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Active" filter
    Then Operator searches for Shippers with Active filter
    Then Operator verifies that the results have keyword "Active" in "Status" column

  Scenario: Search Shipper By Filters - Shipper (uid:dd5649bb-f9be-4b39-b5d5-f0573d90beec)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Shipper" filter
    Then Operator searches the "Shipper" field with "Ninja" keyword
    Then Operator verifies that the results have keyword "Ninja" in "Name" column

  Scenario: Search Shipper By Filters - Industry (uid:9a12f0e2-87a4-4ca6-b098-c3c9a592194e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Industry" filter
    Then Operator searches the "Industry" field with "Fashion" keyword
    Then Operator verifies that the results have keyword "Fashion" in "Industry" column

  Scenario: Search Shipper By Filters - Salesperson (uid:16d22b36-bcb8-456c-b4e6-c22973221a75)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Salesperson" filter
    Then Operator searches the "Salesperson" field with "TS1" keyword
    Then Operator verifies that the results have keyword "TS1" in "Salesperson" column

  Scenario: Search Shipper By Filters - Quick Search (uid:f88d84fd-c365-44f9-9dd9-0b569a36a794)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator searches for keyword "Ninja" in quick search filter
    Then Operator verifies that the results have keyword "Ninja" in "Name" column

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op