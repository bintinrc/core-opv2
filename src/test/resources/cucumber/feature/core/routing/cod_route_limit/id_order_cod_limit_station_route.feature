@OperatorV2 @Core @RoutingID @DriverRouteCODLimit @DriverCodLimitIDPart7
Feature: ID - Order COD Limit

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
#TODO not being run in bamboo
  @DeleteDriverV2 @DeleteRoutes @MediumPriority
  Scenario: Operator Allow to Add Single Order with COD <30 Millions to Single New Driver Route on Station Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+62 65745455" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/id/station-route"
    And Operator select filters on Station Route page:
      | hub            | {hub-name}                                 |
      | additionalTids | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | driverId   | Unassigned                                 |
    And Operator assign "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}" driver for 1 row parcel on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                | parcelCount |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 1           |
    When Operator select Create new routes on Station Route page
    And Operator click Next button on Station Route page
    And Operator fill Create new routes form on Station Route page:
      | date     | {date: 0 days next, yyyy-MM-dd}                        |
      | tags     | {route-tag-name}                                       |
      | zone     | {zone-name}                                            |
      | hub      | {hub-name}                                             |
      | comments | Created by TA {date: 0 days next, yyyy-MM-dd-HH-mm-ss} |
    And Operator click Create routes button on Station Route page
    Then Operator verifies that success react notification displayed:
      | top    | 1 Routes created            |
      | bottom | 1 parcels added to 1 routes |
    And Operator verify table records on Created routes detail screen on Station Route page:
      | driverName                                | parcelCount | routeId  | routeDate                       | routeTags        | zone        | hub        | comment                                                |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 1           | not null | {date: 0 days next, yyyy-MM-dd} | {route-tag-name} | {zone-name} | {hub-name} | Created by TA {date: 0 days next, yyyy-MM-dd-HH-mm-ss} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | routeId | not null             |
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
    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Ninjitsu89"
    And API Driver - Driver read routes:
      | driverId           | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}    |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPending | 30,000,000                                  |
      | driverName           | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId             | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | 30000000                           |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Disallow to Add Single Order with COD >30 Millions to Single New Driver Route on Station Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000001, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+62 65745455" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/id/station-route"
    And Operator select filters on Station Route page:
      | hub            | {hub-name}                                 |
      | additionalTids | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | driverId   | Unassigned                                 |
    And Operator assign "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}" driver for 1 row parcel on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                | parcelCount |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 1           |
    When Operator select Create new routes on Station Route page
    And Operator click Next button on Station Route page
    And Operator fill Create new routes form on Station Route page:
      | date     | {date: 0 days next, yyyy-MM-dd}                        |
      | tags     | {route-tag-name}                                       |
      | zone     | {zone-name}                                            |
      | hub      | {hub-name}                                             |
      | comments | Created by TA {date: 0 days next, yyyy-MM-dd-HH-mm-ss} |
    And Operator click Create routes button on Station Route page
    Then Operator verify errors are displayed on Station Route page:
      | exceptions.ProcessingException: Driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} has exceeded total cod limit |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow to Add Multiple Orders with COD <30 Millions to Single New Driver Route on Station Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":20000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":10000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+62 65745455" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/id/station-route"
    And Operator select filters on Station Route page:
      | hub            | {hub-name}                                                                            |
      | additionalTids | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | driverId   | Unassigned                                 |
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | driverId   | Unassigned                                 |
    When Operator assign "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}" driver to parcels on Station Route page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                | parcelCount |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 2           |
    When Operator select Create new routes on Station Route page
    And Operator click Next button on Station Route page
    And Operator fill Create new routes form on Station Route page:
      | date     | {date: 0 days next, yyyy-MM-dd}                        |
      | tags     | {route-tag-name}                                       |
      | zone     | {zone-name}                                            |
      | hub      | {hub-name}                                             |
      | comments | Created by TA {date: 0 days next, yyyy-MM-dd-HH-mm-ss} |
    And Operator click Create routes button on Station Route page
    Then Operator verifies that success react notification displayed:
      | top    | 1 Routes created            |
      | bottom | 2 parcels added to 1 routes |
    And Operator verify table records on Created routes detail screen on Station Route page:
      | driverName                                | parcelCount | routeId  | routeDate                       | routeTags        | zone        | hub        | comment                                                |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 2           | not null | {date: 0 days next, yyyy-MM-dd} | {route-tag-name} | {zone-name} | {hub-name} | Created by TA {date: 0 days next, yyyy-MM-dd-HH-mm-ss} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | routeId | not null             |
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

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | routeId | not null             |
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

    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Ninjitsu89"
    And API Driver - Driver read routes:
      | driverId           | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}    |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPending | 30,000,000                                  |
      | driverName           | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId             | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | 30000000                           |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Disallow to Add Multiple Orders with COD >30 Millions to Single New Driver Route on Station Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":1, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+62 65745455" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/id/station-route"
    And Operator select filters on Station Route page:
      | hub            | {hub-name}                                                                            |
      | additionalTids | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | driverId   | Unassigned                                 |
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | driverId   | Unassigned                                 |
    When Operator assign "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}" driver to parcels on Station Route page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                | parcelCount |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 2           |
    When Operator select Create new routes on Station Route page
    And Operator click Next button on Station Route page
    And Operator fill Create new routes form on Station Route page:
      | date     | {date: 0 days next, yyyy-MM-dd}                        |
      | tags     | {route-tag-name}                                       |
      | zone     | {zone-name}                                            |
      | hub      | {hub-name}                                             |
      | comments | Created by TA {date: 0 days next, yyyy-MM-dd-HH-mm-ss} |
    And Operator click Create routes button on Station Route page
    Then Operator verify errors are displayed on Station Route page:
      | exceptions.ProcessingException: Driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} has exceeded total cod limit |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow to Add Single Orders with COD <30 Millions to Single Existing Driver Route on Station Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+62 65745455" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/id/station-route"
    And Operator select filters on Station Route page:
      | hub            | {hub-name}                                 |
      | additionalTids | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | driverId   | Unassigned                                 |
    And Operator assign "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}" driver for 1 row parcel on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                | parcelCount |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 1           |
    When Operator select Add to existing routes on Station Route page
    And Operator click Next button on Station Route page
    Then Operator verify table records on Add to existing routes screen on Station Route page:
      | driverName                                | routeId                            |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click Next button on Station Route page
    Then Operator verifies that success react notification displayed:
      | top | 1 parcels added to 1 routes |
    And Operator verify table records on Created routes detail screen on Station Route page:
      | driverName                                | parcelCount | routeId                            |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 1           | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | routeId | not null             |
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
    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Ninjitsu89"
    And API Driver - Driver read routes:
      | driverId           | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}    |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPending | 30,000,000                                  |
      | driverName           | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId             | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | 30000000                           |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Disallow to Add Single Orders with COD >30 Millions to Single Existing Driver Route on Station Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000001, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+62 65745455" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/id/station-route"
    And Operator select filters on Station Route page:
      | hub            | {hub-name}                                 |
      | additionalTids | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | driverId   | Unassigned                                 |
    And Operator assign "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}" driver for 1 row parcel on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                | parcelCount |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 1           |
    When Operator select Add to existing routes on Station Route page
    And Operator click Next button on Station Route page
    Then Operator verify table records on Add to existing routes screen on Station Route page:
      | driverName                                | routeId                            |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click Next button on Station Route page
    Then Operator verify errors are displayed on Station Route page:
      | {"error":{"application_exception_code":173000,"application":"ROUTE-V2","title":"REQUEST_ERR","message":"[limit=30000000] [driverID={KEY_DRIVER_LIST_OF_DRIVERS[1].id}][date={gradle-current-date-yyyy-MM-dd} 00:00:00 +0000 UTC][orderIDs=[{KEY_LIST_OF_CREATED_ORDERS[1].id}]]: cannot exceed maximum daily COD limit amount per driver |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Allow to Add Multiple Orders with COD <30 Millions to Single Existing Driver Route on Station Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":20000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":10000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+62 65745455" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/id/station-route"
    And Operator select filters on Station Route page:
      | hub            | {hub-name}                                                                            |
      | additionalTids | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | driverId   | Unassigned                                 |
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | driverId   | Unassigned                                 |
    When Operator assign "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}" driver to parcels on Station Route page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                | parcelCount |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 2           |
    When Operator select Add to existing routes on Station Route page
    And Operator click Next button on Station Route page
    Then Operator verify table records on Add to existing routes screen on Station Route page:
      | driverName                                | routeId                            |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click Next button on Station Route page
    Then Operator verifies that success react notification displayed:
      | top | 2 parcels added to 1 routes |
    And Operator verify table records on Created routes detail screen on Station Route page:
      | driverName                                | parcelCount | routeId                            |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 2           | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | routeId | not null             |
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

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | routeId | not null             |
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

    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Ninjitsu89"
    And API Driver - Driver read routes:
      | driverId           | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}    |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[1].id}          |
      | codCollectionPending | 30,000,000                                  |
      | driverName           | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId             | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | 30000000                           |

  @DeleteDriverV2 @DeleteRoutes @HighPriority
  Scenario: Operator Disallow to Add Multiple Orders with COD >30 Millions to Single Existing Driver Route on Station Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":1, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+62 65745455" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/id/station-route"
    And Operator select filters on Station Route page:
      | hub            | {hub-name}                                                                            |
      | additionalTids | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | driverId   | Unassigned                                 |
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | driverId   | Unassigned                                 |
    When Operator assign "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}" driver to parcels on Station Route page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                | parcelCount |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 2           |
    When Operator select Add to existing routes on Station Route page
    And Operator click Next button on Station Route page
    Then Operator verify table records on Add to existing routes screen on Station Route page:
      | driverName                                | routeId                            |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator click Next button on Station Route page
    Then Operator verify errors are displayed on Station Route page:
      | {"error":{"application_exception_code":173000,"application":"ROUTE-V2","title":"REQUEST_ERR","message":"[limit=30000000] [driverID={KEY_DRIVER_LIST_OF_DRIVERS[1].id}][date={gradle-current-date-yyyy-MM-dd} 00:00:00 +0000 UTC][orderIDs=[{KEY_LIST_OF_CREATED_ORDERS[1].id} {KEY_LIST_OF_CREATED_ORDERS[2].id}]]: cannot exceed maximum daily COD limit amount per driver |

  @DeleteDriverV2 @DeleteRoutes @MediumPriority
  Scenario: Operator Disallow to Add Multiple Orders with COD >30 Millions to Multiple Existing Driver Routes on Station Route - 1 Route is Archived
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":1, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+62 65745455" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/id/station-route"
    And Operator select filters on Station Route page:
      | hub            | {hub-name}                                 |
      | additionalTids | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | driverId   | Unassigned                                 |
    When Operator assign "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}" driver to parcels on Station Route page:
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                | parcelCount |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 1           |
    When Operator select Add to existing routes on Station Route page
    And Operator click Next button on Station Route page
    Then Operator verify table records on Add to existing routes screen on Station Route page:
      | driverName                                | routeId                            |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    When Operator click Next button on Station Route page
    Then Operator verify errors are displayed on Station Route page:
      | {"error":{"application_exception_code":173000,"application":"ROUTE-V2","title":"REQUEST_ERR","message":"[limit=30000000] [driverID={KEY_DRIVER_LIST_OF_DRIVERS[1].id}][date={gradle-current-date-yyyy-MM-dd} 00:00:00 +0000 UTC][orderIDs=[{KEY_LIST_OF_CREATED_ORDERS[2].id}]]: cannot exceed maximum daily COD limit amount per driver |

  @DeleteDriverV2 @DeleteRoutes @MediumPriority
  Scenario: Operator Allow to Add Multiple Orders with COD >30 Millions to Multiple Existing Driver Routes on Station Route - 1 Route is Deleted
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":30000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":1000000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "DL-{gradle-current-date-yyyyMMddHHmmsss}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+62 65745455" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Route - delete routes:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/id/station-route"
    And Operator select filters on Station Route page:
      | hub            | {hub-name}                                 |
      | additionalTids | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | driverId   | Unassigned                                 |
    When Operator assign "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}" driver to parcels on Station Route page:
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                | parcelCount |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 1           |
    When Operator select Add to existing routes on Station Route page
    And Operator click Next button on Station Route page
    Then Operator verify table records on Add to existing routes screen on Station Route page:
      | driverName                                | routeId                            |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    When Operator click Next button on Station Route page
    Then Operator verifies that success react notification displayed:
      | top | 1 parcels added to 1 routes |
    And Operator verify table records on Created routes detail screen on Station Route page:
      | driverName                                | parcelCount | routeId                            |
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} | 1           | {KEY_LIST_OF_CREATED_ROUTES[2].id} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id}               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId}       |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | seqNo   | not null                           |
      | status  | Routed                             |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | seqNo    | not null                           |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION.waypointId} |
    And API Driver - Driver login with username "{KEY_DRIVER_LIST_OF_DRIVERS[1].username}" and "Ninjitsu89"
    And API Driver - Driver read routes:
      | driverId           | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}    |
      | expectedRouteId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}    |
      | expectedTrackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    Then Operator verifies route details on Route Manifest page:
      | routeId              | {KEY_LIST_OF_CREATED_ROUTES[2].id}          |
      | codCollectionPending | 1,000,000                                   |
      | driverName           | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | driverId             | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}          |
    And API Core - verify driver's total cod:
      | driverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}   |
      | cod       | 1000000                            |