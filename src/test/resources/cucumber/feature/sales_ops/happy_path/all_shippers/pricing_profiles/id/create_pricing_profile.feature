@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesID @CreatePricingProfilesID @HappyPathID
Feature: All Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @DeletePricingProfile
  Scenario: Create Pricing Profile - with Percentage Discount where Shipper has Active & Expired Pricing Profile (uid:855e77b3-1187-4bd2-aeaa-4040074f7894)
    Given Operator changes the country to "Indonesia"
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-active-expired-pp-legacy-id}"
    Then Operator verifies that Pricing Script is "Active" and "Expired"
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 20.00                                           |
      | comments          | This is a test pricing script                   |
      | type              | PERCENTAGE                                      |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows
  Scenario: Create Pricing Profile - with none Percentage Discount (uid:e2d9b2a8-6013-4e50-aeee-91561108b174)
    Given Operator changes the country to "Indonesia"
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
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-2-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | comments          | This is a test pricing script                   |
      | type              | PERCENTAGE                                      |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile details
    And Operator verifies the pricing profile and shipper discount details are correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
