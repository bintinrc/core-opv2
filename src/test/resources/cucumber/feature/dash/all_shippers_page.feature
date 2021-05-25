@MileZero
Feature: All Shippers page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipper @CloseNewWindows
  Scenario: Ninja dash - create normal shipper in OPv2 - automatically create its dash account
    Given Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
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
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator login to Ninja Dash as shipper "{KEY_CREATED_SHIPPER.name}" from All Shippers page
    Then account name is "{KEY_CREATED_SHIPPER.name}" on Ninja Dash page

  @DeleteShipper @CloseNewWindows
  Scenario: Ninja dash - change email login from OPv2 - username eligible
    Given Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
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
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator update basic settings of shipper "{KEY_CREATED_SHIPPER.name}":
      | dashUsername | dash-username-{gradle-current-date-yyyyMMddHHmmsss}@ninjavan.co
    And Operator login to Ninja Dash as shipper "{KEY_CREATED_SHIPPER.name}" from All Shippers page
    Then account name is "{KEY_CREATED_SHIPPER.name}" on Ninja Dash page

  @DeleteShipper @CloseNewWindows
  Scenario: Ninja dash - change email login from OPv2 - username not eligible
    Given Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
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
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator open Edit Shipper Page of shipper "{KEY_CREATED_SHIPPER.name}"
    And Operator fill shipper basic settings:
      | dashUsername | {operator-b2b-master-shipper-email} |
    And Operator click Save Changes on edit shipper page
    Then Operator verifies toast "Shipper Details (Basic Settings) - models: unable to update user_identities row: Error 1062: Duplicate entry 'dash.corporate+2@ninjavan.co-nv-username-password' for key 'user_identities_provider_user_id_uidx'" displayed on edit shipper page

  @DeleteShipper @CloseNewWindows
  Scenario: Ninja dash - change shipper name from OPv2
    Given Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
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
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator update basic settings of shipper "{KEY_CREATED_SHIPPER.name}":
      | shipperName | TEST-SHIPPER-{gradle-current-date-yyyyMMddHHmmsss} |
    And Operator login to Ninja Dash as shipper "TEST-SHIPPER-{gradle-current-date-yyyyMMddHHmmsss}" from All Shippers page
    Then account name is "TEST-SHIPPER-{gradle-current-date-yyyyMMddHHmmsss}" on Ninja Dash page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
