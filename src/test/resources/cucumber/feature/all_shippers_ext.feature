@OperatorV2Disabled @OperatorV2Part2Disabled @AllShippersExt @Saas
Feature: All Shippers

  @LaunchBrowser @EnableClearCache @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario Outline: Operator Create Marketplace Shipper (<hiptest-uid>)
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
      | marketplace.selectedOcServices      | <services>                            |
      | marketplace.trackingType            | <marketplace.trackingType>            |
      | marketplace.isAllowCod              | <isAllowCod>                          |
      | marketplace.isAllowCashPickup       | <isAllowCashPickup>                   |
      | marketplace.isPrepaid               | <isPrepaid>                           |
      | marketplace.isAllowStagedOrders     | <isAllowStagedOrders>                 |
      | marketplace.isMultiParcelShipper    | <isMultiParcelShipper>                |
      | marketplace.premiumPickupDailyLimit | <marketplace.premiumPickupDailyLimit> |
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    When Operator login to created Shipper's Dashboard from All Shipper page
    Then Operator validate new Shipper is logged in on Dashboard site
    Examples:
      | Note       | hiptest-uid | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule | marketplace.trackingType | marketplace.premiumPickupDailyLimit |
      | Shipper V4 |             | true            | Marketplace | v4        | 3DAY     | Fixed        | false      | true              | true      | false               | false                | false                        | Prefixless               | 3                                   |

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
    When Operator login to created Shipper's Dashboard from All Shipper page
    And Operator go to menu "Deliveries" -> "Pickup Management" on Dashboard site
    Then Operator verify pickup addresses of the new Shipper on Dashboard site
    Examples:
      | Note       | hiptest-uid | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule | marketplace.trackingType | marketplace.premiumPickupDailyLimit |
      | Shipper V4 |             | true            | Normal      | v4        | 3DAY     | Fixed        | false      | true              | true      | false               | false                | false                        | Prefixless               | 3                                   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
