@OperatorV2 @Core @Analytics @CodReport
Feature: COD Report

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator is Able to Load CODs For A Day and Verify the Created Order is Exist and Contains Correct Info
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get CODs For A Day" and Date = "{gradle-current-date-yyyy-MM-dd}"
    Then Operator verify COD record on COD Report page:
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | granularStatus | Pending Pickup                        |
      | shipperName    | {shipper-v4-name}                     |
      | codAmount      | 23.57                                 |
      | collectedAt    | Delivery                              |
      | shippingAmount | 0.00                                  |
      | collectedSum   | 0.00                                  |
      | collected      | 0.00                                  |

  @DeleteOrArchiveRoute
  Scenario: Operator is Able to Load Driver CODs For A Route Day and Verify the Created Order is Exist and Contains Correct Info
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-0-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-0-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator go to menu Analytics -> COD Report
    And Operator filter COD Report by Mode = "Get Driver CODs For A Route Day" and Date = "{gradle-next-1-day-yyyy-MM-dd}"
    Then Operator verify COD record on COD Report page:
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | granularStatus | Arrived at Sorting Hub                |
      | shipperName    | {shipper-v4-name}                     |
      | codAmount      | 23.57                                 |
      | collectedAt    | Delivery                              |
      | shippingAmount | 0.00                                  |
      | collectedSum   | 0.00                                  |
      | collected      | 0.00                                  |

  Scenario: Operator is Able to Download CODs For A Day and Verify the Data is Correct
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get CODs For A Day" and Date = "{gradle-current-date-yyyy-MM-dd}"
    And Operator download COD Report
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verify the downloaded COD Report data is correct
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |


  @DeleteOrArchiveRoute
  Scenario: Operator is Able to Download Driver CODs For A Route Day and Verify the Data is Correct
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-0-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-0-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    Given Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get Driver CODs For A Route Day" and Date = "{gradle-next-1-day-yyyy-MM-dd}"
    And Operator download COD Report
    Then Operator verify the downloaded COD Report data is correct
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
