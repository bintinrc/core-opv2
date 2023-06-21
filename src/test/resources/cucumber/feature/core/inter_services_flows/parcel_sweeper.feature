@OperatorV2 @Core @InterServicesFlows @ParcelSweeperLive
Feature: Parcel Sweeper Live

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Operator Parcel Sweep Scans a Routed Parcel
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And DB Sort - get hub by hub name "{KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And Operator waits for 10 seconds
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                            |
      | hubId              | {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}                                                              |
      | taskId             | 1                                                                                                |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name        | PARCEL ROUTING SCAN                                |
      | hubName     | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}     |
      | description | Scanned at Hub {KEY_SORT_LIST_OF_HUBS_DB[1].hubId} |
    And Operator refresh page
    And Operator verify order event on Edit order page using data below:
      | name        | OUTBOUND SCAN                                      |
      | hubName     | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}     |
      | description | Scanned at Hub {KEY_SORT_LIST_OF_HUBS_DB[1].hubId} |
    And DB Core - verify warehouse_sweeps record:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId      | {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}   |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}    |
    And DB Core - verify orders record:
      | id                     | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | latestWarehouseSweepId | {KEY_CORE_WAREHOUSE_SWEEPS[1].id}  |
    And DB Core - verify outbound_scans record:
      | hubId   | {KEY_SORT_LIST_OF_HUBS_DB[1].hubId} |
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id}  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}  |

  @ForceSuccessOrder
  Scenario: Operator Parcel Sweep Scans an Unrouted Parcel
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And DB Sort - get hub by hub name "{KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}"
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}, "scan": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                            |
      | hubId              | {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}                                                              |
      | taskId             | 1                                                                                                |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator refresh page
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name        | PARCEL ROUTING SCAN                                |
      | hubName     | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub}     |
      | description | Scanned at Hub {KEY_SORT_LIST_OF_HUBS_DB[1].hubId} |
    And DB Core - verify warehouse_sweeps record:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId      | {KEY_SORT_LIST_OF_HUBS_DB[1].hubId}   |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}    |
    And DB Core - verify orders record:
      | id                     | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | latestWarehouseSweepId | {KEY_CORE_WAREHOUSE_SWEEPS[1].id}  |
