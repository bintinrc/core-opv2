@OperatorV2 @Shipper @OperatorV2Part2 @AllShippers @Saas
Feature: All Shippers

  @LaunchBrowser @ShouldAlwaysRun @EnableClearCache @ForceNotHeadless
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
      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
      | Shipper V4 | uid:dfbe7350-2c9d-40d3-96c4-428f5842a511 | true            | Normal      | v4        | STANDARD | Fixed        | false      | true              | true      | false               | false                | false                        |

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
      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services | trackingType | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
      | Shipper V4 | uid:7fc77afb-999d-4257-b20e-e1540aebf820 | true            | Normal      | v4        | STANDARD | Fixed        | false      | true              | true      | false               | false                | false                        |

  @ResetWindow
  Scenario: Operator create new Shipper with basic settings and then update the Label Printer settings (uid:5f4793bb-04d8-496d-9e92-aeb863a0149d)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    When Operator update Shipper's Label Printer settings
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify Shipper's Label Printer settings is updated successfully
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the shipper is deleted successfully

  @ResetWindow
  Scenario: Operator create new Shipper with basic settings and then update the Returns settings (uid:3390ffc7-f6b1-4cce-af8d-787bae1d2fac)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    When Operator update Shipper's Returns settings
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify Shipper's Returns settings is updated successfully
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the shipper is deleted successfully

  @ResetWindow
  Scenario: Operator create new Shipper with basic settings and then update the Distribution Point settings (uid:d13bf02a-cae8-43be-939f-1380aee1acfb)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    When Operator update Shipper's Distribution Point settings
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify Shipper's Distribution Point settings is updated successfully
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the shipper is deleted successfully

  @ResetWindow
  Scenario: Operator create new Shipper with basic settings and then update the Qoo10 settings (uid:45827cde-6d96-4fbc-b04d-b759ae670722)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    When Operator update Shipper's Qoo10 settings
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify Shipper's Qoo10 settings is updated successfully
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the shipper is deleted successfully

  @ResetWindow
  Scenario: Operator create new Shipper with basic settings and then update the Shopify settings (uid:d20c7d44-cd01-44a4-8e19-07e86465168d)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    When Operator update Shipper's Shopify settings
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify Shipper's Shopify settings is updated successfully
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the shipper is deleted successfully

  @ResetWindow
  Scenario: Operator create new Shipper with basic settings and then update the Magento settings (uid:a32a3f0f-c48b-4c46-8739-40c4b9ff80ad)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully
    When Operator update Shipper's Magento settings
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify Shipper's Magento settings is updated successfully
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    When Operator clear browser cache and reload All Shipper page
    Then Operator verify the shipper is deleted successfully

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

  Scenario: Search Shipper By Filters - Filter shipper by liaison email (uid:c707e715-e501-4e21-92c1-325e6311107d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Liaison Email" filter
    Then Operator searches the "Liaison Email" field with "Ninja" keyword
    Then Operator verifies that the results have keyword "Ninja" in "Liaison Email" column

  Scenario: Search Shipper By Filters - Filter shipper by email (uid:7fdb0918-445b-468e-a073-2176a41380b8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Email" filter
    Then Operator searches the "Email" field with "Ninja" keyword
    Then Operator verifies that the results have keyword "Ninja" in "Email" column

  Scenario: Search Shipper By Filters - Filter shipper by contact (uid:290eaaf7-1de5-4fa3-ac83-10cd7ef14017)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Contact" filter
    Then Operator searches the "Contact" field with "12345" keyword
    Then Operator verifies that the results have keyword "12345" in "Contact" column

  Scenario: Search Shipper By Filters - Filter shipper by active (uid:3759c2f5-aae6-4750-99d4-8ce7891cdcde)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Active" filter
    Then Operator searches for Shippers with Active filter
    Then Operator verifies that the results have keyword "Active" in "Status" column

  Scenario: Search Shipper By Filters - Filter shipper by shipper (uid:d9277915-be40-416e-a261-56d922de63c2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Shipper" filter
    Then Operator searches the "Shipper" field with "Ninja" keyword
    Then Operator verifies that the results have keyword "Ninja" in "Name" column

  Scenario: Search Shipper By Filters - Filter shipper by Industry (uid:cf411a95-3671-41a8-aa7c-66bee60d6fd9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Industry" filter
    Then Operator searches the "Industry" field with "Fashion" keyword
    Then Operator verifies that the results have keyword "Fashion" in "Industry" column

  Scenario: Search Shipper By Filters - Filter shipper by Salesperson (uid:45ed77f2-8966-4418-ac10-adb43511733f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator chooses "Salesperson" filter
    Then Operator searches the "Salesperson" field with "TS1" keyword
    Then Operator verifies that the results have keyword "TS1" in "Salesperson" column

  Scenario: Search Shipper By Filters - Search shipper by quick search (uid:27555f18-3308-4b5a-b33b-2b1394c355c9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator clears all filters on All Shippers page
    And Operator searches for keyword "Ninja" in quick search filter
    Then Operator verifies that the results have keyword "Ninja" in "Name" column

  @PricingProfile
  Scenario: Add New Shipper Pricing Profile (uid:e3bae772-87e8-4fbc-9698-c590871b4cdd)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20                            |
      | comments          | This is a test pricing script |
    When DB Operator soft delete shipper by Legacy ID
    Then Operator verify the shipper is deleted successfully

  @PricingProfile
  Scenario: Edit Shipper Pricing Profile (uid:bbe028d2-f43d-4de1-a394-f53b68344aa5)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20                            |
      | comments          | This is a test pricing script |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits the created shipper
    Then Operator edits the Pending Pricing Script
      | discount | 30                         |
      | comments | Edited test pricing script |
    When DB Operator soft delete shipper by Legacy ID
    Then Operator verify the shipper is deleted successfully

  @PricingProfile
  Scenario: Create a new Shipper - Pricing & Billing tab (uid:d86f2bd2-94ee-406c-b80e-224f54e00e0a)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator verifies that Pricing Script is "Active" and ""
    When DB Operator soft delete shipper by Legacy ID
    Then Operator verify the shipper is deleted successfully

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Shipper - Pricing & Billing tab - Update the Pricing Profile before Created (uid:74107efb-4c18-4468-9c0c-cf4f12f3d5fb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings and updates pricing script using data below:
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
    Then Operator verifies that Pricing Script is "Active" and ""

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Shipper - Pricing & Billing tab - No Pricing Profile (uid:1d0199fc-6fb9-4d54-a32d-65b701799c7f)
    Given Operator go to menu Shipper Support -> Blocked Dates
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

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with Flat Discount where Shipper has Active & Expired Pricing Profile (uid:72efc910-af1b-4145-bdd9-e486deb4284e)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script |
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Active" and "Expired"
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20.00                         |
      | comments          | This is a test pricing script |
      | type              | FLAT                          |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script and shipper discount details
    And Operator verifies the pricing script and shipper discount details are correct

  @PricingProfile @DeleteShipper @CloseNewWindows @ResetCountry
  Scenario: Create a new Pricing Profile - with Percentage Discount where Shipper has Active & Expired Pricing Profile (uid:ad094f98-7e6f-4cf2-978e-b56b742695d7)
    Given Operator changes the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                     |
      | shipperType                  | Normal                   |
      | ocVersion                    | v4                       |
      | services                     | STANDARD                 |
      | trackingType                 | Fixed                    |
      | isAllowCod                   | true                     |
      | isAllowCashPickup            | true                     |
      | isPrepaid                    | true                     |
      | isAllowStagedOrders          | true                     |
      | isMultiParcelShipper         | true                     |
      | isDisableDriverAppReschedule | true                     |
      | pricingScriptName            | {pricing-script-name-id} |
      | industryName                 | {industry-name}          |
      | salesPerson                  | {sales-person-id}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2508 - PT Cucumber Test 2 |
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Active" and "Expired"
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2508 - PT Cucumber Test 2     |
      | discount          | 20.00                         |
      | comments          | This is a test pricing script |
      | type              | PERCENTAGE                    |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script and shipper discount details
    And Operator verifies the pricing script and shipper discount details are correct

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - where Shipper has Pending Pricing Profile (uid:dc2a9af8-d447-4eba-a6eb-3882d57aaeed)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20                            |
      | comments          | This is a test pricing script |
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Pending" and ""
    And Operator edits the created shipper
    And Operator verifies that Edit Pending Profile is displayed

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with 0 Flat Discount (uid:c6f6e5b0-d8c6-4489-83fe-b7ae021de5f7)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | pricingScriptName | 2402 - New Script               |
      | discount          | 0                               |
      | errorMessage      | 0 is not a valid discount value |

  @PricingProfile @DeleteShipper @CloseNewWindows @ResetCountry
  Scenario: Create a new Pricing Profile - with 0 Percentage Discount (uid:81e2a66e-cc26-4a3a-ac56-1ea5b86f3614)
    Given Operator changes the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                     |
      | shipperType                  | Normal                   |
      | ocVersion                    | v4                       |
      | services                     | STANDARD                 |
      | trackingType                 | Fixed                    |
      | isAllowCod                   | true                     |
      | isAllowCashPickup            | true                     |
      | isPrepaid                    | true                     |
      | isAllowStagedOrders          | true                     |
      | isMultiParcelShipper         | true                     |
      | isDisableDriverAppReschedule | true                     |
      | pricingScriptName            | {pricing-script-name-id} |
      | industryName                 | {industry-name}          |
      | salesPerson                  | {sales-person-id}        |
    And Operator edits the created shipper
    Then Operator adds pricing script with invalid discount and verifies the error message
      | pricingScriptName | 2508 - PT Cucumber Test 2       |
      | discount          | 0                               |
      | errorMessage      | 0 is not a valid discount value |

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with none Flat Discount (uid:d4cf96cf-e1b2-421f-b5de-125d4af1b31f)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | comments          | This is a test pricing script |
      | type              | FLAT                          |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script details
    And Operator verifies the pricing script details are correct
    When DB Operator soft delete shipper by Legacy ID
    Then Operator verify the shipper is deleted successfully

  @PricingProfile @DeleteShipper @CloseNewWindows @ResetCountry
  Scenario: Create a new Pricing Profile - with none Percentage Discount (uid:d948145c-704d-4a76-b6c5-fb18f9f1a853)
    Given Operator changes the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                     |
      | shipperType                  | Normal                   |
      | ocVersion                    | v4                       |
      | services                     | STANDARD                 |
      | trackingType                 | Fixed                    |
      | isAllowCod                   | true                     |
      | isAllowCashPickup            | true                     |
      | isPrepaid                    | true                     |
      | isAllowStagedOrders          | true                     |
      | isMultiParcelShipper         | true                     |
      | isDisableDriverAppReschedule | true                     |
      | pricingScriptName            | {pricing-script-name-id} |
      | industryName                 | {industry-name}          |
      | salesPerson                  | {sales-person-id}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2508 - PT Cucumber Test 2     |
      | comments          | This is a test pricing script |
      | type              | PERCENTAGE                    |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script details
    And Operator verifies the pricing script details are correct

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with special characters Discount (uid:4df9abce-e97a-4bf8-aef1-41a96c63ed76)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | pricingScriptName | 2402 - New Script                |
      | discount          | $#^$^#@                          |
      | errorMessage      | Special character is not allowed |

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with 3-5 integer after decimal point (uid:f3af5079-e704-4f9a-83d3-e4b79a463474)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20.54321                      |
      | comments          | This is a test pricing script |
      | type              | FLAT                          |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script and shipper discount details
    And Operator verifies the pricing script and shipper discount details are correct

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with shipper discount within 6 digits Flat Discount (uid:6b852274-7091-4f2f-8a3a-6fecda231d27)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 50000.00                      |
      | comments          | This is a test pricing script |
      | type              | FLAT                          |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script and shipper discount details
    And Operator verifies the pricing script and shipper discount details are correct

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with shipper discount over 6 digits Flat Discount (uid:4e129004-7985-4226-a5eb-ebfa2465efe7)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator adds pricing script with discount over 6 digits and verifies the error message
      | pricingScriptName | 2402 - New Script           |
      | discount          | 10000000                    |
      | comments          | This is an invalid discount |
      | errorMessage      | Failed to update            |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op