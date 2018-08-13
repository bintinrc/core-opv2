@OperatorV2Disabled @OperatorV2Part2Disabled @AllShippers @Saas
Feature: All Shippers

  @LaunchBrowser @EnableClearCache @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ResetWindow
  Scenario Outline: Operator create new Shipper with basic settings (<hiptest-uid>)
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
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the shipper is deleted successfully
    Examples:
      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services                           | trackingType  | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
#      | Shipper V2 | uid:d898b80d-2b26-487a-af42-a4583b5bdebc | true            | Normal      | v2        | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT | LegacyDynamic | true       | true              | false     | true                | true                 | false                        |
#      | Shipper V3 | uid:1b9953fd-60e8-4599-a5c2-b66d6fb37fcd | true            | Normal      | v3        | 1DAY, 2DAY, 3DAY                   | Fixed         | true       | false             | false     | false               | false                | true                         |
      | Shipper V4 | uid:dfbe7350-2c9d-40d3-96c4-428f5842a511 | true            | Normal      | v4        | 3DAY                               | Fixed         | false      | true              | true      | false               | false                | false                        |

  @ResetWindow
  Scenario Outline: Operator create new Shipper with basic settings and then update the basic settings (<hiptest-uid>)
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
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    When Operator update Shipper's basic settings
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify Shipper's basic settings is updated successfully
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the shipper is deleted successfully
    Examples:
      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services                           | trackingType  | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
#      | Shipper V2 | uid:1312b967-27af-4454-908b-02021571d350 | true            | Normal      | v2        | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT | LegacyDynamic | true       | true              | false     | true                | true                 | false                        |
#      | Shipper V3 | uid:fd5a8ad9-48ed-4d95-a6d9-c36daad021f1 | true            | Normal      | v3        | 1DAY, 2DAY, 3DAY                   | Fixed         | true       | false             | false     | false               | false                | true                         |
      | Shipper V4 | uid:7fc77afb-999d-4257-b20e-e1540aebf820 | true            | Normal      | v4        | 3DAY                               | Fixed         | false      | true              | true      | false               | false                | false                        |

#  @ResetWindow
#  Scenario: Operator create new Shipper with basic settings and then update the Label Printer settings (uid:5f4793bb-04d8-496d-9e92-aeb863a0149d)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                               |
#      | shipperType                  | Normal                             |
#      | ocVersion                    | v2                                 |
#      | services                     | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT |
#      | trackingType                 | LegacyDynamic                      |
#      | isAllowCod                   | true                               |
#      | isAllowCashPickup            | true                               |
#      | isPrepaid                    | true                               |
#      | isAllowStagedOrders          | true                               |
#      | isMultiParcelShipper         | true                               |
#      | isDisableDriverAppReschedule | true                               |
#      | pricingScriptName            | {pricing-script-name}              |
#      | industryName                 | {industry-name}                    |
#      | salesPerson                  | {sales-person}                     |
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the new Shipper is created successfully
#    When Operator update Shipper's Label Printer settings
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify Shipper's Label Printer settings is updated successfully
#    When DB Operator soft delete shipper by Legacy ID
#    When API Operator reload shipper's cache
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the shipper is deleted successfully

#  @ResetWindow
#  Scenario: Operator create new Shipper with basic settings and then update the Returns settings (uid:3390ffc7-f6b1-4cce-af8d-787bae1d2fac)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                               |
#      | shipperType                  | Normal                             |
#      | ocVersion                    | v2                                 |
#      | services                     | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT |
#      | trackingType                 | LegacyDynamic                      |
#      | isAllowCod                   | true                               |
#      | isAllowCashPickup            | true                               |
#      | isPrepaid                    | true                               |
#      | isAllowStagedOrders          | true                               |
#      | isMultiParcelShipper         | true                               |
#      | isDisableDriverAppReschedule | true                               |
#      | pricingScriptName            | {pricing-script-name}              |
#      | industryName                 | {industry-name}                    |
#      | salesPerson                  | {sales-person}                     |
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the new Shipper is created successfully
#    When Operator update Shipper's Returns settings
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify Shipper's Returns settings is updated successfully
#    When DB Operator soft delete shipper by Legacy ID
#    When API Operator reload shipper's cache
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the shipper is deleted successfully

