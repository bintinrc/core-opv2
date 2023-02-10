@OperatorV2 @Core @InterServicesFlows @ParcelSweeperLive
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Operator Parcel Sweep Scans a Routed Parcel
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_DESTINATION_HUB_ID}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {KEY_DESTINATION_HUB_ID}                   |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name        | PARCEL ROUTING SCAN                     |
      | hubName     | {KEY_CREATED_ORDER.destinationHub}      |
      | description | Scanned at Hub {KEY_DESTINATION_HUB_ID} |
    And Operator verify order event on Edit order page using data below:
      | name        | OUTBOUND SCAN                           |
      | hubName     | {KEY_CREATED_ORDER.destinationHub}      |
      | description | Scanned at Hub {KEY_DESTINATION_HUB_ID} |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | hubId      | {KEY_DESTINATION_HUB_ID}        |
    And DB Operator verifies orders record using data below:
      | latestWarehouseSweepId | {KEY_WAREHOUSE_SWEEPS_ID} |
    And DB Operator verify outbound_scans record:
      | orderId | {KEY_CREATED_ORDER_ID}   |
      | hubId   | {KEY_DESTINATION_HUB_ID} |
      | routeId | {KEY_CREATED_ROUTE_ID}   |

  @ForceSuccessOrder
  Scenario: Operator Parcel Sweep Scans an Unrouted Parcel
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator verify order info using data below:
      | id             | {KEY_CREATED_ORDER_ID} |
      | status         | TRANSIT                |
      | granularStatus | ARRIVED_AT_SORTING_HUB |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id}                                   |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name        | PARCEL ROUTING SCAN     |
      | hubName     | {hub-name}              |
      | description | Scanned at Hub {hub-id} |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | hubId      | {hub-id}                        |
    And DB Operator verifies orders record using data below:
      | latestWarehouseSweepId | {KEY_WAREHOUSE_SWEEPS_ID} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
