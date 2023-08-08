@OperatorV2 @Core @Inbounding @RouteInbound @InboundCOD
Feature: Inbound COD & COP

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @happy-path
  Scenario Outline: Inbound Cash for COD - <Title>
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cashOnDelivery>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                      |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                              |
      | routes     | KEY_DRIVER_ROUTES                                                                                       |
      | jobType    | TRANSACTION                                                                                             |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS", "cod":<cashOnDelivery>}] |
      | jobAction  | SUCCESS                                                                                                 |
      | jobMode    | DELIVERY                                                                                                |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                            |
      | fetchBy      | FETCH_BY_TRACKING_ID                  |
      | fetchByValue | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | wpPending   | 0                                         |
      | wpPartial   | 0                                         |
      | wpFailed    | 0                                         |
      | wpCompleted | 1                                         |
      | wpTotal     | 1                                         |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify 'Money to collect' value is "<cashOnDelivery>" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    Then Operator verify 'Expected Total' value is "<cashOnDelivery>" on Money Collection dialog
    And Operator verify 'Outstanding amount' value is "<cashOnDelivery>" on Money Collection dialog
    When Operator submit following values on Money Collection dialog:
      | cashCollected   | <cashCollected>   |
      | creditCollected | <creditCollected> |
      | receiptId       | <receiptId>       |
    Then Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator verify 'Outstanding amount' value is "Fully Collected" on Money Collection dialog
    Examples:
      | Title                            | cashCollected | creditCollected | receiptId | cashOnDelivery |
      | Inbound Cash Only                | 23.57         |                 |           | 23.57          |
      | Inbound Credit Only              |               | 23.57           | 123       | 23.57          |
      | Inbound Split Into Cash & Credit | 10.0          | 13.57           | 123       | 23.57          |

  @ArchiveRouteCommonV2
  Scenario Outline: Inbound Cash for COP - <Title>
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                        |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{"cash_on_delivery":<cashOnPickup>, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                              |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                            |
      | routes     | KEY_DRIVER_ROUTES                                                                                     |
      | jobType    | TRANSACTION                                                                                           |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"SUCCESS", "cod":<cashOnPickup>}] |
      | jobAction  | SUCCESS                                                                                               |
      | jobMode    | PICK_UP                                                                                               |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}        |
      | driverName  | {ninja-driver-name}                       |
      | hubName     | {hub-name}                                |
      | routeDate   | {KEY_LIST_OF_CREATED_ROUTES[1].createdAt} |
      | wpPending   | 0                                         |
      | wpPartial   | 0                                         |
      | wpFailed    | 0                                         |
      | wpCompleted | 1                                         |
      | wpTotal     | 1                                         |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify 'Money to collect' value is "<cashOnPickup>" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    Then Operator verify 'Expected Total' value is "<cashOnPickup>" on Money Collection dialog
    And Operator verify 'Outstanding amount' value is "<cashOnPickup>" on Money Collection dialog
    When Operator submit following values on Money Collection dialog:
      | cashCollected   | <cashCollected>   |
      | creditCollected | <creditCollected> |
      | receiptId       | <receiptId>       |
    Then Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator verify 'Outstanding amount' value is "Fully Collected" on Money Collection dialog
    Examples:
      | Title                            | hiptest-uid                              | cashCollected | creditCollected | receiptId | cashOnPickup |
      | Inbound Cash Only                | uid:efdbd93c-1bdb-4b3c-870c-5241bdc4ac48 | 23.57         |                 |           | 23.57        |
      | Inbound Credit Only              | uid:aa78036d-10ca-43c2-add2-5ed08faea2b0 |               | 23.57           | 123       | 23.57        |
      | Inbound Split Into Cash & Credit | uid:f153b865-3093-43cd-82ed-4d17bec13cdd | 10.0          | 13.57           | 123       | 23.57        |
