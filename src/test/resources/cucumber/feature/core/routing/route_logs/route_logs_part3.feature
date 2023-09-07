@OperatorV2 @Core @Routing @RouteLogs @RouteLogsPart3
Feature: Route Logs

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Redirected to Route Manifest from Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    Then Operator verifies route details on Route Manifest page:
      | routeId | {KEY_CREATED_ROUTE_ID} |

  Scenario: Operator Not Allowed To See Driver List on Create Route if Driver Employment End Date < Today's Date
    Given Operator go to menu Utilities -> QRCode Printing
    And DB Operator find drivers with ended employment
    When Operator go to menu Routing -> Route Logs
    And Operator clicks Create Route on Route Logs page
    Then Operator verifies "{KEY_DB_FOUND_DRIVERS[1].firstName}" Driver is not shown in Create Route modal on Route Logs page

  @DeleteDriverV2
  Scenario: Operator Allowed To See Driver List on Create Route if Driver Employment End Date => Today's Date
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name":"{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRL1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date":"{gradle-next-0-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And Operator waits for 100 seconds
    When Operator go to menu Routing -> Route Logs
    And Operator clicks Create Route on Route Logs page
    Then Operator verifies "{KEY_CREATED_DRIVER.firstName}" Driver is shown in Create Route modal on Route Logs page

  @DeleteDriverV2
  Scenario: Operator Allowed To See Driver List on Create Route if Driver Has No Employment Date
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name":"{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRL1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And Operator waits for 10 seconds
    When Operator go to menu Routing -> Route Logs
    And Operator clicks Create Route on Route Logs page
    Then Operator verifies "{KEY_CREATED_DRIVER.firstName}" Driver is shown in Create Route modal on Route Logs page

  @DeleteOrArchiveRoute @DeleteDriverV2
  Scenario: Operator Allowed To See Driver List on Update Route if Driver Employment End Date => Today's Date
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name":"{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRL1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date":"{gradle-next-0-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And Operator waits for 100 seconds
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator opens Edit Details dialog for route "{KEY_CREATED_ROUTE_ID}" on Route Logs page
    Then Operator verifies "{KEY_CREATED_DRIVER.firstName}" Driver is shown in Edit Route Details modal on Route Logs page

  @DeleteOrArchiveRoute @DeleteDriverV2
  Scenario: Operator Allowed To See Driver List on Update Route if Driver Has No Employment Date
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name":"{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRL1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And Operator waits for 100 seconds
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator opens Edit Details dialog for route "{KEY_CREATED_ROUTE_ID}" on Route Logs page
    Then Operator verifies "{KEY_CREATED_DRIVER.firstName}" Driver is shown in Edit Route Details modal on Route Logs page

  @DeleteOrArchiveRoute
  Scenario: Operator Not Allowed To See Driver List on Update Route if Driver Employment End Date < Today's Date
    Given Operator go to menu Utilities -> QRCode Printing
    And DB Operator find drivers with ended employment
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator opens Edit Details dialog for route "{KEY_CREATED_ROUTE_ID}" on Route Logs page
    Then Operator verifies "{KEY_DB_FOUND_DRIVERS[1].firstName}" Driver is not shown in Edit Route Details modal on Route Logs page

  @DeleteOrArchiveRoute
  Scenario: Operator Print Multiple Routes Details With Multiple Waypoints from Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator print created routes
    Then Operator verifies that success react notification displayed:
      | top | Downloaded file route_printout.pdf... |
    And Operator verifies created routes are printed successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Delete Routes with Reservation on Route Logs
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator deletes created route on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top                | 1 Route(s) Deleted |
      | waitUntilInvisible | true               |
    And Operator verify routes are deleted successfully:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And DB Route - verify route_logs record:
      | legacyId  | {KEY_CREATED_ROUTE_ID} |
      | deletedAt | not null               |
    And DB Core - verify waypoints record:
      | id      | {KEY_WAYPOINT_ID} |
      | seqNo   | null              |
      | routeId | null              |
    And DB Core - verify shipper_pickup_search record:
      | reservationId | {KEY_CREATED_RESERVATION_ID} |
      | routeId       | null                         |
    And DB Events - verify pickup_events record:
      | pickupId   | {KEY_CREATED_RESERVATION_ID}        |
      | userId     | 397                                 |
      | userName   | AUTOMATION EDITED                   |
      | userEmail  | qa@ninjavan.co                      |
      | type       | 3                                   |
      | pickupType | 1                                   |
      | data       | {"route_id":{KEY_CREATED_ROUTE_ID}} |
