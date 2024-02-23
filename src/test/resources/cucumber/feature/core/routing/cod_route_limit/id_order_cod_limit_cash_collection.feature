@OperatorV2 @Core @RoutingID @DriverRouteCODLimit @DriverCodLimitIDPart3
Feature: ID - Order COD Limit

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow Add Order to Driver Route with Edited COD <40 Millions on Edit Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-below-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes                  |
      | amount         | {cod-below-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-below-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                                   |
      | description | Cash On Delivery changed from {cod-multiple-below-limit} to {cod-below-limit} |

    And Operator click Delivery -> Add to route on Edit Order V2 page
    And Operator add created order route on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that success react notification displayed:
      | top | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} has been added to route {KEY_LIST_OF_CREATED_ROUTES[1].id} successfully |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId}       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo   | not null                           |
      | status  | Routed                             |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId} |

    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Password1"
    And API Driver - Driver read routes:
      | driverId            | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}    |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPendingNoComa | {cod-below-limit}                           |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | {cod-below-limit}                  |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Disallow Add Order to Driver Route with Edited COD >40 Millions on Edit Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-above-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes                  |
      | amount         | {cod-above-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-above-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                                   |
      | description | Cash On Delivery changed from {cod-multiple-above-limit} to {cod-above-limit} |

    And Operator click Delivery -> Add to route on Edit Order V2 page
    And Operator add created order route on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                               |
      | bottom | ^.*Error Message: Driver has exceeded total cod.* |

  @DeleteDriverV2 @DeleteRoutes
  Scenario: Operator Allow Add Order to Driver Route with Removed COD on Edit Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-above-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | no |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verify COD icon is not displayed on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                          |
      | description | Cash On Delivery changed from {cod-above-limit} to 0 |

    And Operator click Delivery -> Add to route on Edit Order V2 page
    And Operator add created order route on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that success react notification displayed:
      | top                | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} has been added to route {KEY_LIST_OF_CREATED_ROUTES[1].id} successfully |
      | waitUntilInvisible | true                                                                                                          |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId}       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo   | not null                           |
      | status  | Routed                             |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId} |

    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Password1"
    And API Driver - Driver read routes:
      | driverId            | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}    |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | driverName | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And Operator verifies COD is not displayed on Route Manifest page
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | 0                                  |

  @DeleteDriverV2 @DeleteRoutes @RestoreSystemParams @HighPriority
  Scenario: Operator Allow Add Order to Driver Route with Edited COD <40 Millions on Edit Order - Edit Cash Collection and Edit COD Params
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-below-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes                  |
      | amount         | {cod-above-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-above-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                                   |
      | description | Cash On Delivery changed from {cod-multiple-below-limit} to {cod-above-limit} |

    And Operator click Delivery -> Add to route on Edit Order V2 page
    And Operator add created order route on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that error react notification displayed:
      | top                | Status 400: Unknown                               |
      | bottom             | ^.*Error Message: Driver has exceeded total cod.* |
      | waitUntilInvisible | true                                              |

    Given API Core - set system parameter:
      | key   | DRIVER_DAILY_COD_LIMIT |
      | value | {cod-above-limit}      |

    And Operator add created order route on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that success react notification displayed:
      | top                | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} has been added to route {KEY_LIST_OF_CREATED_ROUTES[1].id} successfully |
      | waitUntilInvisible | true                                                                                                          |

    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId}       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo   | not null                           |
      | status  | Routed                             |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId} |

    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Password1"
    And API Driver - Driver read routes:
      | driverId            | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}    |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPendingNoComa | {cod-above-limit}                           |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | {cod-above-limit}                  |

  @DeleteDriverV2 @DeleteRoutes @RestoreSystemParams @HighPriority
  Scenario: Operator Disallow Add Order to Driver Route with Edited COD >40 Millions on Edit Order - Edit Cash Collection and Edit COD Params
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes                  |
      | amount         | {cod-above-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-above-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                    |
      | description | Cash On Delivery changed from {cod-limit} to {cod-above-limit} |

    And Operator click Delivery -> Add to route on Edit Order V2 page
    And Operator add created order route on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                               |
      | bottom | ^.*Error Message: Driver has exceeded total cod.* |

    Given API Core - set system parameter:
      | key   | DRIVER_DAILY_COD_LIMIT     |
      | value | {cod-multiple-above-limit} |

    And Operator click Delivery -> Add to route on Edit Order V2 page
    And Operator add created order route on Edit Order V2 page using data below:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                               |
      | bottom | ^.*Error Message: Driver has exceeded total cod.* |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow Edit COD of Routed Order with COD <40 Millions on Edit Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-below-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes            |
      | amount         | {cod-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                             |
      | description | Cash On Delivery changed from {cod-multiple-below-limit} to {cod-limit} |

    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Password1"
    And API Driver - Driver read routes:
      | driverId            | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}    |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPendingNoComa | {cod-limit}                                 |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | {cod-limit}                        |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Disallow Edit COD of Routed Order with COD >40 Millions on Edit Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-above-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes                  |
      | amount         | {cod-above-limit}.00 |
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                               |
      | bottom | ^.*Error Message: Driver has exceeded total cod.* |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow Remove COD of Routed Order with COD >40 Millions on Edit Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-above-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                              |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | no |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verify COD icon is not displayed on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                   |
      | description | Cash On Delivery changed from {cod-multiple-above-limit} to 0 |

    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Password1"
    And API Driver - Driver read routes:
      | driverId            | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}    |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingIds | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | driverName | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And Operator verifies COD is not displayed on Route Manifest page
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | 0                                  |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow to Edit Multiple Routes to Same Date - Driver has Edited COD <40 Millions on Route Logs
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-above-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-below-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
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
      | createRouteRequest    | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
      | to_use_different_date | true                                                                                                              |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes                           |
      | amount         | {cod-multiple-below-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-multiple-below-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                                            |
      | description | Cash On Delivery changed from {cod-multiple-above-limit} to {cod-multiple-below-limit} |

    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    And Operator edits route details:
      | id   | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | date | {gradle-next-1-day-yyyy-MM-dd}     |
    Then Operator verifies that success react notification displayed:
      | top | 1 Route(s) Updated |
    Then Operator verify route details on Route Logs page using data below:
      | date | {gradle-next-1-day-yyyy-MM-dd}     |
      | id   | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPendingNoComa | {cod-multiple-below-limit}                  |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[2].id}          |
      | codCollectionPendingNoComa | {cod-multiple-below-limit}                  |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-next-1-day-yyyy-MM-dd}     |
      | cod       | {cod-below-limit}                  |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow to Edit Multiple Routes to Same Date - Driver has Edited COD >40 Millions on Route Logs
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-below-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-above-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
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
      | createRouteRequest    | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
      | to_use_different_date | true                                                                                                              |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes                           |
      | amount         | {cod-multiple-above-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-multiple-above-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                                            |
      | description | Cash On Delivery changed from {cod-multiple-below-limit} to {cod-multiple-above-limit} |

    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    And Operator edits route details:
      | id   | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | date | {gradle-next-1-day-yyyy-MM-dd}     |
    Then Operator verifies that error react notification displayed:
      | top    | Status 500: Unknown                                                                                                        |
      | bottom | ^.*Error Message: exceptions.ProcessingException: Driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} has exceeded total cod limit.* |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow to Transfer Multiple Routes to Same Driver - Driver has Edited COD <40 Millions on Route Logs
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-above-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-below-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D1-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D2-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[2].id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes                           |
      | amount         | {cod-multiple-below-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-multiple-below-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                                            |
      | description | Cash On Delivery changed from {cod-multiple-above-limit} to {cod-multiple-below-limit} |

    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    And Operator edits route details:
      | id         | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | driverName | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName} |
    Then Operator verifies that success react notification displayed:
      | top | 1 Route(s) Updated |
    Then Operator verify route details on Route Logs page using data below:
      | id         | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | driverName | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName} |
    And DB Route - verify route_logs record:
      | legacyId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | systemId | id                                 |
      | driverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |

    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPendingNoComa | {cod-multiple-below-limit}                  |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}          |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[2].id}          |
      | codCollectionPendingNoComa | {cod-multiple-below-limit}                  |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | {cod-below-limit}                  |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Disallow to Transfer Multiple Routes to Same Driver - Driver has Edited COD >40 Millions on Route Logs
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D1-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D2-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[2].id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-below-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":{cod-multiple-above-limit}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes                           |
      | amount         | {cod-multiple-above-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-multiple-above-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                                            |
      | description | Cash On Delivery changed from {cod-multiple-below-limit} to {cod-multiple-above-limit} |

    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    And Operator edits route details:
      | id         | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | driverName | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName} |
    Then Operator verifies that error react notification displayed:
      | top    | Status 500: Unknown                                                                                                        |
      | bottom | ^.*Error Message: exceptions.ProcessingException: Driver {KEY_DRIVER_LIST_OF_DRIVERS[2].id} has exceeded total cod limit.* |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow to Transfer Orders with Edited COD <40 Millions from Route A to Route B with Same Driver on Edit Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D1-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest    | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
      | to_use_different_date | true                                                                                                              |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes                           |
      | amount         | {cod-multiple-below-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-multiple-below-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                                   |
      | description | Cash On Delivery changed from {cod-below-limit} to {cod-multiple-below-limit} |

    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    And Operator selects 'Edit routes of selected' on Route Logs page:
      | routeIds | {KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
    And Operator move waypoint "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}" to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Edit Routes page
    And Operator click Update Routes on Edit Routes page
    And Confirm changes on Edit Routes page
    Then Operator verifies that success react notification displayed:
      | top                | Routes are Updated |
      | waitUntilInvisible | true               |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                |
      | routeId | KEY_LIST_OF_CREATED_ROUTES[2].id |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId}       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo   | not null                           |
      | status  | Routed                             |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPendingNoComa | {cod-below-limit}                           |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[2].id}          |
      | codCollectionPendingNoComa | {cod-multiple-below-limit}                  |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | {cod-below-limit}                  |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Disallow to Transfer Orders with Edited COD >40 Millions from Route A to Route B with Same Driver on Edit Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D1-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest    | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
      | to_use_different_date | true                                                                                                              |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator edit cash collection details on Edit Order V2 page:
      | cashOnDelivery | yes            |
      | amount         | {cod-limit}.00 |
    Then Operator verifies that success react notification displayed:
      | top | Update cash collection successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | cod | COD IDR{cod-limit} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CASH                                                             |
      | description | Cash On Delivery changed from {cod-multiple-below-limit} to {cod-limit} |

    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    And Operator selects 'Edit routes of selected' on Route Logs page:
      | routeIds | {KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
    And Operator move waypoint "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}" to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Edit Routes page
    And Operator click Update Routes on Edit Routes page
    And Confirm changes on Edit Routes page
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                        |
      | bottom | ^.*Error Message: Driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} has exceeded total cod limit.* |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow to Transfer Orders with COD <40 Millions from Route A to Route B with Different Driver on Edit Routes
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D1-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D1-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[2].id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |

    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    And Operator selects 'Edit routes of selected' on Route Logs page:
      | routeIds | {KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
    And Operator move waypoint "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}" to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Edit Routes page
    And Operator click Update Routes on Edit Routes page
    And Confirm changes on Edit Routes page
    Then Operator verifies that success react notification displayed:
      | top                | Routes are Updated |
      | waitUntilInvisible | true               |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                |
      | routeId | KEY_LIST_OF_CREATED_ROUTES[2].id |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId}       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo   | not null                           |
      | status  | Routed                             |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPendingNoComa | {cod-below-limit}                           |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[2].id}          |
      | codCollectionPendingNoComa | {cod-multiple-below-limit}                  |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | {cod-below-limit}                  |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | {cod-multiple-below-limit}         |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Disallow to Transfer Orders with COD >40 Millions from Route A to Route B with Different Driver on Edit Routes
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                               |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D1-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D1-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[2].id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |

    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    And Operator selects 'Edit routes of selected' on Route Logs page:
      | routeIds | {KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
    And Operator move waypoint "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}" to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Edit Routes page
    And Operator click Update Routes on Edit Routes page
    And Confirm changes on Edit Routes page
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                        |
      | bottom | ^.*Error Message: Driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} has exceeded total cod limit.* |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow to Transfer Orders with COD <40 Millions from Route A to Route B with Same Driver on Edit Routes
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D1-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest    | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
      | to_use_different_date | true                                                                                                              |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |

    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    And Operator selects 'Edit routes of selected' on Route Logs page:
      | routeIds | {KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
    And Operator move waypoint "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}" to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Edit Routes page
    And Operator click Update Routes on Edit Routes page
    And Confirm changes on Edit Routes page
    Then Operator verifies that success react notification displayed:
      | top                | Routes are Updated |
      | waitUntilInvisible | true               |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                |
      | routeId | KEY_LIST_OF_CREATED_ROUTES[2].id |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | ADD TO ROUTE                       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId}       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo   | not null                           |
      | status  | Routed                             |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPendingNoComa | {cod-below-limit}                           |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId                    | {KEY_LIST_OF_CREATED_ROUTES[2].id}          |
      | codCollectionPendingNoComa | {cod-multiple-below-limit}                  |
      | driverName                 | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId                   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | {cod-below-limit}                  |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Disallow to Transfer Orders with COD >40 Millions from Route A to Route B with Same Driver on Edit Routes
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                            |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                            |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                            |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateTo          | INDEX-0                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "cash_on_delivery": {cod-multiple-below-limit},"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "DFN-{gradle-current-date-yyyyMMddHHmmsss}", "last_name": "driver", "display_name": "D1-{gradle-current-date-yyyyMMddHHmmsss}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"StationRANDOM_STRING","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":{hub-id}} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                                                                                               |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+62 65745455"}]                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                                                                                           |
      | hub                    | {"displayName": "{hub-name}", "value": {hub-id}}                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest    | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
      | to_use_different_date | true                                                                                                              |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |

    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    And Operator selects 'Edit routes of selected' on Route Logs page:
      | routeIds | {KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    And Operator verify waypoint is displayed on Edit Routes page:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
    And Operator move waypoint "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}" to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Edit Routes page
    And Operator click Update Routes on Edit Routes page
    And Confirm changes on Edit Routes page
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                        |
      | bottom | ^.*Error Message: Driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} has exceeded total cod limit.* |
