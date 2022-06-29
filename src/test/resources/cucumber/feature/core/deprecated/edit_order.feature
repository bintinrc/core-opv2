@Deprecated
Feature: Edit Order

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Update Order Status from Transit/Arrived at Sorting Hub to Pending/Pending on Edit Order Page (uid:b3a052cf-9dbf-4cff-b4ec-8d944516cc2e)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update status of the created order on Edit order page using data below:
      | status                        | Pending        |
      | granularStatus                | Pending Pickup |
      | lastPickupTransactionStatus   | Pending        |
      | lastDeliveryTransactionStatus | Pending        |
    Then Operator verify the created order info is correct on Edit Order page

  Scenario: Operator Update Order Status from Pending/Pending to Cancelled/Cancelled on Edit Order Page (uid:3e788d22-fce5-4cf3-b22d-3985db12cfd3)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update status of the created order on Edit order page using data below:
      | status                        | Cancelled |
      | granularStatus                | Cancelled |
      | lastPickupTransactionStatus   | Cancelled |
      | lastDeliveryTransactionStatus | Cancelled |
    Then Operator verify the created order info is correct on Edit Order page
    And Operator verify color of order header on Edit Order page is "RED"

  Scenario: Operator Update Order Status from Pending/Pending to Transit/Arrived at Sorting Hub on Edit Order Page (uid:1f72e16b-afdb-4911-a2d1-4b4c5783f062)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update status of the created order on Edit order page using data below:
      | status                        | Transit                |
      | granularStatus                | Arrived at Sorting Hub |
      | lastPickupTransactionStatus   | Success                |
      | lastDeliveryTransactionStatus | Pending                |
    Then Operator verify the created order info is correct on Edit Order page

  Scenario: Operator Update Order Status from Pending/Pending to Completed/Completed on Edit Order Page (uid:8f40d738-057c-4f14-a301-ed884bd6a91f)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update status of the created order on Edit order page using data below:
      | status                        | Completed |
      | granularStatus                | Completed |
      | lastPickupTransactionStatus   | Success   |
      | lastDeliveryTransactionStatus | Success   |
    Then Operator verify the created order info is correct on Edit Order page
    And Operator verify color of order header on Edit Order page is "GREEN"

  Scenario: Operator Manually Update Order Granular Status - Revert Completed Status (uid:b993a87f-cd51-4db0-b1e4-1198092cdb06)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order without cod
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    When API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Pending Pickup                    |
    And Operator refresh page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify order events on Edit order page using data below:
      | tags          | name             | description                                                                                                                                                                                                                                                                                   |
      | MANUAL ACTION | REVERT COMPLETED |                                                                                                                                                                                                                                                                                               |
      | MANUAL ACTION | UPDATE STATUS    | Old Pickup Status: Success\nNew Pickup Status: Pending\n\nOld Delivery Status: Success\nNew Delivery Status: Pending\n\nOld Granular Status: Completed\nNew Granular Status: Pending Pickup\n\nOld Order Status: Completed\nNew Order Status: Pending\n\nReason: update order granular status |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |

  Scenario Outline: Operator Manually Update Order Granular Status - On Hold (<uuid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order status on Edit order page using data below:
      | granularStatus | <granularStatus>                    |
      | changeReason   | Status updated for testing purposes |
    Then Operator verifies that success toast displayed:
      | top                | Status Updated |
      | waitUntilInvisible | true           |
    And Operator verify order status is "<status>" on Edit Order page
    And Operator verify order granular status is "<granularStatus>" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | <pickupStatus> |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | <deliveryStatus> |
    And Operator verify order events on Edit order page using data below:
      | tags          | name          | description   |
      | MANUAL ACTION | UPDATE STATUS | <description> |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | <pickupWpStatus> |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | <deliveryWpStatus> |
    Examples:
      | granularStatus | status  | pickupStatus | deliveryStatus | pickupWpStatus | deliveryWpStatus | description                                                                                                                                                                                                                        | uuid                                     |
      | On Hold        | On Hold | SUCCESS      | PENDING        | SUCCESS        | PENDING          | Old Pickup Status: Pending\nNew Pickup Status: Success\n\nOld Granular Status: Pending Pickup\nNew Granular Status: On Hold\n\nOld Order Status: Pending\nNew Order Status: On Hold\n\nReason: Status updated for testing purposes | uid:1d68fc5c-e8e0-44da-ac3a-53332510965d |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
