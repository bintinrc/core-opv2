@MileZero @Loyalty
Feature: Shipper Billing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Loyalty - upload file failed - required file empty (uid:480e920e-5cb9-4393-8a68-48012243ea35)
    When Operator go to menu Shipper -> Loyalty Creation
    And Operator upload file for loyalty creation contains created shipper
    Then Operator check result message "We've detected some errors in the file. Please correct them and upload" displayed
    And Operator refresh page

  @ShouldAlwaysRun
  Scenario: Loyalty - upload file - parent account (uid:8c396265-31e2-4b3d-9566-384d84326837)
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
    And Operator go to menu Shipper -> Loyalty Creation
    And Operator upload file for loyalty creation contains created shipper
    And Operator loyalty creation confirmation
    Then Operator check result message "All membership accounts have been created!" displayed
    And Operator refresh page

  Scenario: Loyalty - upload file failed - phone number not unique (uid:49df0ad4-0bfe-4ccd-a656-3c006d369d00)
    When Operator go to menu Shipper -> Loyalty Creation
    And Operator upload existing file for loyalty creation
    And Operator loyalty creation confirmation
    Then Operator check result message "Membership account creation was only partially successful" displayed

  Scenario: Loyalty - upload file failed - email is not unique (uid:4d47fe81-d45c-43f3-a356-7236665b63c5)
    When Operator go to menu Shipper -> Loyalty Creation
    And Operator upload existing file for loyalty creation
    And Operator loyalty creation confirmation
    Then Operator check result message "Membership account creation was only partially successful" displayed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
