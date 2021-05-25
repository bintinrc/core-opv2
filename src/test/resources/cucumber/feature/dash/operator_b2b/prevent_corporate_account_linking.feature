@MileZero @B2B
Feature: Prevent Corporate account linking

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2 go to menu all shipper
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipper
  Scenario: Create Corporate HQ using the existing email - same country
    Given Operator go to menu Shipper -> All Shippers
    When Operator fail create new Shipper with basic settings using data below:
      | isShipperActive              | true                                |
      | shipperType                  | Corporate HQ                        |
      | email                        | {operator-b2b-master-shipper-email} |
      | ocVersion                    | v4                                  |
      | services                     | STANDARD                            |
      | trackingType                 | Fixed                               |
      | isAllowCod                   | false                               |
      | isAllowCashPickup            | true                                |
      | isPrepaid                    | true                                |
      | isAllowStagedOrders          | false                               |
      | isMultiParcelShipper         | false                               |
      | isDisableDriverAppReschedule | false                               |
      | isCorporate                  | true                                |
      | pricingScriptName            | {pricing-script-name}               |
      | industryName                 | {industry-name}                     |
      | salesPerson                  | {sales-person}                      |
    Then Operator verifies toast "Shipper Email (Basic Settings)" displayed on edit shipper page

  @DeleteShipper
  Scenario: Create Corporate HQ using the existing email - different country
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Corporate HQ          |
      | email                        | {my-shipper-email}    |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | isCorporate                  | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
