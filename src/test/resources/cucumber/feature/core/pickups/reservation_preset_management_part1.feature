@OperatorV2 @Core @PickUps @ReservationPresetManagement @ReservationPresetManagementPart1
Feature: Reservation Preset Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @ReservationPresetManagementCleanup @HighPriority
  Scenario: Operator Create New Group to Assign Driver on Reservation Preset Management Page
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                             |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                          |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                       |
      | hub                    | { "displayName": "{hub-name}", "value": {hub-id} }                                                                                                                                                                                                                                                                                                                                                                        |
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

  @DeleteDriverV2 @ReservationPresetManagementCleanup @MediumPriority
  Scenario: Operator Edit Reservation Group on Reservation Preset Management Page
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                             |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                          |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                       |
      | hub                    | { "displayName": "{hub-name}", "value": {hub-id} }                                                                                                                                                                                                                                                                                                                                                                        |
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
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_EDITED_RESERVATION_GROUP_NAME[1]} |

  @DeleteDriverV2 @ReservationPresetManagementCleanup @MediumPriority
  Scenario: Operator Delete Reservation Group on Reservation Preset Management Page
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                             |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                          |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                       |
      | hub                    | { "displayName": "{hub-name}", "value": {hub-id} }                                                                                                                                                                                                                                                                                                                                                                        |
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

  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Assign a Shipper Milkrun Address to a Milkrun Groups
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                             |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                          |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                       |
      | hub                    | { "displayName": "{hub-name}", "value": {hub-id} }                                                                                                                                                                                                                                                                                                                                                                        |
    And API Shipper - Operator edit shipper value of pickup appointment using below data:
      | shipperId | {rpm-shipper-id} |
      | status    | False            |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {rpm-shipper-id}                                                                                                                                                                                                             |
      | generateAddress       | RANDOM                                                                                                                                                                                                                       |
      | shipperAddressRequest | {"name":"{rpm-shipper-name}","contact":"{rpm-shipper-contact}","email":"{rpm-shipper-email}","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{rpm-shipper-id-legacy}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{rpm-shipper-id}"
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{rpm-shipper-id-legacy}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
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
      | shipper | {rpm-shipper-name}                      |
      | group   | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    Then Operator verifies that success toast displayed:
      | top | ^{rpm-shipper-name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP[1].name} |

  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Route Pending Reservations From the Reservation Preset Management Page
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                             |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                          |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                       |
      | hub                    | { "displayName": "{hub-name}", "value": {hub-id} }                                                                                                                                                                                                                                                                                                                                                                        |
    And API Shipper - Operator edit shipper value of pickup appointment using below data:
      | shipperId | {rpm-shipper-id} |
      | status    | False            |
    And API Shipper - Operator update shipper setting using data below:
      | shipperId               | {rpm-shipper-id}                                                                                                                                                                                                                                                                                                            |
      | shipperSettingNamespace | pickup                                                                                                                                                                                                                                                                                                                      |
      | shipperSettingRequest   | {"address_limit":10,"allow_premium_pickup_on_sunday":true,"allow_standard_pickup_on_sunday":true,"premium_pickup_daily_limit":100,"milk_run_pickup_limit":10,"default_start_time":"09:00","default_end_time":"22:00","service_type_level":[{"type":"Scheduled","level":"Standard"},{"type":"Scheduled","level":"Premium"}]} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {rpm-shipper-id}                                                                                                                                                                                                             |
      | generateAddress       | RANDOM                                                                                                                                                                                                                       |
      | shipperAddressRequest | {"name":"{rpm-shipper-name}","contact":"{rpm-shipper-contact}","email":"{rpm-shipper-email}","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{rpm-shipper-id-legacy}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{rpm-shipper-id}"
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{rpm-shipper-id-legacy}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{rpm-shipper-id-legacy}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}", "pickup_service_level":"Premium" } |
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
      | shipper | {rpm-shipper-name}                      |
      | group   | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    Then Operator verifies that success toast displayed:
      | top | ^{rpm-shipper-name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP[1].name} |
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
    And DB Route - get latest route_logs record for driver id "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}"
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | status   | Routed                                           |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].legacyId}         |


  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Create Route for Pickup Reservation - Route Date = Today
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                             |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                          |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                       |
      | hub                    | { "displayName": "{hub-name}", "value": {hub-id} }                                                                                                                                                                                                                                                                                                                                                                        |
    And API Shipper - Operator edit shipper value of pickup appointment using below data:
      | shipperId | {rpm-shipper-id} |
      | status    | False            |
    And API Shipper - Operator update shipper setting using data below:
      | shipperId               | {rpm-shipper-id}                                                                                                                                                                                                                                                                                                            |
      | shipperSettingNamespace | pickup                                                                                                                                                                                                                                                                                                                      |
      | shipperSettingRequest   | {"address_limit":10,"allow_premium_pickup_on_sunday":true,"allow_standard_pickup_on_sunday":true,"premium_pickup_daily_limit":100,"milk_run_pickup_limit":10,"default_start_time":"09:00","default_end_time":"22:00","service_type_level":[{"type":"Scheduled","level":"Standard"},{"type":"Scheduled","level":"Premium"}]} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {rpm-shipper-id}                                                                                                                                                                                                             |
      | generateAddress       | RANDOM                                                                                                                                                                                                                       |
      | shipperAddressRequest | {"name":"{rpm-shipper-name}","contact":"{rpm-shipper-contact}","email":"{rpm-shipper-email}","milkrun_settings":[{"start_time":"09:00","end_time":"22:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Shipper - Operator update shipper setting using data below:
      | shipperId               | {rpm-shipper-id}                                                                                              |
      | shipperSettingNamespace | order_create                                                                                                  |
      | shipperSettingRequest   | {"same_day_pickup_cutoff_time": "22:00", "pickup_cutoff_time": "22:00", "sunday_pickup_cutoff_time": "22:00"} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{rpm-shipper-id-legacy}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{rpm-shipper-id}"
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{rpm-shipper-id-legacy}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
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
      | shipper | {rpm-shipper-name}                      |
      | group   | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    Then Operator verifies that success toast displayed:
      | top | ^{rpm-shipper-name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator refresh page
    When Operator create route on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP[1].name} |
      | routeDate | {date: 0 days next, yyyy-MM-dd}         |
    And Operator verifies that success toast displayed:
      | top | Routes have been created for all groups! |
    And DB Route - get latest route_logs record for driver id "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}"
    And DB Route - verify route_logs record:
      | legacyId | {KEY_LIST_OF_CREATED_ROUTES[1].legacyId} |
      | driverId | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}       |
      | date     | {date: 0 days next, yyyy-MM-dd}          |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | status   | Routed                                           |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].legacyId}         |

  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Create Route for Pickup Reservation - Route Date = Tomorrow
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                             |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                          |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                       |
      | hub                    | { "displayName": "{hub-name}", "value": {hub-id} }                                                                                                                                                                                                                                                                                                                                                                        |
    And API Shipper - Operator edit shipper value of pickup appointment using below data:
      | shipperId | {rpm-shipper-id} |
      | status    | False            |
    And API Shipper - Operator update shipper setting using data below:
      | shipperId               | {rpm-shipper-id}                                                                                                                                                                                                                                                                                                            |
      | shipperSettingNamespace | pickup                                                                                                                                                                                                                                                                                                                      |
      | shipperSettingRequest   | {"address_limit":10,"allow_premium_pickup_on_sunday":true,"allow_standard_pickup_on_sunday":true,"premium_pickup_daily_limit":100,"milk_run_pickup_limit":10,"default_start_time":"09:00","default_end_time":"22:00","service_type_level":[{"type":"Scheduled","level":"Standard"},{"type":"Scheduled","level":"Premium"}]} |
    And API Shipper - Operator update shipper setting using data below:
      | shipperId               | {rpm-shipper-id}                                                                                              |
      | shipperSettingNamespace | order_create                                                                                                  |
      | shipperSettingRequest   | {"same_day_pickup_cutoff_time": "22:00", "pickup_cutoff_time": "22:00", "sunday_pickup_cutoff_time": "22:00"} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {rpm-shipper-id}                                                                                                                                                                                                             |
      | generateAddress       | RANDOM                                                                                                                                                                                                                       |
      | shipperAddressRequest | {"name":"{rpm-shipper-name}","contact":"{rpm-shipper-contact}","email":"{rpm-shipper-email}","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{rpm-shipper-id-legacy}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{rpm-shipper-id}"
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{rpm-shipper-id-legacy}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
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
      | shipper | {rpm-shipper-name}                      |
      | group   | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    Then Operator verifies that success toast displayed:
      | top | ^{rpm-shipper-name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator refresh page
    When Operator create route on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP[1].name} |
      | routeDate | {date: 1 days next, yyyy-MM-dd}         |
    And Operator verifies that success toast displayed:
      | top | Routes have been created for all groups! |
    And DB Route - get latest route_logs record for driver id "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}"
    And DB Route - verify route_logs record:
      | legacyId | {KEY_LIST_OF_CREATED_ROUTES[1].legacyId} |
      | driverId | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}       |
      | date     | {date: 1 days next, yyyy-MM-dd}          |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | status   | Routed                                           |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].legacyId}         |

  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Unassign a Shipper Milkrun Address from a Milkrun Group
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                             |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                          |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                       |
      | hub                    | { "displayName": "{hub-name}", "value": {hub-id} }                                                                                                                                                                                                                                                                                                                                                                        |
    And API Shipper - Operator edit shipper value of pickup appointment using below data:
      | shipperId | {rpm-shipper-id} |
      | status    | False            |
    And API Shipper - Operator update shipper setting using data below:
      | shipperId               | {rpm-shipper-id}                                                                                                                                                                                                                                                                                                            |
      | shipperSettingNamespace | pickup                                                                                                                                                                                                                                                                                                                      |
      | shipperSettingRequest   | {"address_limit":10,"allow_premium_pickup_on_sunday":true,"allow_standard_pickup_on_sunday":true,"premium_pickup_daily_limit":100,"milk_run_pickup_limit":10,"default_start_time":"09:00","default_end_time":"22:00","service_type_level":[{"type":"Scheduled","level":"Standard"},{"type":"Scheduled","level":"Premium"}]} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {rpm-shipper-id}                                                                                                                                                                                                             |
      | generateAddress       | RANDOM                                                                                                                                                                                                                       |
      | shipperAddressRequest | {"name":"{rpm-shipper-name}","contact":"{rpm-shipper-contact}","email":"{rpm-shipper-email}","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{rpm-shipper-id-legacy}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{rpm-shipper-id}"
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{rpm-shipper-id-legacy}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
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
      | shipper | {rpm-shipper-name}                      |
      | group   | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    Then Operator verifies that success toast displayed:
      | top | ^{rpm-shipper-name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP[1].name} |
    When Operator refresh page
    When Operator go to menu Shipper -> All Shippers
    And Operator unset pickup addresses of the created shipper:
      | shipperName          | {rpm-shipper-name}                         |
      | shipperPickupAddress | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1]} |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator unassign pending task on Reservation Preset Management page:
      | shipper | {rpm-shipper-name} |
    Then Operator verifies that success toast displayed:
      | top | ^{rpm-shipper-name} \(.*\) has been unlink from {KEY_CREATED_RESERVATION_GROUP[1].name} group! |

  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Operator Add Shipper Address To Milkrun Reservation via Upload CSV - Address Has Not Assign to Milkrun and Has Not Added to Milkrun Group
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                             |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                          |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                       |
      | hub                    | { "displayName": "{hub-name}", "value": {hub-id} }                                                                                                                                                                                                                                                                                                                                                                        |
    And API Shipper - Operator edit shipper value of pickup appointment using below data:
      | shipperId | {rpm-shipper-id} |
      | status    | False            |
    And API Shipper - Operator update shipper setting using data below:
      | shipperId               | {rpm-shipper-id}                                                                                                                                                                                                                                                                                                            |
      | shipperSettingNamespace | pickup                                                                                                                                                                                                                                                                                                                      |
      | shipperSettingRequest   | {"address_limit":10,"allow_premium_pickup_on_sunday":true,"allow_standard_pickup_on_sunday":true,"premium_pickup_daily_limit":100,"milk_run_pickup_limit":10,"default_start_time":"09:00","default_end_time":"22:00","service_type_level":[{"type":"Scheduled","level":"Standard"},{"type":"Scheduled","level":"Premium"}]} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {rpm-shipper-id}                                                                                                                        |
      | generateAddress       | RANDOM                                                                                                                                  |
      | shipperAddressRequest | {"name":"{rpm-shipper-name}","contact":"{rpm-shipper-contact}","email":"{rpm-shipper-email}","milkrun_settings":[],"is_milk_run":false} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{rpm-shipper-id-legacy}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{rpm-shipper-id}"
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{rpm-shipper-id-legacy}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
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
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId        | addressId                                     | action | milkrunGroupId                          | days            | startTime | endTime |
      | {rpm-shipper-id} | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} | add    | {KEY_CORE_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And Operator go to menu Shipper -> All Shippers
    And Operator open Edit Shipper Page of shipper "{rpm-shipper-name}"
    Then Operator verify pickup address on Edit Shipper page:
      | shipperId                     | {rpm-shipper-id}                        |
      | shipperPickupAddresses        | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES} |
      | address.1.milkrun.1.startTime | 3PM                                     |
      | address.1.milkrun.1.endTime   | 6PM                                     |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7                           |
