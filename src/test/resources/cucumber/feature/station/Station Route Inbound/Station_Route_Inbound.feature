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
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
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
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
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
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When Operator go to menu Fleet -> Driver Strength
    And Operator create new Driver on Driver Strength page using data below:
      | displayName          | GENERATED                                                        |
      | firstName            | GENERATED                                                        |
      | lastName             | test                                                             |
      | licenseNumber        | GENERATED                                                        |
      | type                 | AUTO-STATION-TEMP                                                |
      | codLimit             | 100                                                              |
      | hub                  | <HubName>                                                        |
      | employmentStartDate  | {date: 0 days next, YYYY-MM-dd}                                  |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleType          | Car                                                              |
      | vehicleCapacity      | 100                                                              |
      | contactType          | {contact-type-name}                                              |
      | contact              | GENERATED                                                        |
      | zoneId               | {zone-name}                                                      |
      | zoneMin              | 1                                                                |
      | zoneMax              | 1                                                                |
      | zoneCost             | 1                                                                |
      | username             | GENERATED                                                        |
      | password             | Ninjitsu89                                                       |
      | comments             | This driver is created by "Automation Test" for testing purpose. |
    And DB Operator get data of created driver
    And API Driver - Driver login with username "{KEY_CREATED_DRIVER_INFO.username}" and "Ninjitsu89"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_INFO.id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And Operator go to menu Inbounding -> Route Inbound (New)
    When Station operator get Route Summary Details on Route Inbound page using data below:
      | hubName    | <HubName>                             |
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op