@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @CreatePricingProfiles @DeliveryDiscount
Feature: Marketplace Shipper

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Create a new Marketplace Shipper - Create Pricing Profile (uid:bc736a20-01fe-40d6-8839-dc7dcdf4c5d7)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive                     | true                  |
      | shipperType                         | Marketplace           |
      | ocVersion                           | v4                    |
      | services                            | STANDARD              |
      | trackingType                        | Fixed                 |
      | isAllowCod                          | true                  |
      | isAllowCashPickup                   | true                  |
      | isPrepaid                           | true                  |
      | isAllowStagedOrders                 | true                  |
      | isMultiParcelShipper                | true                  |
      | isDisableDriverAppReschedule        | true                  |
      | pricingScriptName                   | {pricing-script-name} |
      | industryName                        | {industry-name}       |
      | salesPerson                         | {sales-person}        |
      | marketplace.ocVersion               | v4                    |
      | marketplace.selectedOcServices      | 3DAY                  |
      | marketplace.trackingType            | Dynamic               |
      | marketplace.premiumPickupDailyLimit | 2                     |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | discount          | 2.00                                            |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct