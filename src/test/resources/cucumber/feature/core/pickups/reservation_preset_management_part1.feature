@OperatorV2 @Core @PickUps @ReservationPresetManagement @ReservationPresetManagementPart1
Feature: Reservation Preset Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteReservationGroup
  Scenario: Operator Create New Group to Assign Driver on Reservation Preset Management Page
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}-{{TIMESTAMP}}", "display_name":"{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRI1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-3-day-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params

  @DeleteDriverV2 @DeleteReservationGroup
  Scenario: Operator Edit Reservation Group on Reservation Preset Management Page
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}-{{TIMESTAMP}}", "display_name":"{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRI1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-3-day-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params
    When Operator edit created Reservation Group on Reservation Preset Management page using data below:
      | name | GENERATED    |
      | hub  | {hub-name-2} |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page

  @DeleteDriverV2 @DeleteReservationGroup
  Scenario: Operator Delete Reservation Group on Reservation Preset Management Page
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}-{{TIMESTAMP}}", "display_name":"{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRI1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-3-day-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params
    When Operator delete created Reservation Group on Reservation Preset Management page
    And Operator refresh page
    Then Operator verify created Reservation Group was deleted successfully on Reservation Preset Management page

  @DeleteDriverV2 @DeleteShipper @DeleteReservationGroup
  Scenario: Assign a Shipper Milkrun Address to a Milkrun Group
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}-{{TIMESTAMP}}", "display_name":"{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRI1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-3-day-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive               | true                  |
      | shipperType                   | Normal                |
      | ocVersion                     | v4                    |
      | services                      | STANDARD              |
      | trackingType                  | Fixed                 |
      | isAllowCod                    | false                 |
      | isAllowCashPickup             | true                  |
      | isPrepaid                     | true                  |
      | isAllowStagedOrders           | false                 |
      | isMultiParcelShipper          | false                 |
      | isDisableDriverAppReschedule  | false                 |
      | pricingScriptName             | {pricing-script-name} |
      | industryName                  | {industry-name}       |
      | salesPerson                   | {sales-person}        |
      | pickupAddressCount            | 1                     |
      | address.1.milkrun.1.startTime | 9AM                   |
      | address.1.milkrun.1.endTime   | 12PM                  |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name}           |
      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
    Then Operator verifies that success toast displayed:
      | top | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |

#    TODO DISABLED
#  @DeleteDriverV2 @DeleteShipper @DeleteReservationGroup
#  Scenario: Route Pending Reservations From the Reservation Preset Management Page
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRM1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
#    And Operator go to menu Shipper -> All Shippers
#    And Operator create new Shipper with basic settings using data below:
#      | isShipperActive               | true                  |
#      | shipperType                   | Normal                |
#      | ocVersion                     | v4                    |
#      | services                      | STANDARD              |
#      | trackingType                  | Fixed                 |
#      | isAllowCod                    | false                 |
#      | isAllowCashPickup             | true                  |
#      | isPrepaid                     | true                  |
#      | isAllowStagedOrders           | false                 |
#      | isMultiParcelShipper          | false                 |
#      | isDisableDriverAppReschedule  | false                 |
#      | pricingScriptName             | {pricing-script-name} |
#      | industryName                  | {industry-name}       |
#      | salesPerson                   | {sales-person}        |
#      | pickupAddressCount            | 1                     |
#      | address.1.milkrun.1.startTime | 9AM                   |
#      | address.1.milkrun.1.endTime   | 12PM                  |
#      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
#    And API Operator fetch id of the created shipper
#    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
#    And API Operator create V2 reservation using data below:
#      | reservationRequest | { "pickup_address_id":{KEY_LIST_OF_SHIPPER_ADDRESSES[1].id}, "legacy_shipper_id":{KEY_LEGACY_SHIPPER_ID}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
#    When Operator go to menu Pick Ups -> Reservation Preset Management
#    And Operator create new Reservation Group on Reservation Preset Management page using data below:
#      | name   | GENERATED                                                              |
#      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
#      | hub    | {hub-name}                                                             |
#    And Operator assign pending task on Reservation Preset Management page:
#      | shipper | {KEY_CREATED_SHIPPER.name}           |
#      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
#    Then Operator verifies that success toast displayed:
#      | top                | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
#      | waitUntilInvisible | true                                                                                         |
#    When Operator route pending reservations on Reservation Preset Management page:
#      | group | {KEY_CREATED_RESERVATION_GROUP.name} |
#    Then Operator verifies that success toast displayed:
#      | top | 1 reservations added to route |

