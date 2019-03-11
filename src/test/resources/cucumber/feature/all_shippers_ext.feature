@OperatorV2 @OperatorV2Part2 @AllShippersExt @Saas @CWF
Feature: All Shippers Ext

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
#    When Operator login to created Shipper's Dashboard from All Shipper page
#    Then Operator validate new Shipper is logged in on Dashboard site
    Examples:
      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule | marketplace.selectedOcServices | marketplace.trackingType | marketplace.premiumPickupDailyLimit |
      | Shipper V4 | uid:bc736a20-01fe-40d6-8839-dc7dcdf4c5d7 | true            | Marketplace | v4        | STANDARD | Fixed        | false      | true              | true      | false               | false                | false                        | 3DAY                           | Prefixless               | 3                                   |

  @CloseNewWindows
  Scenario Outline: Operator Create new Pick-up Address on Edit Shipper page (<hiptest-uid>)
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
#    When Operator login to created Shipper's Dashboard from All Shipper page
#    And Operator go to menu "Deliveries" -> "Pickup Management" on Dashboard site
#    Then Operator verify pickup addresses of the new Shipper on Dashboard site
    Examples:
      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
      | Shipper V4 | uid:447de852-5093-4367-bbf2-51c135e0b9d9 | true            | Normal      | v4        | NEXTDAY  | Fixed        | false      | true              | true      | false               | false                | false                        |

