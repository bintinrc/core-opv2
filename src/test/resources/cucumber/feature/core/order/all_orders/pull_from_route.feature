@OperatorV2 @Core @AllOrders @PullfromRoute
Feature: All Orders - Pull From Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @happy-path @HighPriority
  Scenario: Operator Pull Out Multiple Orders from Route on All Orders Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | seqNo    | 100                                                        |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo    | 200                                                        |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | status   | Routed                                                     |
    When Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator unmask All Orders page
    When API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator pull out multiple orders below from route on All Orders page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |

  @MediumPriority
  Scenario: Operator Should not be Able to Pull Out Unrouted Order on All Orders Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator unmask All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator apply "Pull From Route" action and expect to see "Selection Error"
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    Then Operator verify Selection Error dialog for invalid Pull From Order action
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