#    TODO DISABLED
#  @DeleteDriverV2 @DeleteShipper @DeleteReservationGroup
#  Scenario: Create Route for Pickup Reservation - Route Date = Today
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRM1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
#    And Operator go to menu Shipper -> All Shippers
#    And Operator create new Shipper with basic settings using data below:
#      | isShipperActive               | true                  |
#      | shipperType                   | Normal                |
#      | ocVersion                     | v4                    |
#      | services                      | STANDARD              |
#      | trackingType                  | Fixed                 |
#      | isAllowCod                    | false                 |
#      | isAllowCashPickup             | true                  |
#      | isPrepaid                     | true                  |
#      | isAllowStagedOrders           | false                 |
#      | isMultiParcelShipper          | false                 |
#      | isDisableDriverAppReschedule  | false                 |
#      | pricingScriptName             | {pricing-script-name} |
#      | industryName                  | {industry-name}       |
#      | salesPerson                   | {sales-person}        |
#      | pickupAddressCount            | 1                     |
#      | address.1.milkrun.1.startTime | 9AM                   |
#      | address.1.milkrun.1.endTime   | 12PM                  |
#      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
#    And API Operator fetch id of the created shipper
#    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
#    When Operator go to menu Pick Ups -> Reservation Preset Management
#    And Operator create new Reservation Group on Reservation Preset Management page using data below:
#      | name   | GENERATED                                                              |
#      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
#      | hub    | {hub-name}                                                             |
#    And Operator assign pending task on Reservation Preset Management page:
#      | shipper | {KEY_CREATED_SHIPPER.name}           |
#      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
#    Then Operator verifies that success toast displayed:
#      | top                | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
#      | waitUntilInvisible | true                                                                                         |
#    When Operator create route on Reservation Preset Management page:
#      | group     | {KEY_CREATED_RESERVATION_GROUP.name} |
#      | routeDate | {gradle-current-date-yyyy-MM-dd}     |
#    Then Operator verifies that success toast displayed:
#      | top                | Routes have been created for all groups! |
#      | waitUntilInvisible | true                                     |
#    When Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
#      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
#      | toDate      | {gradle-current-date-yyyy-MM-dd} |
#      | shipperName | {KEY_LEGACY_SHIPPER_ID}          |
#      | status      | ROUTED                           |
#    Then Operator verify reservation details on Shipper Pickups page:
#      | shipperId              | {KEY_LEGACY_SHIPPER_ID}                                                |
#      | shipperName            | ^{KEY_CREATED_SHIPPER.name}.*                                          |
#      | pickupAddress          | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode}                       |
#      | routeId                | not null                                                               |
#      | driverName             | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
#      | priorityLevel          | 0                                                                      |
#      | readyBy                | ^{gradle-current-date-yyyy-MM-dd} .*                                   |
#      | latestBy               | ^{gradle-current-date-yyyy-MM-dd} .*                                   |
#      | reservationType        | REGULAR                                                                |
#      | reservationStatus      | ROUTED                                                                 |
#      | reservationCreatedTime | ^{gradle-current-date-yyyy-MM-dd}.*                                    |
#      | serviceTime            | null                                                                   |
#      | failureReason          | null                                                                   |
#      | comments               | null                                                                   |

