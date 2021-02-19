@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @CreatePricingProfiles @HappyPath
Feature: All Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Create a new Shipper - Not Creating Pricing Profile (uid:d1fae013-c731-4838-9905-97cf7ee61273)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings and without Pricing profile using data below:
      | isShipperActive              | true            |
      | shipperType                  | Normal          |
      | ocVersion                    | v4              |
      | services                     | STANDARD        |
      | trackingType                 | Fixed           |
      | isAllowCod                   | true            |
      | isAllowCashPickup            | true            |
      | isPrepaid                    | true            |
      | isAllowStagedOrders          | true            |
      | isMultiParcelShipper         | true            |
      | isDisableDriverAppReschedule | true            |
      | industryName                 | {industry-name} |
      | salesPerson                  | {sales-person}  |

  @CloseNewWindows @DeletePricingProfile
  Scenario: Create Pricing Profile - with Flat Discount where Shipper has Active & Expired Pricing Profile (uid:2213f013-1e32-4264-a795-55792c1c3af0)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper with ID and Name "{shipper-v4-active-expired-pp-legacy-id}-{shipper-v4-active-expired-pp-name}"
    Then Operator verifies that Pricing Script is "Active" and "Expired"
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 20.00                                           |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows
  Scenario: Create Pricing Profile - with 0 Flat Discount (uid:54a634fc-bcb1-4cec-9b7f-919341c5bddd)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds pricing script with invalid discount and verifies the error message
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 0                                               |
      | errorMessage      | 0 is not a valid discount value                 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