#  @ResetWindow
#  Scenario: Operator create new Shipper with basic settings and then update the Distribution Point settings (uid:d13bf02a-cae8-43be-939f-1380aee1acfb)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                               |
#      | shipperType                  | Normal                             |
#      | ocVersion                    | v2                                 |
#      | services                     | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT |
#      | trackingType                 | LegacyDynamic                      |
#      | isAllowCod                   | true                               |
#      | isAllowCashPickup            | true                               |
#      | isPrepaid                    | true                               |
#      | isAllowStagedOrders          | true                               |
#      | isMultiParcelShipper         | true                               |
#      | isDisableDriverAppReschedule | true                               |
#      | pricingScriptName            | {pricing-script-name}              |
#      | industryName                 | {industry-name}                    |
#      | salesPerson                  | {sales-person}                     |
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the new Shipper is created successfully
#    When Operator update Shipper's Distribution Point settings
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify Shipper's Distribution Point settings is updated successfully
#    When DB Operator soft delete shipper by Legacy ID
#    When API Operator reload shipper's cache
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the shipper is deleted successfully

#  @ResetWindow
#  Scenario: Operator create new Shipper with basic settings and then update the Qoo10 settings (uid:45827cde-6d96-4fbc-b04d-b759ae670722)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                               |
#      | shipperType                  | Normal                             |
#      | ocVersion                    | v2                                 |
#      | services                     | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT |
#      | trackingType                 | LegacyDynamic                      |
#      | isAllowCod                   | true                               |
#      | isAllowCashPickup            | true                               |
#      | isPrepaid                    | true                               |
#      | isAllowStagedOrders          | true                               |
#      | isMultiParcelShipper         | true                               |
#      | isDisableDriverAppReschedule | true                               |
#      | pricingScriptName            | {pricing-script-name}              |
#      | industryName                 | {industry-name}                    |
#      | salesPerson                  | {sales-person}                     |
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the new Shipper is created successfully
#    When Operator update Shipper's Qoo10 settings
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify Shipper's Qoo10 settings is updated successfully
#    When DB Operator soft delete shipper by Legacy ID
#    When API Operator reload shipper's cache
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the shipper is deleted successfully

#  @ResetWindow
#  Scenario: Operator create new Shipper with basic settings and then update the Shopify settings (uid:d20c7d44-cd01-44a4-8e19-07e86465168d)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                               |
#      | shipperType                  | Normal                             |
#      | ocVersion                    | v2                                 |
#      | services                     | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT |
#      | trackingType                 | LegacyDynamic                      |
#      | isAllowCod                   | true                               |
#      | isAllowCashPickup            | true                               |
#      | isPrepaid                    | true                               |
#      | isAllowStagedOrders          | true                               |
#      | isMultiParcelShipper         | true                               |
#      | isDisableDriverAppReschedule | true                               |
#      | pricingScriptName            | {pricing-script-name}              |
#      | industryName                 | {industry-name}                    |
#      | salesPerson                  | {sales-person}                     |
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the new Shipper is created successfully
#    When Operator update Shipper's Shopify settings
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify Shipper's Shopify settings is updated successfully
#    When DB Operator soft delete shipper by Legacy ID
#    When API Operator reload shipper's cache
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the shipper is deleted successfully

#  @ResetWindow
#  Scenario: Operator create new Shipper with basic settings and then update the Magento settings (uid:a32a3f0f-c48b-4c46-8739-40c4b9ff80ad)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                               |
#      | shipperType                  | Normal                             |
#      | ocVersion                    | v2                                 |
#      | services                     | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT |
#      | trackingType                 | LegacyDynamic                      |
#      | isAllowCod                   | true                               |
#      | isAllowCashPickup            | true                               |
#      | isPrepaid                    | true                               |
#      | isAllowStagedOrders          | true                               |
#      | isMultiParcelShipper         | true                               |
#      | isDisableDriverAppReschedule | true                               |
#      | pricingScriptName            | {pricing-script-name}              |
#      | industryName                 | {industry-name}                    |
#      | salesPerson                  | {sales-person}                     |
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the new Shipper is created successfully
#    When Operator update Shipper's Magento settings
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify Shipper's Magento settings is updated successfully
#    When DB Operator soft delete shipper by Legacy ID
#    When API Operator reload shipper's cache
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the shipper is deleted successfully