#  @CloseNewWindows @RT
#  Scenario Outline: Operator Add Address as Milkrun (<hiptest-uid>)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive                     | <isShipperActive>              |
#      | shipperType                         | <shipperType>                  |
#      | ocVersion                           | <ocVersion>                    |
#      | services                            | <services>                     |
#      | trackingType                        | <trackingType>                 |
#      | isAllowCod                          | <isAllowCod>                   |
#      | isAllowCashPickup                   | <isAllowCashPickup>            |
#      | isPrepaid                           | <isPrepaid>                    |
#      | isAllowStagedOrders                 | <isAllowStagedOrders>          |
#      | isMultiParcelShipper                | <isMultiParcelShipper>         |
#      | isDisableDriverAppReschedule        | <isDisableDriverAppReschedule> |
#      | pricingScriptName                   | {pricing-script-name}          |
#      | industryName                        | {industry-name}                |
#      | salesPerson                         | {sales-person}                 |
#      | pickupAddressCount                  | 1                              |
#      | address.1.milkrun.1.days            | 1,2,3                          |
#      | address.1.milkrun.1.startTime       | 9AM                            |
#      | address.1.milkrun.1.endTime         | 10PM                           |
#      | address.1.milkrun.1.noOfReservation | 3                              |
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the new Shipper is created successfully
#    Examples:
#      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
#      | Shipper V4 | uid:3b2c8083-d63c-4de8-8e23-31eea390b624 | true            | Normal      | v4        | NEXTDAY  | Fixed        | false      | true              | true      | false               | false                | false                        |
#
#  Scenario Outline: Operator Set Existing Address as Milkrun (<hiptest-uid>)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | <isShipperActive>              |
#      | shipperType                  | <shipperType>                  |
#      | ocVersion                    | <ocVersion>                    |
#      | services                     | <services>                     |
#      | trackingType                 | <trackingType>                 |
#      | isAllowCod                   | <isAllowCod>                   |
#      | isAllowCashPickup            | <isAllowCashPickup>            |
#      | isPrepaid                    | <isPrepaid>                    |
#      | isAllowStagedOrders          | <isAllowStagedOrders>          |
#      | isMultiParcelShipper         | <isMultiParcelShipper>         |
#      | isDisableDriverAppReschedule | <isDisableDriverAppReschedule> |
#      | pricingScriptName            | {pricing-script-name}          |
#      | industryName                 | {industry-name}                |
#      | salesPerson                  | {sales-person}                 |
#      | pickupAddressCount           | 1                              |
#    When Operator set pickup addresses of the created shipper using data below:
#      | address.1.milkrun.1.days            | 1,2,3 |
#      | address.1.milkrun.1.startTime       | 9AM   |
#      | address.1.milkrun.1.endTime         | 10PM  |
#      | address.1.milkrun.1.noOfReservation | 3     |
#    Then Operator verify the new Shipper is updated successfully
#    Examples:
#      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
#      | Shipper V4 | uid:d044ca8e-49f2-4d34-a942-2b596ab20323 | true            | Normal      | v4        | NEXTDAY  | Fixed        | false      | true              | true      | false               | false                | false                        |
#
#  Scenario Outline: Operator Unset a Milkrun in an Address (<hiptest-uid>)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive                     | <isShipperActive>              |
#      | shipperType                         | <shipperType>                  |
#      | ocVersion                           | <ocVersion>                    |
#      | services                            | <services>                     |
#      | trackingType                        | <trackingType>                 |
#      | isAllowCod                          | <isAllowCod>                   |
#      | isAllowCashPickup                   | <isAllowCashPickup>            |
#      | isPrepaid                           | <isPrepaid>                    |
#      | isAllowStagedOrders                 | <isAllowStagedOrders>          |
#      | isMultiParcelShipper                | <isMultiParcelShipper>         |
#      | isDisableDriverAppReschedule        | <isDisableDriverAppReschedule> |
#      | pricingScriptName                   | {pricing-script-name}          |
#      | industryName                        | {industry-name}                |
#      | salesPerson                         | {sales-person}                 |
#      | pickupAddressCount                  | 1                              |
#      | address.1.milkrun.reservationCount  | 2                              |
#      | address.1.milkrun.1.days            | 1,2,3                          |
#      | address.1.milkrun.1.startTime       | 9AM                            |
#      | address.1.milkrun.1.endTime         | 10PM                           |
#      | address.1.milkrun.1.noOfReservation | 3                              |
#      | address.1.milkrun.2.days            | 4,5,6                          |
#      | address.1.milkrun.2.startTime       | 12PM                           |
#      | address.1.milkrun.2.endTime         | 3PM                            |
#      | address.1.milkrun.2.noOfReservation | 2                              |
#    When Operator clear browser cache and reload All Shipper page
#    And Operator unset milkrun reservation "1" form pickup address "1" for created shipper
#    Then Operator verify the new Shipper is created successfully
#    Examples:
#      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
#      | Shipper V4 | uid:377873fb-8842-48c9-98a5-c84a6fe1d3b1 | true            | Normal      | v4        | NEXTDAY  | Fixed        | false      | true              | true      | false               | false                | false                        |
#
#  Scenario Outline: Operator Unset all Milkrun in an Address (<hiptest-uid>)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive                     | <isShipperActive>              |
#      | shipperType                         | <shipperType>                  |
#      | ocVersion                           | <ocVersion>                    |
#      | services                            | <services>                     |
#      | trackingType                        | <trackingType>                 |
#      | isAllowCod                          | <isAllowCod>                   |
#      | isAllowCashPickup                   | <isAllowCashPickup>            |
#      | isPrepaid                           | <isPrepaid>                    |
#      | isAllowStagedOrders                 | <isAllowStagedOrders>          |
#      | isMultiParcelShipper                | <isMultiParcelShipper>         |
#      | isDisableDriverAppReschedule        | <isDisableDriverAppReschedule> |
#      | pricingScriptName                   | {pricing-script-name}          |
#      | industryName                        | {industry-name}                |
#      | salesPerson                         | {sales-person}                 |
#      | pickupAddressCount                  | 1                              |
#      | address.1.milkrun.1.days            | 1,2,3                          |
#      | address.1.milkrun.1.startTime       | 9AM                            |
#      | address.1.milkrun.1.endTime         | 10PM                           |
#      | address.1.milkrun.1.noOfReservation | 3                              |
#    Then Operator clear browser cache and reload All Shipper page
#    And Operator unset all milkrun reservations form pickup address "1" for created shipper
#    Then Operator verify the new Shipper is created successfully
#    Examples:
#      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
#      | Shipper V4 | uid:dba8d6dc-54ca-4d03-bd94-ec37e3457744 | true            | Normal      | v4        | NEXTDAY  | Fixed        | false      | true              | true      | false               | false                | false                        |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
