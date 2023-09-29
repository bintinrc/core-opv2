@OperatorV2 @Core @PickUps @ReservationPresetManagement @ReservationPresetManagementPart1
Feature: Reservation Preset Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteReservationGroup
  Scenario: Operator Create New Group to Assign Driver on Reservation Preset Management Page
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                               |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                         |
      | hub                    | { "displayName": "{hub-name-2}", "value": {hub-id-2} }                                                                                                                                                                                                                                                                                                                                                                      |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page:
      | name   | {KEY_CREATED_RESERVATION_GROUP[1].name}   |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_CREATED_RESERVATION_GROUP[1].name} |

  @DeleteDriverV2 @DeleteReservationGroup
  Scenario: Operator Edit Reservation Group on Reservation Preset Management Page
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                               |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                            |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                         |
      | hub                    | { "displayName": "{hub-name-2}", "value": {hub-id-2} }                                                                                                                                                                                                                                                                                                                                                                      |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page:
      | name   | {KEY_CREATED_RESERVATION_GROUP[1].name}   |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    When Operator edit "{KEY_CREATED_RESERVATION_GROUP[1].name}" Reservation Group on Reservation Preset Management page with data below:
      | name   | {KEY_CREATED_RESERVATION_GROUP[1].name}   |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name-2}                              |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_EDITED_RESERVATION_GROUP_NAME[1]} |

  @DeleteDriverV2 @DeleteReservationGroup
  Scenario: Operator Delete Reservation Group on Reservation Preset Management Page
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}-{{TIMESTAMP}}", "display_name":"{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRI1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-3-day-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page:
      | name   | {KEY_CREATED_RESERVATION_GROUP[1].name}   |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    When Operator delete created Reservation Group on Reservation Preset Management page:
      | name | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator refresh page
    Then Operator verify created Reservation Group was deleted successfully on Reservation Preset Management page:
      | name | {KEY_CREATED_RESERVATION_GROUP[1].name} |

  @DeleteDriverV2 @DeleteShipper @DeleteReservationGroup
  Scenario: Assign a Shipper Milkrun Address to a Milkrun Group
    Given Operator go to menu Utilities -> QRCode Printing
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}-{{TIMESTAMP}}", "display_name":"{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRI1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-3-day-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    And API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Shipper - Operator reload all shipper cache
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}                                                                                                                                                                                                                                                                                                                                                                       |
      | generateAddress       | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperAddressRequest | {"name":"{KEY_SHIPPER_LIST_OF_SHIPPERS[1].name}","contact":"{KEY_SHIPPER_LIST_OF_SHIPPERS[1].contact}","email":"{KEY_SHIPPER_LIST_OF_SHIPPERS[1].email}","address1":"address1","address2":"address2","country":"SG","latitude":1.27,"longitude":103.27,"postcode":"159363","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}"
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page:
      | name   | {KEY_CREATED_RESERVATION_GROUP[1].name}   |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].name}  |
      | group   | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    Then Operator verifies that success toast displayed:
      | top | ^{KEY_SHIPPER_LIST_OF_SHIPPERS[1].name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP[1].name} |

  @DeleteDriverV2 @DeleteShipper @DeleteReservationGroup
  Scenario: Route Pending Reservations From the Reservation Preset Management Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}-{{TIMESTAMP}}", "display_name":"{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRI1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-3-day-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    And API Shipper - Operator create new shipper using data below:
      | shipperType | Normal |
    And API Shipper - Operator edit shipper value of pickup appointment using below data:
      | shipperId | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].id} |
      | status    | False                                |
    And API Shipper - Operator update shipper setting using data below:
      | shipperId               | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}                                                                                                                                                                                                                                                                                        |
      | shipperSettingNamespace | pickup                                                                                                                                                                                                                                                                                                                      |
      | shipperSettingRequest   | {"address_limit":10,"allow_premium_pickup_on_sunday":true,"allow_standard_pickup_on_sunday":true,"premium_pickup_daily_limit":100,"milk_run_pickup_limit":10,"default_start_time":"09:00","default_end_time":"22:00","service_type_level":[{"type":"Scheduled","level":"Standard"},{"type":"Scheduled","level":"Premium"}]} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}                                                                                                                                                                                                                                                                                                                                                                       |
      | generateAddress       | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperAddressRequest | {"name":"{KEY_SHIPPER_LIST_OF_SHIPPERS[1].name}","contact":"{KEY_SHIPPER_LIST_OF_SHIPPERS[1].contact}","email":"{KEY_SHIPPER_LIST_OF_SHIPPERS[1].email}","address1":"address1","address2":"address2","country":"SG","latitude":1.27,"longitude":103.27,"postcode":"159363","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}"
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}", "pickup_service_level":"Premium" } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{KEY_DRIVER_LIST_OF_DRIVERS[1].vehicles[1].id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[1].id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page:
      | name   | {KEY_CREATED_RESERVATION_GROUP[1].name}   |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].name}  |
      | group   | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    Then Operator verifies that success toast displayed:
      | top | ^{KEY_SHIPPER_LIST_OF_SHIPPERS[1].name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator refresh page
    When Operator create route on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP[1].name} |
      | routeDate | {date: 1 days next, yyyy-MM-dd}         |
    And Operator refresh page
    When Operator route pending reservations on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP[1].name} |
      | routeDate | {date: 1 days next, yyyy-MM-dd}         |
    Then Operator verifies that info toast displayed:
      | top | 1 reservations added to route |

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
