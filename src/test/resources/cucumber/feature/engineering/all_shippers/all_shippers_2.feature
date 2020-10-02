@OperatorV2 @Engineering @AllShippers
Feature: All Shippers Ext

  @LaunchBrowser @EnableClearCache @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario Outline: Create Marketplace Shipper - All Mandatory Field is Filled (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive                     | <isShipperActive>                     |
      | shipperType                         | <shipperType>                         |
      | ocVersion                           | <ocVersion>                           |
      | services                            | <services>                            |
      | trackingType                        | <trackingType>                        |
      | isAllowCod                          | <isAllowCod>                          |
      | isAllowCashPickup                   | <isAllowCashPickup>                   |
      | isPrepaid                           | <isPrepaid>                           |
      | isAllowStagedOrders                 | <isAllowStagedOrders>                 |
      | isMultiParcelShipper                | <isMultiParcelShipper>                |
      | isDisableDriverAppReschedule        | <isDisableDriverAppReschedule>        |
      | pricingScriptName                   | {pricing-script-name}                 |
      | industryName                        | {industry-name}                       |
      | salesPerson                         | {sales-person}                        |
      | marketplace.ocVersion               | <ocVersion>                           |
      | marketplace.selectedOcServices      | <marketplace.selectedOcServices>      |
      | marketplace.trackingType            | <marketplace.trackingType>            |
      | marketplace.isAllowCod              | <isAllowCod>                          |
      | marketplace.isAllowCashPickup       | <isAllowCashPickup>                   |
      | marketplace.isPrepaid               | <isPrepaid>                           |
      | marketplace.isAllowStagedOrders     | <isAllowStagedOrders>                 |
      | marketplace.isMultiParcelShipper    | <isMultiParcelShipper>                |
      | marketplace.premiumPickupDailyLimit | <marketplace.premiumPickupDailyLimit> |
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    Examples:
      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule | marketplace.selectedOcServices | marketplace.trackingType | marketplace.premiumPickupDailyLimit |
      | Shipper V4 | uid:d2e1910f-c572-4e0a-b955-4b84847c832d | true            | Marketplace | v4        | STANDARD | Fixed        | false      | true              | true      | false               | false                | false                        | 3DAY                           | Dynamic                  | 3                                   |

  @CloseNewWindows
  Scenario Outline: Create new Pick-up Address on Edit Shipper page (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | <isShipperActive>              |
      | shipperType                  | <shipperType>                  |
      | ocVersion                    | <ocVersion>                    |
      | services                     | <services>                     |
      | trackingType                 | <trackingType>                 |
      | isAllowCod                   | <isAllowCod>                   |
      | isAllowCashPickup            | <isAllowCashPickup>            |
      | isPrepaid                    | <isPrepaid>                    |
      | isAllowStagedOrders          | <isAllowStagedOrders>          |
      | isMultiParcelShipper         | <isMultiParcelShipper>         |
      | isDisableDriverAppReschedule | <isDisableDriverAppReschedule> |
      | pricingScriptName            | {pricing-script-name}          |
      | industryName                 | {industry-name}                |
      | salesPerson                  | {sales-person}                 |
      | pickupAddressCount           | 1                              |
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    Examples:
      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
      | Shipper V4 | uid:9e6b8454-b6b0-463d-9d4d-3b453af19b96 | true            | Normal      | v4        | NEXTDAY  | Fixed        | false      | true              | true      | false               | false                | false                        |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
