@OperatorV2 @Core @NewFeatures @ThB2B
Feature: TH B2B

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority @ArchiveRouteCommonV2 @test
  Scenario: Upload CSV File Successfully for All B2B Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | En-route to Sorting Hub            |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/th-b2b"
    And Operator click upload csv button in b2b page
    And Operator click Download Sample File button in Upload CSV dialog
    Then Operator verify sample CSV file is downloaded successfully on b2b page
    When Operator upload auto_inbound csv file on b2b page
      | trackingId                            | routeId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Upload button in Upload CSV dialog
    Then Operator verifies that notification is displayed in b2b page:
      | top | Auto inbound processed |
    And Operator verifies results table contains the following details:
      | trackingId                            | routeId                            | status  |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Success |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Success |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Success |
    # verify first order
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | HUB INBOUND SCAN                                                   |
      | hubName     | {hub-name}                                                         |
      | description | ^.*Inbounded at hub {hub-id} from Global Shipper {shipper-v4-id}.* |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | DRIVER INBOUND SCAN                                                                                                |
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                 |
      | description | Inbounded by Driver  {ninja-driver-id} on Route {KEY_LIST_OF_CREATED_ROUTES[1].id} at hub {hub-id} Status: Success |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | PARCEL ROUTING SCAN      |
      | hubName     | {hub-name}               |
      | description | Scanned at hub: {hub-id} |
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name     | DRIVER START ROUTE                 |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | driverId | {ninja-driver-id}                  |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |

  @MediumPriority @ArchiveRouteCommonV2
  Scenario: Upload CSV File for B2B Orders with Invalid Granular Status
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                              |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
      | globalShipperId | {shipper-v4-id}                                                                                      |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | On Vehicle for Delivery            |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | granularStatus | Completed                          |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/th-b2b"
    And Operator click upload csv button in b2b page
    And Operator click Download Sample File button in Upload CSV dialog
    Then Operator verify sample CSV file is downloaded successfully on b2b page
    When Operator upload auto_inbound csv file on b2b page
      | trackingId                            | routeId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Upload button in Upload CSV dialog
    Then Operator verifies that notification is displayed in b2b page:
      | top    | Auto Inbound Processed       |
      | bottom | Some Orders failed to update |
    And Operator verifies results table contains the following details:
      | trackingId                            | routeId                            | status | message                                                                                                                                           |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Error  | Order granular status 'Pickup fail' not valid [AllowedGranularStatuses=Pending Pickup/En-route to Sorting Hub/Arrived at Sorting Hub]             |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Error  | Order granular status 'On Vehicle for Delivery' not valid [AllowedGranularStatuses=Pending Pickup/En-route to Sorting Hub/Arrived at Sorting Hub] |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Error  | Order granular status 'Completed' not valid [AllowedGranularStatuses=Pending Pickup/En-route to Sorting Hub/Arrived at Sorting Hub]               |

  @MediumPriority
  Scenario: Upload CSV File for B2B Orders with Invalid Route Id
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/th-b2b"
    And Operator click upload csv button in b2b page
    When Operator upload auto_inbound csv file on b2b page
      | trackingId                            | routeId  |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | 96756280 |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | 96750    |
    And Operator click Upload button in Upload CSV dialog
    Then Operator verifies that notification is displayed in b2b page:
      | top    | Auto Inbound Processed       |
      | bottom | Some Orders failed to update |
    And Operator verifies results table contains the following details:
      | trackingId                            | routeId  | status | message                  |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | 96756280 | Error  | Route 96756280 not found |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | 96750    | Error  | Route 96750 not found    |

  @MediumPriority @ArchiveRouteCommonV2
  Scenario: Upload CSV File for B2B Orders with Invalid Tracking Id
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/th-b2b"
    And Operator click upload csv button in b2b page
    When Operator upload auto_inbound csv file on b2b page
      | trackingId            | routeId                            |
      | TESTINVALIDTRACKINGID | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | CORETRACKINGID        | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Upload button in Upload CSV dialog
    Then Operator verifies that notification is displayed in b2b page:
      | top    | Auto Inbound Processed       |
      | bottom | Some Orders failed to update |
    And Operator verifies results table contains the following details:
      | trackingId            | routeId                            | status | message                                     |
      | TESTINVALIDTRACKINGID | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Error  | Tracking id TESTINVALIDTRACKINGID not found |
      | CORETRACKINGID        | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Error  | Tracking id CORETRACKINGID not found        |

  @MediumPriority @ArchiveRouteCommonV2
  Scenario: Upload CSV File for B2B Orders with Route Id not Assigned to Hub
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/th-b2b"
    And Operator click upload csv button in b2b page
    When Operator upload auto_inbound csv file on b2b page
      | trackingId                            | routeId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Upload button in Upload CSV dialog
    Then Operator verifies that notification is displayed in b2b page:
      | top    | Auto Inbound Processed       |
      | bottom | Some Orders failed to update |
    And Operator verifies results table contains the following details:
      | trackingId                            | routeId                            | status | message                                             |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Error  | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} has no hub |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Error  | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} has no hub |

  @MediumPriority @ArchiveRouteCommonV2
  Scenario: Upload CSV File for B2B Orders with Route Id not Assigned to Driver
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/th-b2b"
    And Operator click upload csv button in b2b page
    When Operator upload auto_inbound csv file on b2b page
      | trackingId                            | routeId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Upload button in Upload CSV dialog
    Then Operator verifies that notification is displayed in b2b page:
      | top    | Auto Inbound Processed       |
      | bottom | Some Orders failed to update |
    And Operator verifies results table contains the following details:
      | trackingId                            | routeId                            | status | message                                                              |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Error  | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} is not assigned to a driver |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Error  | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} is not assigned to a driver |

  @MediumPriority
  Scenario: Download CSV sample file for TH B2B Orders
    Given Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/th-b2b"
    When Operator click upload csv button in b2b page
    And Operator click Download Sample File button in Upload CSV dialog
    Then Operator verify sample CSV file is downloaded successfully on b2b page

  @MediumPriority
  Scenario: Download Error CSV Orders in TH B2B
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | On Vehicle for Delivery            |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/th-b2b"
    And Operator click upload csv button in b2b page
    When Operator upload auto_inbound csv file on b2b page
      | trackingId                            | routeId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator click Upload button in Upload CSV dialog
    Then Operator verifies that notification is displayed in b2b page:
      | top    | Auto Inbound Processed       |
      | bottom | Some Orders failed to update |
    When Operator click Download Error Csv button in Upload CSV dialog
    Then Operator verify Error CSV file is downloaded successfully on b2b page
      | trackingId                            | routeId                            | message                                                                                                                                           |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Order granular status 'On Vehicle for Delivery' not valid [AllowedGranularStatuses=Pending Pickup/En-route to Sorting Hub/Arrived at Sorting Hub] |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[2].id} | Route {KEY_LIST_OF_CREATED_ROUTES[2].id} is not assigned to a driver                                                                              |

  @MediumPriority @ArchiveRouteCommonV2
  Scenario:Upload CSV with Partial Failed Orders in TH B2B
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | On Vehicle for Delivery            |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/th-b2b"
    And Operator click upload csv button in b2b page
    When Operator upload auto_inbound csv file on b2b page
      | trackingId                            | routeId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Upload button in Upload CSV dialog
    Then Operator verifies that notification is displayed in b2b page:
      | top    | Auto Inbound Processed       |
      | bottom | Some Orders failed to update |
    And Operator verifies results table contains the following details:
      | trackingId                            | routeId                            | status  | message                                                                                                                                           |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Error   | Order granular status 'On Vehicle for Delivery' not valid [AllowedGranularStatuses=Pending Pickup/En-route to Sorting Hub/Arrived at Sorting Hub] |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | Success |                                                                                                                                                   |
