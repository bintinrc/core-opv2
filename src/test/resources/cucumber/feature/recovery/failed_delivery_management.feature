@OperatorV2 @Recovery @FailedDeliveryManagementV2 @ClearCache @ClearCookies
Feature: Failed Delivery Management Page - Action Feature

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @ActionFeature
  Scenario: Operator - Find Failed Delivery Order - by some filters
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - Search failed orders by shipperName = "{KEY_LIST_OF_CREATED_ORDERS[1].shipper.name}"
    And Recovery User - verify failed delivery table on FDM page:
      | trackingId            | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | shipperName           | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | failureReasonComments | {KEY_SELECTED_FAILURE_REASON.description}    |

  @ActionFeature
  Scenario: Operator - Select all shown - Failed Delivery Management page
    Given Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator refresh page
    And Recovery User - Wait until FDM Page loaded completely
    When Recovery User - clicks "Select All Shown" button on Failed Delivery Management page
    And Recovery User - verifies number of selected rows on Failed Delivery Management page

  @ActionFeature
  Scenario: Operator - Deselect all shown - Failed Delivery Management page
    Given Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator refresh page
    And Recovery User - Wait until FDM Page loaded completely
    When Recovery User - clicks "Select All Shown" button on Failed Delivery Management page
    And Recovery User - verifies number of selected rows on Failed Delivery Management page
    When Recovery User - clicks "Deselect All Shown" button on Failed Delivery Management page
    Then Recovery User - verify the number of selected Failed Delivery rows is "0"

  @ActionFeature
  Scenario: Operator - Clear current selection - Failed Delivery Management page
    Given Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator refresh page
    And Recovery User - Wait until FDM Page loaded completely
    When Recovery User - clicks "Select All Shown" button on Failed Delivery Management page
    And Recovery User - verifies number of selected rows on Failed Delivery Management page
    When Recovery User - clicks "Clear Current Selection" button on Failed Delivery Management page
    Then Recovery User - verify the number of selected Failed Delivery rows is "0"

  @ActionFeature
  Scenario: Operator - Show only selection - Failed Delivery Management page
    Given Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator refresh page
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - selects 1 rows on Failed Delivery Management page
    When Recovery User - clicks "Show Only Selected" button on Failed Delivery Management page
    Then Recovery User - verify the number of selected Failed Delivery rows is "1"

  @ActionFeature @ForceSuccessOrder
  Scenario: Operator - Download and Verify CSV File
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator refresh page
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - selects 1 rows on Failed Delivery Management page
    And Recovery User - Download CSV file of failed delivery order on Failed Delivery orders list
    And Recovery User - verify CSV file of failed delivery order on Failed Delivery orders list downloaded successfully

  @RescheduleFailedDelivery @ForceSuccessOrder
  Scenario Outline: Operator - Reschedule Failed Delivery - Single Order - on Next Day - <Dataset_Name>
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"<order_type>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Recovery User - reschedule failed delivery order on next day
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order Rescheduling Success       |
      | description | Success to reschedule 1 order(s) |
    And Operator waits for 5 seconds
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And API Operator verify order info after failed delivery order rescheduled on next day

    Examples:
      | Dataset_Name | order_type |
      | Normal       | Parcel     |
      | Return       | Return     |

  @RescheduleFailedDelivery @ForceSuccessOrder
  Scenario Outline:Operator - Reschedule Failed Delivery - Single Order - Latest Scan = Route Inbound Scan - <Dataset_Name>
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"<order_type>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans       | 1 |
      | parcelProcessedTotal       | 1 |
      | failedDeliveriesValidScans | 1 |
      | failedDeliveriesValidTotal | 1 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Recovery User - reschedule failed delivery order on next day
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order Rescheduling Success       |
      | description | Success to reschedule 1 order(s) |
    And Operator waits for 5 seconds
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[1].toName} |

    Examples:
      | Dataset_Name | order_type |
      | Normal       | Parcel     |
      | Return       | Return     |

  @RescheduleFailedDelivery @ForceSuccessOrder
  Scenario Outline: Operator - Reschedule Failed Delivery - Single Order - on Specific Date - <Dataset_Name>
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"<order_type>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - selects 1 rows on Failed Delivery Management page
    And Recovery User - Reschedule Selected failed delivery order on Failed Delivery orders list
    And Recovery User - set reschedule date to "{date: 2 days next, yyyy-MM-dd}"
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order Rescheduling Success       |
      | description | Success to reschedule 1 order(s) |
    And Recovery User - verify CSV file downloaded after reschedule
    And Operator waits for 5 seconds
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And API Operator verify order info after failed delivery order rescheduled on next 2 days

    Examples:
      | Dataset_Name | order_type |
      | Normal       | Parcel     |
      | Return       | Return     |

  @RescheduleFailedDelivery @ForceSuccessOrder
  Scenario: Operator - Reschedule Failed Delivery - Multiple Orders
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} }                       |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} }                       |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - selects 1 rows on Failed Delivery Management page
    When Recovery User - Clear the TID filter
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}"
    And Recovery User - selects 1 rows on Failed Delivery Management page
    When Recovery User - Clear the TID filter
    When Recovery User - clicks "Show Only Selected" button on Failed Delivery Management page
    And Recovery User - Reschedule Selected failed delivery order on Failed Delivery orders list
    And Recovery User - set reschedule date to "{date: 2 days next, yyyy-MM-dd}"
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order Rescheduling Success       |
      | description | Success to reschedule 2 order(s) |
    And Recovery User - verify CSV file downloaded after reschedule
    And Operator waits for 5 seconds

    #Verify first failed order
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[1].toName} |

    #Verify Second failed order
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[2].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[2].toName} |

  @RescheduleFailedDelivery @ForceSuccessOrder
  Scenario: Operator - Reschedule Failed Delivery - Multiple Orders - by Upload CSV
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} }                       |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} }                       |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" with granular status "PENDING_RESCHEDULE"
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}" with granular status "PENDING_RESCHEDULE"
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - clicks "CSV Reschedule" button on Failed Delivery Management page
    And Recovery User - Reschedule failed orders with CSV
      | tracking_ids    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | reschedule_date | {date: 2 days next, yyyy-MM-dd}                                                       |
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order Rescheduling Success       |
      | description | Success to reschedule 2 order(s) |
    And Recovery User - verify CSV file downloaded after reschedule
    And Operator waits for 5 seconds

    #Verify first failed order
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[1].toName} |

    #Verify Second failed order
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[2].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[2].toName} |

  Scenario Outline: Operator - RTS Failed Delivery - Single Order - on Next Day - <Dataset_Name>
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"<order_type>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - RTS order on next day
    Then Recovery User - verifies Edit RTS Details dialog
      | recipientName       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}     |
      | recipientContact    | {KEY_LIST_OF_CREATED_ORDER[1].fromContact}  |
      | recipientEmail      | {KEY_LIST_OF_CREATED_ORDER[1].fromEmail}    |
      | shipperInstructions | {KEY_LIST_OF_CREATED_ORDER[1].fromEmail}    |
      | country             | {KEY_LIST_OF_CREATED_ORDER[1].fromCountry}  |
      | address1            | {KEY_LIST_OF_CREATED_ORDER[1].fromAddress1} |
      | address2            | {KEY_LIST_OF_CREATED_ORDER[1].fromAddress2} |
      | postalCode          | {KEY_LIST_OF_CREATED_ORDER[1].fromPostcode} |
    When Recovery User - selects reason from Return To Sender Reason dropdown and timeslot from Timeslot dropdown
    And Recovery User - set RTS date to "{date: 1 days next, yyyy-MM-dd}"
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order RTS Success         |
      | description | Success 1 order(s) RTS-ed |
    And Operator waits for 5 seconds
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |

    Examples:
      | Dataset_Name | order_type |
      | Normal       | Parcel     |
      | Return       | Return     |

  Scenario Outline: Operator - RTS Failed Delivery - Multiple Order - <Dataset_Name>
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"<order_type>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} }                       |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} }                       |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - selects 1 rows on Failed Delivery Management page
    When Recovery User - Clear the TID filter
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}"
    And Recovery User - selects 1 rows on Failed Delivery Management page
    When Recovery User - Clear the TID filter
    When Recovery User - clicks "Show Only Selected" button on Failed Delivery Management page
    And  Recovery User - RTS multiple orders on next day
    And Recovery User - verifies Set Selected to Return to Sender dialog
      | trackingId                            | status             |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Pending reschedule |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Pending reschedule |
    When Recovery User - selects reason from Return To Sender Reason dropdown and timeslot from Timeslot dropdown
    And Recovery User - set RTS date to "{date: 1 days next, yyyy-MM-dd}" for multiple orders
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order RTS Success         |
      | description | Success 2 order(s) RTS-ed |
    And Operator waits for 5 seconds
    #verify first order
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |
    #verify second order
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |

    Examples:
      | Dataset_Name | order_type |
      | Normal       | Parcel     |
      | Return       | Return     |

  Scenario Outline: Operator - RTS Failed Delivery Change Address - Single Order - Add new address - <Dataset_Name>
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"<order_type>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - RTS order on next day
    Then Recovery User - verifies Edit RTS Details dialog
      | recipientName       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}     |
      | recipientContact    | {KEY_LIST_OF_CREATED_ORDER[1].fromContact}  |
      | recipientEmail      | {KEY_LIST_OF_CREATED_ORDER[1].fromEmail}    |
      | shipperInstructions | {KEY_LIST_OF_CREATED_ORDER[1].fromEmail}    |
      | country             | {KEY_LIST_OF_CREATED_ORDER[1].fromCountry}  |
      | address1            | {KEY_LIST_OF_CREATED_ORDER[1].fromAddress1} |
      | address2            | {KEY_LIST_OF_CREATED_ORDER[1].fromAddress2} |
      | postalCode          | {KEY_LIST_OF_CREATED_ORDER[1].fromPostcode} |
    When Recovery User - selects reason from Return To Sender Reason dropdown and timeslot from Timeslot dropdown
    And Recovery User - change order address in Edit RTS Details dialog
    And Recovery User - set RTS date to "{date: 1 days next, yyyy-MM-dd}"
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order RTS Success         |
      | description | Success 1 order(s) RTS-ed |
    And Operator waits for 5 seconds
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |

    Examples:
      | Dataset_Name | order_type |
      | Normal       | Parcel     |
      | Return       | Return     |

  Scenario Outline: Operator - RTS Failed Delivery Change Address - Single Order - Search address by Name - <Dataset_Name>
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"<order_type>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - RTS order on next day
    Then Recovery User - verifies Edit RTS Details dialog
      | recipientName       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}     |
      | recipientContact    | {KEY_LIST_OF_CREATED_ORDER[1].fromContact}  |
      | recipientEmail      | {KEY_LIST_OF_CREATED_ORDER[1].fromEmail}    |
      | shipperInstructions | {KEY_LIST_OF_CREATED_ORDER[1].fromEmail}    |
      | country             | {KEY_LIST_OF_CREATED_ORDER[1].fromCountry}  |
      | address1            | {KEY_LIST_OF_CREATED_ORDER[1].fromAddress1} |
      | address2            | {KEY_LIST_OF_CREATED_ORDER[1].fromAddress2} |
      | postalCode          | {KEY_LIST_OF_CREATED_ORDER[1].fromPostcode} |
    When Recovery User - selects reason from Return To Sender Reason dropdown and timeslot from Timeslot dropdown
    And Recovery User - search address by name in Edit RTS Details dialog
    And Recovery User - set RTS date to "{date: 1 days next, yyyy-MM-dd}"
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order RTS Success         |
      | description | Success 1 order(s) RTS-ed |
    And Operator waits for 5 seconds
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |

    Examples:
      | Dataset_Name | order_type |
      | Normal       | Parcel     |
      | Return       | Return     |

  Scenario Outline: Operator - RTS Failed Delivery Change Address - Single Order - Cancel Change Address - <Dataset_Name>
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"<order_type>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - RTS order on next day
    Then Recovery User - verifies Edit RTS Details dialog
      | recipientName       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}     |
      | recipientContact    | {KEY_LIST_OF_CREATED_ORDER[1].fromContact}  |
      | recipientEmail      | {KEY_LIST_OF_CREATED_ORDER[1].fromEmail}    |
      | shipperInstructions | {KEY_LIST_OF_CREATED_ORDER[1].fromEmail}    |
      | country             | {KEY_LIST_OF_CREATED_ORDER[1].fromCountry}  |
      | address1            | {KEY_LIST_OF_CREATED_ORDER[1].fromAddress1} |
      | address2            | {KEY_LIST_OF_CREATED_ORDER[1].fromAddress2} |
      | postalCode          | {KEY_LIST_OF_CREATED_ORDER[1].fromPostcode} |
    When Recovery User - selects reason from Return To Sender Reason dropdown and timeslot from Timeslot dropdown
    And Recovery User - change order address in Edit RTS Details dialog
    And Recovery User - cancel address change in Edit RTS Details dialog
    And Recovery User - set RTS date to "{date: 1 days next, yyyy-MM-dd}"
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order RTS Success         |
      | description | Success 1 order(s) RTS-ed |
    And Operator waits for 5 seconds
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |

    Examples:
      | Dataset_Name | order_type |
      | Normal       | Parcel     |
      | Return       | Return     |

  Scenario Outline: Operator - RTS Failed Delivery - Single Order - Latest Scan = Route Inbound Scan - <Dataset_Name>
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"<order_type>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | { "hubId":{hub-id} }                       |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans       | 1 |
      | parcelProcessedTotal       | 1 |
      | failedDeliveriesValidScans | 1 |
      | failedDeliveriesValidTotal | 1 |
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - RTS order on next day
    Then Recovery User - verifies Edit RTS Details dialog
      | recipientName       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}     |
      | recipientContact    | {KEY_LIST_OF_CREATED_ORDER[1].fromContact}  |
      | recipientEmail      | {KEY_LIST_OF_CREATED_ORDER[1].fromEmail}    |
      | shipperInstructions | {KEY_LIST_OF_CREATED_ORDER[1].fromEmail}    |
      | country             | {KEY_LIST_OF_CREATED_ORDER[1].fromCountry}  |
      | address1            | {KEY_LIST_OF_CREATED_ORDER[1].fromAddress1} |
      | address2            | {KEY_LIST_OF_CREATED_ORDER[1].fromAddress2} |
      | postalCode          | {KEY_LIST_OF_CREATED_ORDER[1].fromPostcode} |
    When Recovery User - selects reason from Return To Sender Reason dropdown and timeslot from Timeslot dropdown
    And Recovery User - set RTS date to "{date: 1 days next, yyyy-MM-dd}"
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order RTS Success         |
      | description | Success 1 order(s) RTS-ed |
    And Operator waits for 5 seconds
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | FAIL |
    Examples:
      | Dataset_Name | order_type |
      | Normal       | Parcel     |
      | Return       | Return     |

  @RescheduleFailedDelivery @ForceSuccessOrder
  Scenario: Operator - Reschedule Failed Delivery - Upload CSV with empty line at the end
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} }                       |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} }                       |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" with granular status "PENDING_RESCHEDULE"
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}" with granular status "PENDING_RESCHEDULE"
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - clicks "CSV Reschedule" button on Failed Delivery Management page
    And Recovery User - Reschedule failed orders with CSV
      | tracking_ids    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}," " |
      | reschedule_date | {date: 2 days next, yyyy-MM-dd}                                                           |
    And Recovery User - verifies that error dialog displayed with message below:
      | message     | Failed to update 1 item(s) |
      | description | : Invalid Tracking ID      |
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order Rescheduling Success       |
      | description | Success to reschedule 2 order(s) |
    And Recovery User - verify CSV file downloaded after reschedule
    And Operator waits for 5 seconds

    #Verify first failed order
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[1].toName} |

    #Verify Second failed order
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[2].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[2].toName} |

  Scenario: Operator - Reschedule Failed Delivery - Upload CSV with empty line at the middle
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} }                       |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} }                       |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "FAIL" }] |
      | routes          | KEY_DRIVER_ROUTES                                                                   |
      | jobAction       | FAIL                                                                                |
      | jobMode         | DELIVERY                                                                            |
      | failureReasonId | 139                                                                                 |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" with granular status "PENDING_RESCHEDULE"
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}" with granular status "PENDING_RESCHEDULE"
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - clicks "CSV Reschedule" button on Failed Delivery Management page
    And Recovery User - Reschedule failed orders with CSV
      | tracking_ids    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}," ",{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | reschedule_date | {date: 2 days next, yyyy-MM-dd}                                                           |
    And Recovery User - verifies that error dialog displayed with message below:
      | message     | Failed to update 1 item(s) |
      | description | : Invalid Tracking ID      |
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order Rescheduling Success       |
      | description | Success to reschedule 2 order(s) |
    And Recovery User - verify CSV file downloaded after reschedule
    And Operator waits for 5 seconds

    #Verify first failed order
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[1].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[1].toName} |

    #Verify Second failed order
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type    | DELIVERY                              |
      | status  | FAIL                                  |
      | driver  | {ninja-driver-name}                   |
      | routeId | {KEY_CREATED_ROUTE_ID}                |
      | dnr     | NORMAL                                |
      | name    | {KEY_LIST_OF_CREATED_ORDER[2].toName} |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY                              |
      | status | PENDING                               |
      | dnr    | NORMAL                                |
      | name   | {KEY_LIST_OF_CREATED_ORDER[2].toName} |

  Scenario: Operator - Reschedule Failed Delivery - Upload CSV without TIDs
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - clicks "CSV Reschedule" button on Failed Delivery Management page
    And Recovery User - Reschedule failed orders with CSV
      | tracking_ids    | "" |
      | reschedule_date | "" |
    Then Recovery User - verifies that toast displayed with message below:
      | message | No order data to process, please check the file |

  Scenario:Operator - Reschedule Failed Delivery - Upload CSV without Header
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until FDM Page loaded completely
    And Recovery User - clicks "CSV Reschedule" button on Failed Delivery Management page
    And Recovery User - uploads csv file without header
    Then Recovery User - verifies that toast displayed with message below:
      | message | Invalid Header in CSV, please check the sample file |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op