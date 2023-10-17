@OperatorV2 @Core @RoutingID @DriverRouteCODLimit @DriverRouteLimitID
Feature: ID - Driver Route Limit

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @RestoreSystemParams @DeleteDriverV2 @DeleteRoutes
  Scenario: Operator Allow to Create <3 Driver Routes in a Day on Route Logs
    Given API Core - set system parameter:
      | key   | APPLY_DRIVER_NUMBER_OF_ROUTE_LIMIT |
      | value | 1                                  |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute | 3                                           |
      | date          | {gradle-current-date-yyyy-MM-dd}            |
      | tags          | {route-tag-name}                            |
      | zone          | {zone-name}                                 |
      | hub           | {hub-name}                                  |
      | driverName    | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    Then Operator verify routes details on Route Logs page using data below:
      | date                             | id                                | driverName                                  | hub        | zone        | driverTypeName     | comments                                 | tags             |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} | {driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[1].comments} | {route-tag-name} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} | {driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[2].comments} | {route-tag-name} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTE_ID[3]} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} | {driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[3].comments} | {route-tag-name} |
    And DB Route - verify route_logs record:
      | legacyId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
      | driverId | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | systemId | id                                 |
    And DB Route - verify route_logs record:
      | legacyId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]}  |
      | driverId | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | systemId | id                                 |
    And DB Route - verify route_logs record:
      | legacyId | {KEY_LIST_OF_CREATED_ROUTE_ID[3]}  |
      | driverId | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | systemId | id                                 |

  @RestoreSystemParams @DeleteDriverV2 @DeleteRoutes
  Scenario: Operator Partial Allow to Create >3 Driver Routes in a Day on Route Logs
    Given API Core - set system parameter:
      | key   | APPLY_DRIVER_NUMBER_OF_ROUTE_LIMIT |
      | value | 1                                  |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "DSN-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                                |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                            |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute | 4                                           |
      | date          | {gradle-current-date-yyyy-MM-dd}            |
#      TODO uncomment when issue is fixed
#      | tags          | {route-tag-name}                            |
      | zone          | {zone-name}                                 |
      | hub           | {hub-name}                                  |
      | driverName    | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | checkToast    | false                                       |
    Then Operator verifies that error react notification displayed:
      | top    | Status 500: Unknown                                                                        |
      | bottom | ^.*Error Message: exceptions.ProcessingException: Driver has more than 3 routes for date.* |
    When Operator refresh page
    And DB Route - get route_logs record for driver id "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}"
    And Operator set filters on Route Logs page:
      | routeDateFrom | {gradle-current-date-yyyy/MM/dd}            |
      | routeDateTo   | {gradle-current-date-yyyy/MM/dd}            |
      | hub           | {hub-name}                                  |
      | driver        | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
    And Operator click Load Selection on Route Logs page
    #      TODO uncomment when issue is fixed
    #      need to add tags for assertion
#    Then Operator verify routes details on Route Logs page using data below:
#      | date                             | id                                 | driverName                                  | hub        | zone        | driverTypeName     | comments                                 | tags             |
#      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[1].legacyId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} | {driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[1].comments} | {route-tag-name} |
#      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[2].legacyId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} | {driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[2].comments} | {route-tag-name} |
#      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[3].legacyId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} | {driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[3].comments} | {route-tag-name} |
    Then Operator verify routes details on Route Logs page using data below:
      | date                             | id                                       | driverName                                  | hub        | zone        | driverTypeName     | comments                                 |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[1].legacyId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} | {driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[1].comments} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[2].legacyId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} | {driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[2].comments} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[3].legacyId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} | {driver-type-name} | {KEY_LIST_OF_CREATED_ROUTES[3].comments} |


  @RestoreSystemParams @DeleteDriverV2 @DeleteRoutes
  Scenario: Operator Disallow to Create >3 Driver Routes in a Day on Route Logs
    Given API Core - set system parameter:
      | key   | APPLY_DRIVER_NUMBER_OF_ROUTE_LIMIT |
      | value | 1                                  |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    Given Operator go to menu Routing -> Route Logs
    When Operator create multiple routes using data below:
      | numberOfRoute | 1                                           |
      | date          | {gradle-current-date-yyyy-MM-dd}            |
      | tags          | {route-tag-name}                            |
      | zone          | {zone-name}                                 |
      | hub           | {hub-name}                                  |
      | driverName    | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | checkToast    | false                                       |
    Then Operator verifies that error react notification displayed:
      | top    | Status 500: Unknown                                                                        |
      | bottom | ^.*Error Message: exceptions.ProcessingException: Driver has more than 3 routes for date.* |


  @RestoreSystemParams @DeleteDriverV2 @DeleteRoutes
  Scenario: Operator Allow to Create <3 Driver Routes in a Day on Zonal Routing
    Given API Core - set system parameter:
      | key   | APPLY_DRIVER_NUMBER_OF_ROUTE_LIMIT |
      | value | 1                                  |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
#    create route 1
    And API Core - Operator create new route from zonal routing using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id}, "waypoints":[{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}]} |
    #    create route 2
    And API Core - Operator create new route from zonal routing using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id}, "waypoints":[{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}]} |
    #    create route 3
    And API Core - Operator create new route from zonal routing using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id}, "waypoints":[{KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId}]} |
    Given Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | TODAY      |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    Then Operator verify routes details on Route Logs page using data below:
      | date                             | id                                 | driverName                                  | hub        | zone        |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_LIST_OF_CREATED_ROUTES[3].id} | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} | {hub-name} | {zone-name} |
    And DB Route - verify route_logs record:
      | legacyId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | driverId | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | systemId | id                                 |
    And DB Route - verify route_logs record:
      | legacyId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | driverId | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | systemId | id                                 |
    And DB Route - verify route_logs record:
      | legacyId | {KEY_LIST_OF_CREATED_ROUTES[3].id} |
      | driverId | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | systemId | id                                 |
#    verify waypoint 1 routed
    And DB Core - verify transactions record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                 |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    #    verify waypoint 2 routed
    And DB Core - verify transactions record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id} |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id}                 |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
    #    verify waypoint 3 routed
    And DB Core - verify transactions record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].id} |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[3].id}                 |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[3].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[3].id}                         |