#  TODO DISABLED
#  @DeleteDriverV2 @DeleteShipper @DeleteReservationGroup
#  Scenario: Create Route for Pickup Reservation - Route Date = Tomorrow
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRM1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
#    And Operator go to menu Shipper -> All Shippers
#    And Operator create new Shipper with basic settings using data below:
#      | isShipperActive               | true                  |
#      | shipperType                   | Normal                |
#      | ocVersion                     | v4                    |
#      | services                      | STANDARD              |
#      | trackingType                  | Fixed                 |
#      | isAllowCod                    | false                 |
#      | isAllowCashPickup             | true                  |
#      | isPrepaid                     | true                  |
#      | isAllowStagedOrders           | false                 |
#      | isMultiParcelShipper          | false                 |
#      | isDisableDriverAppReschedule  | false                 |
#      | pricingScriptName             | {pricing-script-name} |
#      | industryName                  | {industry-name}       |
#      | salesPerson                   | {sales-person}        |
#      | pickupAddressCount            | 1                     |
#      | address.1.milkrun.1.startTime | 9AM                   |
#      | address.1.milkrun.1.endTime   | 12PM                  |
#      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
#    And API Operator fetch id of the created shipper
#    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
#    When Operator go to menu Pick Ups -> Reservation Preset Management
#    And Operator create new Reservation Group on Reservation Preset Management page using data below:
#      | name   | GENERATED                                                              |
#      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
#      | hub    | {hub-name}                                                             |
#    And Operator assign pending task on Reservation Preset Management page:
#      | shipper | {KEY_CREATED_SHIPPER.name}           |
#      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
#    Then Operator verifies that success toast displayed:
#      | top                | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
#      | waitUntilInvisible | true                                                                                         |
#    When Operator create route on Reservation Preset Management page:
#      | group     | {KEY_CREATED_RESERVATION_GROUP.name} |
#      | routeDate | {gradle-next-1-day-yyyy-MM-dd}       |
#    Then Operator verifies that success toast displayed:
#      | top                | Routes have been created for all groups! |
#      | waitUntilInvisible | true                                     |
#    When Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
#      | fromDate    | {gradle-next-1-day-yyyy-MM-dd} |
#      | toDate      | {gradle-next-1-day-yyyy-MM-dd} |
#      | shipperName | {KEY_LEGACY_SHIPPER_ID}        |
#      | status      | ROUTED                         |
#    Then Operator verify reservation details on Shipper Pickups page:
#      | shipperId              | {KEY_LEGACY_SHIPPER_ID}                                                |
#      | shipperName            | ^{KEY_CREATED_SHIPPER.name}.*                                          |
#      | pickupAddress          | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode}                       |
#      | routeId                | not null                                                               |
#      | driverName             | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
#      | priorityLevel          | 0                                                                      |
#      | readyBy                | ^{gradle-next-1-day-yyyy-MM-dd}.*                                      |
#      | latestBy               | ^{gradle-next-1-day-yyyy-MM-dd}.*                                      |
#      | reservationType        | REGULAR                                                                |
#      | reservationStatus      | ROUTED                                                                 |
#      | reservationCreatedTime | ^{gradle-current-date-yyyy-MM-dd}.*                                    |
#      | serviceTime            | null                                                                   |
#      | failureReason          | null                                                                   |
#      | comments               | null                                                                   |

  @DeleteDriverV2 @DeleteShipper @DeleteReservationGroup
  Scenario: Unassign a Shipper Milkrun Address from a Milkrun Group
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRM1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive               | true                  |
      | shipperType                   | Normal                |
      | ocVersion                     | v4                    |
      | services                      | STANDARD              |
      | trackingType                  | Fixed                 |
      | isAllowCod                    | false                 |
      | isAllowCashPickup             | true                  |
      | isPrepaid                     | true                  |
      | isAllowStagedOrders           | false                 |
      | isMultiParcelShipper          | false                 |
      | isDisableDriverAppReschedule  | false                 |
      | pricingScriptName             | {pricing-script-name} |
      | industryName                  | {industry-name}       |
      | salesPerson                   | {sales-person}        |
      | pickupAddressCount            | 1                     |
      | address.1.milkrun.1.startTime | 9AM                   |
      | address.1.milkrun.1.endTime   | 12PM                  |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name}           |
      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
    Then Operator verifies that success toast displayed:
      | top | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
    When Operator go to menu Shipper -> All Shippers
    And Operator unset pickup addresses of the created shipper
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator unassign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name} |
    Then Operator verifies that success toast displayed:
      | top | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been unlink from {KEY_CREATED_RESERVATION_GROUP.name} group! |

  @DeleteDriverV2 @DeleteShipper @DeleteReservationGroup
  Scenario: Operator Add Shipper Address To Milkrun Reservation via Upload CSV - Address Has Not Assign to Milkrun and Has Not Added to Milkrun Group
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRM1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
      | pickupAddressCount           | 1                     |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator waits for 10 seconds
    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    And API Operator get created Reservation Group params
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId                | addressId                | action | milkrunGroupId                     | days            | startTime | endTime |
      | {KEY_CREATED_SHIPPER.id} | {KEY_CREATED_ADDRESS.id} | add    | {KEY_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And Operator go to menu Shipper -> All Shippers
    And Operator open Edit Shipper Page of shipper "{KEY_CREATED_SHIPPER.name}"
    Then Operator verify pickup address on Edit Shipper page:
      | address.1.milkrun.1.startTime | 3PM           |
      | address.1.milkrun.1.endTime   | 6PM           |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7 |
