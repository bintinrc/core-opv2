@OperatorV2 @Core @AllOrders
Feature: Download AWB

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipper
  Scenario Outline: Operator Print Waybill to Show Details Based on Shipper Settings - Show Shipper Details - <Note>
    Given Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive                  | true                  |
      | shipperType                      | Normal                |
      | ocVersion                        | v4                    |
      | services                         | STANDARD              |
      | trackingType                     | Fixed                 |
      | isAllowCod                       | false                 |
      | isAllowCashPickup                | true                  |
      | isPrepaid                        | true                  |
      | isAllowStagedOrders              | false                 |
      | isMultiParcelShipper             | false                 |
      | isDisableDriverAppReschedule     | false                 |
      | pricingScriptName                | {pricing-script-name} |
      | industryName                     | {industry-name}       |
      | salesPerson                      | {sales-person}        |
      | labelPrinting.showShipperDetails | true                  |
    And API Operator evict shipper's cache
    And API Operator fetch id of the created shipper
    Given API Shipper create V4 order for shipper legacy id "{KEY_CREATED_SHIPPER.legacyId}" using internal order create endpoint with data below:
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator print Waybill for single order on All Orders page
    Then Operator verify waybill for single order on All Orders page:
      | trackingId  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                      |
      | fromName    | {KEY_CREATED_ORDER.fromName}                               |
      | fromContact | {KEY_CREATED_ORDER.fromContact}                            |
      | fromAddress | {KEY_CREATED_ORDER.buildShortFromAddressWithCountryString} |
      | toName      | {KEY_CREATED_ORDER.toName}                                 |
      | toContact   | {KEY_CREATED_ORDER.toContact}                              |
      | toAddress   | {KEY_CREATED_ORDER.buildShortToAddressWithCountryString}   |
    Examples:
      | Note   | v4OrderRequest                                                                                                                                                                                                                                                                                                                  |
      | Normal | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
      | Return | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |

  @DeleteShipper
  Scenario Outline: Operator Print Waybill to Show Details Based on Shipper Settings - Hide Shipper Details - <Note>
    Given Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive                  | true                  |
      | shipperType                      | Normal                |
      | ocVersion                        | v4                    |
      | services                         | STANDARD              |
      | trackingType                     | Fixed                 |
      | isAllowCod                       | false                 |
      | isAllowCashPickup                | true                  |
      | isPrepaid                        | true                  |
      | isAllowStagedOrders              | false                 |
      | isMultiParcelShipper             | false                 |
      | isDisableDriverAppReschedule     | false                 |
      | pricingScriptName                | {pricing-script-name} |
      | industryName                     | {industry-name}       |
      | salesPerson                      | {sales-person}        |
      | labelPrinting.showShipperDetails | false                 |
    And API Operator evict shipper's cache
    And API Operator fetch id of the created shipper
    Given API Shipper create V4 order for shipper legacy id "{KEY_CREATED_SHIPPER.legacyId}" using internal order create endpoint with data below:
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator print Waybill for single order on All Orders page
    Then Operator verify waybill for single order on All Orders page:
      | trackingId  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                    |
      | fromName    | {KEY_CREATED_ORDER.fromName}                             |
      | fromContact | null                                                     |
      | fromAddress | null                                                     |
      | toName      | {KEY_CREATED_ORDER.toName}                               |
      | toContact   | {KEY_CREATED_ORDER.toContact}                            |
      | toAddress   | {KEY_CREATED_ORDER.buildShortToAddressWithCountryString} |
    Examples:
      | Note   | v4OrderRequest                                                                                                                                                                                                                                                                                                                  |
      | Normal | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
      | Return | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op