#  @ResetWindow
#  Scenario: Operator enable Auto Reservation for Shipper, create order V2 and verify the reservation is created (uid:93ec816b-e633-4248-8660-ee2a21cd8040)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                               |
#      | shipperType                  | Normal                             |
#      | ocVersion                    | v2                                 |
#      | services                     | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT |
#      | trackingType                 | LegacyDynamic                      |
#      | isAllowCod                   | true                               |
#      | isAllowCashPickup            | true                               |
#      | isPrepaid                    | true                               |
#      | isAllowStagedOrders          | true                               |
#      | isMultiParcelShipper         | true                               |
#      | isDisableDriverAppReschedule | true                               |
#      | pricingScriptName            | {pricing-script-name}              |
#      | industryName                 | {industry-name}                    |
#      | salesPerson                  | {sales-person}                     |
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the new Shipper is created successfully
#    When Operator enable Auto Reservation for Shipper and change Shipper default Address to the new Address using data below:
#      | reservationDays             | 1, 2, 3, 4, 5, 6, 7 |
#      | autoReservationReadyTime    | 21:00:00            |
#      | autoReservationLatestTime   | 21:00:00            |
#      | autoReservationCutoffTime   | 21:00:00            |
#      | autoReservationApproxVolume | Less than 3 Parcels |
#      | allowedTypes                | REGULAR             |
#    Given Operator go to menu Order -> Order Creation V2
#    When Operator create order V2 by uploading CSV on Order Creation V2 page using data below:
#      | orderCreationV2Template | { "shipper_id":{{shipper_id}}, "order_type":"Normal", "parcel_size":1, "weight":2, "length":3, "width":5, "height":7, "delivery_date":"{{cur_date}}", "delivery_timewindow_id":1, "max_delivery_days":3, "pickup_date":"{{cur_date}}", "pickup_timewindow_id":1 } |
#    Then Operator verify order V2 is created successfully on Order Creation V2 page
#    Given Operator go to menu Pick Ups -> Shipper Pickups
#    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
#    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
#      | shipperName | GET_FROM_CREATED_SHIPPER   |
#      | comments    | Generated by order create. |
#    Given Operator go to menu Shipper -> All Shippers
#    When DB Operator soft delete shipper by Legacy ID
#    When API Operator reload shipper's cache
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the shipper is deleted successfully

#  @ResetWindow
#  Scenario: Operator enable Auto Reservation for Shipper, create order V3 and verify the reservation is created (uid:98f402db-42a2-42cd-b575-c8498d6c7e5a)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper -> All Shippers
#    When Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                               |
#      | shipperType                  | Normal                             |
#      | ocVersion                    | v3                                 |
#      | services                     | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT |
#      | trackingType                 | Fixed                              |
#      | isAllowCod                   | true                               |
#      | isAllowCashPickup            | true                               |
#      | isPrepaid                    | true                               |
#      | isAllowStagedOrders          | true                               |
#      | isMultiParcelShipper         | true                               |
#      | isDisableDriverAppReschedule | true                               |
#      | pricingScriptName            | {pricing-script-name}              |
#      | industryName                 | {industry-name}                    |
#      | salesPerson                  | {sales-person}                     |
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the new Shipper is created successfully
#    When Operator enable Auto Reservation for Shipper and change Shipper default Address to the new Address using data below:
#      | reservationDays             | 1, 2, 3, 4, 5, 6, 7 |
#      | autoReservationReadyTime    | 21:00:00            |
#      | autoReservationLatestTime   | 21:00:00            |
#      | autoReservationCutoffTime   | 21:00:00            |
#      | autoReservationApproxVolume | Less than 3 Parcels |
#      | allowedTypes                | REGULAR             |
#    Given Operator go to menu Order -> Order Creation V2
#    When Operator create order V3 by uploading CSV on Order Creation V2 page using data below:
#      | orderCreationV2Template | { "shipper_id":{{shipper_id}}, "order_type":"Normal", "parcel_size":1, "weight":2, "length":3, "width":5, "height":7, "delivery_date":"{{cur_date}}", "delivery_timewindow_id":1, "max_delivery_days":3, "pickup_date":"{{cur_date}}", "pickup_timewindow_id":1 } |
#    Then Operator verify order V3 is created successfully on Order Creation V2 page
#    Given Operator go to menu Pick Ups -> Shipper Pickups
#    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
#    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
#      | shipperName | GET_FROM_CREATED_SHIPPER   |
#      | comments    | Generated by order create. |
#    Given Operator go to menu Shipper -> All Shippers
#    When DB Operator soft delete shipper by Legacy ID
#    When API Operator reload shipper's cache
#    When Operator clear browser cache and reload All Shipper page
#    Then Operator verify the shipper is deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
