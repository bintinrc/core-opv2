@OperatorV2 @Core @RoutingID @DriverRouteCODLimit @DriverCodLimitIDPart6
Feature: ID - Order COD Limit

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteRoutes
  Scenario: Operator Allow to Add Single Orders with COD <30 Millions to Single Driver Routes on Zonal Routing
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route from zonal routing using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id}, "waypoints":[{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}] } |
#    verify 1st order routed
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPending | 30,000,000.00                               |
      | driverName           | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId             | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | 30000000                           |

  @DeleteDriver @DeleteRoutes
  Scenario: Operator Allow to Add Multiple Orders with COD <30 Millions to Single Driver Routes on Zonal Routing
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":15000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route from zonal routing using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id}, "waypoints":[{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}, {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}] } |
#    verify 1st order routed
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId} |
#    verify 2nd order routed
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPending | 30,000,000.00                               |
      | driverName           | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId             | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | 30000000                           |

  @DeleteDriver @DeleteRoutes
  Scenario: Operator Disallow to Add Single Orders with COD >30 Millions to Single Driver Routes on Zonal Routing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000001, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator fail to create new route from zonal routing using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id}, "waypoints":[{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}] }                                                                                                                                                                                  |
      | errorMessage       | {"code": 103102,"nvErrorCode": "SERVER_ERROR_EXCEPTION","messages": ["exceptions.ProcessingException: Driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} has exceeded total cod limit "],"application": "core","description": "INTERNAL_SERVER_ERROR","data": {"message": "exceptions.ProcessingException: Driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} has exceeded total cod limit "}} |

#    verify 1st not order routed
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | routeId | null                 |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | routeId  | null                         |
      | seqNo    | null                         |
      | status   | Pending                      |

  @DeleteDriver @DeleteRoutes
  Scenario: Operator Disallow to Add Multiple Orders with COD >30 Millions to Single Driver Routes on Zonal Routing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                             |
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":1, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator fail to create new route from zonal routing using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id}, "waypoints":[{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}, {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}] }                                                                                                                      |
      | errorMessage       | {"code": 103102,"nvErrorCode": "SERVER_ERROR_EXCEPTION","messages": ["exceptions.ProcessingException: Driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} has exceeded total cod limit "],"application": "core","description": "INTERNAL_SERVER_ERROR","data": {"message": "exceptions.ProcessingException: Driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} has exceeded total cod limit "}} |

#    verify 1st not order routed
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | routeId | null                 |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | routeId  | null                         |
      | seqNo    | null                         |
      | status   | Pending                      |

#      verify 2nd not order routed
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | routeId | null                 |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | routeId  | null                         |
      | seqNo    | null                         |
      | status   | Pending                      |

