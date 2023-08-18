@StationManagement @StationRouteInbound
Feature: Route Inbound

  Background:
    When Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Get Route Details by Route ID - Route with No Waypoints
    Given Operator loads Operator portal home page
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName | <HubName>                          |
      | fetchBy | RouteId                            |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then operator verifies the toast message "Route has no waypoints!" is displayed

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Get Route Details by Route ID - Route with Waypoints
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName | <HubName>                          |
      | fetchBy | RouteId                            |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that Driver Attendance confirmation modal is displayed
    And Operator confirms the driver attendance
    Then Operator is redirected to Route Inbound - Route Summary page
    Then Operator verifies Route Summary details are dispayed correctly
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | driverName | {ninja-driver-name}                |
      | hubName    | <HubName>                          |
      | date       | {date: 0 days next, YYYY-MM-dd}    |
    Then Operator verifies waypoint performance details are dispayed correctly
      | pending     | 1  |
      | partial     | 0  |
      | failed      | 0  |
      | completed   | 0  |
      | total       | 1  |
      | successRate | 0% |
    Then Operator verifies Collection summary details are dispayed correctly
      | cash          | 0 |
      | failedParcels | 0 |
      | c2cplusReturn | 0 |
      | reservations  | 0 |
    Then Operator verifies problematic parcels details are displayed correctly in the row 1
      | trackingId  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | shipperName | {shipper-v4-name}                          |
      | location    | 30A ST. THOMAS WALK 102600 SG 102600 SG    |
      | type        | Delivery (Normal)                          |
      | issue       | Pending                                    |

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Get Route Details by Tracking ID - Order's Transactions are Routed: Only 1 Route_Id
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName    | <HubName>                                  |
      | fetchBy    | TrackingId                                 |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verifies that Driver Attendance confirmation modal is displayed
    And Operator confirms the driver attendance
    Then Operator is redirected to Route Inbound - Route Summary page
    Then Operator verifies Route Summary details are dispayed correctly
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | driverName | {ninja-driver-name}                |
      | hubName    | <HubName>                          |
      | date       | {date: 0 days next, YYYY-MM-dd}    |
    Then Operator verifies waypoint performance details are dispayed correctly
      | pending     | 1  |
      | partial     | 0  |
      | failed      | 0  |
      | completed   | 0  |
      | total       | 1  |
      | successRate | 0% |
    Then Operator verifies Collection summary details are dispayed correctly
      | cash          | 0 |
      | failedParcels | 0 |
      | c2cplusReturn | 0 |
      | reservations  | 0 |
    Then Operator verifies problematic parcels details are displayed correctly in the row 1
      | trackingId  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | shipperName | {shipper-v4-name}                          |
      | location    | 30A ST. THOMAS WALK 102600 SG 102600 SG    |
      | type        | Delivery (Normal)                          |
      | issue       | Pending                                    |

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Get Route Details by Driver Name - Number of Route_Id = 1
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"first_name":"{{RANDOM_FIRST_NAME}}","last_name":"driver","display_name":"D{{TIMESTAMP}}","license_number":"D{{TIMESTAMP}}","driver_type":"{driver-type-name}","availability":false,"cod_limit":4353,"vehicles":[{"active":true,"vehicleNo":"6456345","vehicleType":"{vehicle-type-name}","ownVehicle":false,"capacity":345}],"contacts":[{"active":true,"type":"Mobile Phone","details":"+65 65745 455"}],"zone_preferences":[{"latitude":1.3597220659709373,"longitude":103.82701942695314,"maxWaypoints":6,"minWaypoints":6,"rank":1,"zoneId":3629,"cost":6}],"max_on_demand_jobs":45,"username":"Station{{TIMESTAMP}}","password":"Password1","tags":{},"employment_start_date":"{date:0 days next,YYYY-MM-dd}","employment_end_date":null,"hub_id":<HubId>,"hub":{"displayName":"<HubName>","value":<HubId>}} |
    And API Driver - Driver login with username "{KEY_CREATED_DRIVER_INFO.username}" and "Password1"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_INFO.id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName    | <HubName>                             |
      | fetchBy    | DriverName                            |
      | driverName | {KEY_CREATED_DRIVER_INFO.displayName} |
    Then Operator verifies that Driver Attendance confirmation modal is displayed
    And Operator confirms the driver attendance
    Then Operator is redirected to Route Inbound - Route Summary page
    Then Operator verifies Route Summary details are dispayed correctly
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | driverName | {KEY_CREATED_DRIVER_INFO.displayName} |
      | hubName    | <HubName>                             |
      | date       | {date: 0 days next, YYYY-MM-dd}       |
    Then Operator verifies waypoint performance details are dispayed correctly
      | pending     | 1  |
      | partial     | 0  |
      | failed      | 0  |
      | completed   | 0  |
      | total       | 1  |
      | successRate | 0% |
    Then Operator verifies Collection summary details are dispayed correctly
      | cash          | 0 |
      | failedParcels | 0 |
      | c2cplusReturn | 0 |
      | reservations  | 0 |
    Then Operator verifies problematic parcels details are displayed correctly in the row 1
      | trackingId  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | shipperName | {shipper-v4-name}                          |
      | location    | 30A ST. THOMAS WALK 102600 SG 102600 SG    |
      | type        | Delivery (Normal)                          |
      | issue       | Pending                                    |

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Get Route Details by Route ID - Route doesn't Exist
    Given Operator loads Operator portal home page
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName | <HubName> |
      | fetchBy | RouteId   |
      | routeId | 12121212  |
    Then operator verifies the toast message "Route for id=12121212 not found" is displayed

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Get Route Details by Route ID - Route not Assigned to a Driver
    Given Operator loads Operator portal home page
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}} |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName | <HubName>                          |
      | fetchBy | RouteId                            |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then operator verifies the toast message "Route is not assigned to a driver!" is displayed

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Get Route Details by Tracking ID - Order is Not Routed
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName    | <HubName>                                  |
      | fetchBy    | TrackingId                                 |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then operator verifies the toast message "Order is not on any route!" is displayed

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Get Route Details by Tracking ID - Order Not Found
    Given Operator loads Operator portal home page
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName    | <HubName>       |
      | fetchBy    | TrackingId      |
      | trackingId | FSFGFSB57573457 |
    Then operator verifies the toast message "Order not found!" is displayed

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Get Route Details by Tracking ID - Order's Transactions are Routed: More than 1 Route_Id
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id},"type":"DELIVERY"} |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName    | <HubName>                                  |
      | fetchBy    | TrackingId                                 |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}         |
    Then Operator verifies that Driver Attendance confirmation modal is displayed
    And Operator confirms the driver attendance
    Then Operator is redirected to Route Inbound - Route Summary page
    Then Operator verifies Route Summary details are dispayed correctly
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | driverName | {ninja-driver-name}                |
      | hubName    | <HubName>                          |
      | date       | {date: 0 days next, YYYY-MM-dd}    |
    Then Operator verifies waypoint performance details are dispayed correctly
      | pending     | 1  |
      | partial     | 0  |
      | failed      | 0  |
      | completed   | 0  |
      | total       | 1  |
      | successRate | 0% |
    Then Operator verifies Collection summary details are dispayed correctly
      | cash          | 0 |
      | failedParcels | 0 |
      | c2cplusReturn | 0 |
      | reservations  | 0 |
    Then Operator verifies problematic parcels details are displayed correctly in the row 1
      | trackingId  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | shipperName | {shipper-v4-name}                          |
      | location    | 30A ST. THOMAS WALK 102600 SG 102600 SG    |
      | type        | Delivery (Return)                          |
      | issue       | Pending                                    |
    Given Operator loads Operator portal home page
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName    | <HubName>                                  |
      | fetchBy    | TrackingId                                 |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}         |
    Then Operator verifies that Driver Attendance confirmation modal is displayed
    And Operator confirms the driver attendance
    Then Operator is redirected to Route Inbound - Route Summary page
    Then Operator verifies Route Summary details are dispayed correctly
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | driverName | {ninja-driver-name}                |
      | hubName    | <HubName>                          |
      | date       | {date: 0 days next, YYYY-MM-dd}    |
    Then Operator verifies waypoint performance details are dispayed correctly
      | pending     | 0    |
      | partial     | 0    |
      | failed      | 0    |
      | completed   | 1    |
      | total       | 1    |
      | successRate | 100% |
    Then Operator verifies Collection summary details are dispayed correctly
      | cash          | 0 |
      | failedParcels | 0 |
      | c2cplusReturn | 0 |
      | reservations  | 0 |

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @Debug
  Scenario Outline: Operator Get Route Details - Route ID
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName | <HubName>                          |
      | fetchBy | RouteId                            |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that Driver Attendance confirmation modal is displayed
    And Operator confirms the driver attendance
    Then Operator is redirected to Route Inbound - Route Summary page
    Then Operator verifies Route Summary details are dispayed correctly
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | driverName | {ninja-driver-name}                |
      | hubName    | <HubName>                          |
      | date       | {date: 0 days next, YYYY-MM-dd}    |
    Then Operator verifies waypoint performance details are dispayed correctly
      | pending     | 0    |
      | partial     | 0    |
      | failed      | 0    |
      | completed   | 1    |
      | total       | 1    |
      | successRate | 100% |
    Then Operator verifies Collection summary details are dispayed correctly
      | cash          | 0 |
      | failedParcels | 0 |
      | c2cplusReturn | 0 |
      | reservations  | 0 |

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @Debug
  Scenario Outline: Operator Get Route Details - Tracking ID
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName    | <HubName>                                  |
      | fetchBy    | TrackingId                                 |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verifies that Driver Attendance confirmation modal is displayed
    And Operator confirms the driver attendance
    Then Operator is redirected to Route Inbound - Route Summary page
    Then Operator verifies Route Summary details are dispayed correctly
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | driverName | {ninja-driver-name}                |
      | hubName    | <HubName>                          |
      | date       | {date: 0 days next, YYYY-MM-dd}    |
    Then Operator verifies waypoint performance details are dispayed correctly
      | pending     | 0    |
      | partial     | 0    |
      | failed      | 0    |
      | completed   | 1    |
      | total       | 1    |
      | successRate | 100% |
    Then Operator verifies Collection summary details are dispayed correctly
      | cash          | 0 |
      | failedParcels | 0 |
      | c2cplusReturn | 0 |
      | reservations  | 0 |

    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriverV2 @Debug
  Scenario Outline: Operator Get Route Details - Driver
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "Station", "last_name": "driver", "display_name": "Station{date: 0 days next, YYYYMMddHHMMSS}", "license_number": "Station{date: 0 days next, YYYYMMdd}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"Station{date: 0 days next, YYYYMMddHHMMSS}","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":<HubId>} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+65 65745 455"}]                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": 2, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                    |
      | hub                    | {"displayName": "<HubName>", "value": <HubId>}                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Password1"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName    | <HubName>                                   |
      | fetchBy    | DriverName                                  |
      | driverName | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
    Then Operator verifies that Driver Attendance confirmation modal is displayed
    And Operator confirms the driver attendance
    Then Operator is redirected to Route Inbound - Route Summary page
    Then Operator verifies Route Summary details are dispayed correctly
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | driverName | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | hubName    | <HubName>                                   |
      | date       | {date: 0 days next, YYYY-MM-dd}             |
    Then Operator verifies waypoint performance details are dispayed correctly
      | pending     | 0    |
      | partial     | 0    |
      | failed      | 0    |
      | completed   | 1    |
      | total       | 1    |
      | successRate | 100% |
    Then Operator verifies Collection summary details are dispayed correctly
      | cash          | 0 |
      | failedParcels | 0 |
      | c2cplusReturn | 0 |
      | reservations  | 0 |


    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriverV2 @Debug
  Scenario Outline: Get Route Details by Driver Name - Number of Route_Id > 1
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "Station", "last_name": "driver", "display_name": "Station{date: 0 days next, YYYYMMddHHMMSS}", "license_number": "Station{date: 0 days next, YYYYMMdd}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"Station{date: 0 days next, YYYYMMddHHMMSS}","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":<HubId>} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+65 65745 455"}]                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": 2, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                    |
      | hub                    | {"displayName": "<HubName>", "value": <HubId>}                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Password1"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id},"type":"DELIVERY"} |

    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    And API Driver - Driver read routes:
      | driverId        | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName    | <HubName>                                   |
      | fetchBy    | DriverName                                  |
      | driverName | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
    Then Operator verifies that Driver Attendance confirmation modal is displayed
    And Operator confirms the driver attendance
    Then Operator is redirected to Route Inbound - Route Summary page
    Then Operator verifies Route Summary details are dispayed correctly
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | driverName | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | hubName    | <HubName>                                   |
      | date       | {date: 0 days next, YYYY-MM-dd}             |
    Then Operator verifies waypoint performance details are dispayed correctly
      | pending     | 0    |
      | partial     | 0    |
      | failed      | 0    |
      | completed   | 1    |
      | total       | 1    |
      | successRate | 100% |
    Then Operator verifies Collection summary details are dispayed correctly
      | cash          | 0 |
      | failedParcels | 0 |
      | c2cplusReturn | 0 |
      | reservations  | 0 |


    Examples:
      | HubId       | HubName       |
      | {hub-id-20} | {hub-name-20} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op