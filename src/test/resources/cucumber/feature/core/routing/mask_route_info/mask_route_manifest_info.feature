@OperatorV2 @Core @Routing @MaskRouteManifestInfo
Feature: Mask Route Manifest Info

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    
  @DeleteOrArchiveRoute
  Scenario: Operator View Mask Order for Normal Delivery on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{to-address}} |
    When API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verify waypoint at Route Manifest using data below:
      | status      | Pending                                                                                   |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                |
      | contact     | Click to reveal (tracked) 4435                                                            |
      | address     | Click to reveal (tracked) D MANDAI SQUARE 116 Click to reveal (tracked) g Timur SG 308412 |
    When Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status      | Pending                                                   |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | contact     | +9727894435                                               |
      | address     | 49 MANDALAY ROAD MANDAI SQUARE 116 Kilang Timur SG 308412 |

  @DeleteOrArchiveRoute
  Scenario: Operator View Mask Order for DP Delivery on Route Manifest
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{to-address}} |
    When API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{dp-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verify waypoint at Route Manifest using data below:
      | status      | Pending                                                                         |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                      |
      | contact     | Click to reveal (tracked) 4435                                                  |
      | address     | Click to reveal (tracked) AD, SG, 238880 Click to reveal (tracked) SG SG 238880 |
    When Operator refresh page
    Then Operator verify waypoint at Route Manifest using data below:
      | status      | Pending                                        |
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}     |
      | contact     | +9727894435                                    |
      | address     | 501, ORCHARD ROAD, SG, 238880 3-4 SG SG 238880 |






