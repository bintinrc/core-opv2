@OperatorV2 @Core @PickUps @ReservationPresetManagement @ReservationPresetManagementPart2
Feature: Reservation Preset Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Operator Download Sample CSV file for Create and Delete Pickup Reservation
    Given Operator go to menu Pick Ups -> Reservation Preset Management
    When Operator downloads sample CSV on Reservation Preset Management page
    Then sample CSV file on Reservation Preset Management page is downloaded successfully

  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Operator Add Shipper Address To Milkrun Reservation via Upload CSV - Address Assign to Milkrun and Has Not Added to Milkrun Group
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
      | driver | ^{KEY_DRIVER_LIST_OF_DRIVERS[1].firstName}.* |
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId        | addressId                                     | action | milkrunGroupId                          | days            | startTime | endTime |
      | {rpm-shipper-id} | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} | add    | {KEY_CORE_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And DB Shipper - verify shipper_addresses record:
      | id        | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} |
      | shipperId | {rpm-shipper-id}                              |
      | isMilkRun | 1                                             |
    And DB Shipper - verify shipper_address_milkrun_settings record:
      | addressId | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} |
      | startTime | 15:00                                         |
      | endTime   | 18:00                                         |
      | days      | [1,2,3,4,5,6,7]                               |

  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Operator Add Shipper Address To Milkrun Reservation via Upload CSV - Address Assign to Milkrun and Added to Milkrun Group
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
      | reservationRequest | {"legacy_shipper_id":{rpm-shipper-id-legacy}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page:
      | name   | {KEY_CREATED_RESERVATION_GROUP[1].name}   |
      | driver | ^{KEY_DRIVER_LIST_OF_DRIVERS[1].firstName}.* |
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {rpm-shipper-name}                      |
      | group   | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    Then Operator verifies that success toast displayed:
      | top | ^{rpm-shipper-name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId        | addressId                                     | action | milkrunGroupId                          | days            | startTime | endTime |
      | {rpm-shipper-id} | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} | add    | {KEY_CORE_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And DB Shipper - verify shipper_addresses record:
      | id        | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} |
      | shipperId | {rpm-shipper-id}                              |
      | isMilkRun | 1                                             |
    And DB Shipper - verify shipper_address_milkrun_settings record:
      | addressId | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} |
      | startTime | 15:00                                         |
      | endTime   | 18:00                                         |
      | days      | [1,2,3,4,5,6,7]                               |

  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Operator Delete Shipper Address To Milkrun Reservation via Upload CSV
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
      | reservationRequest | {"legacy_shipper_id":{rpm-shipper-id-legacy}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page:
      | name   | {KEY_CREATED_RESERVATION_GROUP[1].name}   |
      | driver | ^{KEY_DRIVER_LIST_OF_DRIVERS[1].firstName}.* |
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {rpm-shipper-name}                      |
      | group   | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    Then Operator verifies that success toast displayed:
      | top | ^{rpm-shipper-name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId        | addressId                                     | action | milkrunGroupId                          | days            | startTime | endTime |
      | {rpm-shipper-id} | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} | add    | {KEY_CORE_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId        | addressId                                     | action | milkrunGroupId                          |
      | {rpm-shipper-id} | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} | delete | {KEY_CORE_CREATED_RESERVATION_GROUP_ID} |
    Then Operator verifies that success toast displayed:
      | top | ^Deleted milkruns.* |
    And DB Shipper - verify shipper_addresses record:
      | id        | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} |
      | shipperId | {rpm-shipper-id}                              |
      | isMilkRun | 0                                             |
    And DB Shipper - verify shipper_address_milkrun_settings record does not exist:
      | addressId | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} |

  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Operator Add and Delete Shipper Address To Milkrun Reservation via Upload CSV
    Given API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | { "first_name": "RANDOM_STRING", "last_name": "RANDOM_STRING", "display_name": "RANDOM_STRING", "license_number": "RANDOM_STRING", "driver_type": "DRIVER-TYPE-01", "availability": false, "cod_limit": 100, "max_on_demand_jobs": 1000, "username": "RANDOM_STRING", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id} } |
      | vehicles               | [ { "active": true, "vehicleNo": "{vehicle-no}", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 5 } ]                                                                                                                                                                                                                                                                                             |
      | contacts               | [ { "active": true, "type": "{contact-type-name}", "details": "{contact-no}" } ]                                                                                                                                                                                                                                                                                                                                          |
      | zonePreferences        | [ { "latitude": {zone-latitude}, "longitude": {zone-longitude}, "maxWaypoints": 2, "minWaypoints": 1, "zoneId": {zone-id}, "cost": 5, "rank": 1 } ]                                                                                                                                                                                                                                                                       |
      | hub                    | { "displayName": "{hub-name}", "value": {hub-id} }                                                                                                                                                                                                                                                                                                                                                                        |
    # 1st Shipper and address
    And API Shipper - Operator edit shipper value of pickup appointment using below data:
      | shipperId | {rpm-shipper-id} |
      | status    | False            |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId             | {rpm-shipper-id}                                                                                                                                                                                                             |
      | generateAddress       | RANDOM                                                                                                                                                                                                                       |
      | shipperAddressRequest | {"name":"{rpm-shipper-name}","contact":"{rpm-shipper-contact}","email":"{rpm-shipper-email}","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{rpm-shipper-id-legacy}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{rpm-shipper-id}"
    # 2nd Shipper and address
    And API Shipper - Operator edit shipper value of pickup appointment using below data:
      | shipperId | {rpm-shipper-id-2} |
      | status    | False              |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {rpm-shipper-id-2}                                                                                                                                                                                                                 |
      | generateAddress       | RANDOM                                                                                                                                                                                                                             |
      | shipperAddressRequest | {"name":"{rpm-shipper-name-2}","contact":"{rpm-shipper-contact-2}","email":"{rpm-shipper-email-2}","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{rpm-shipper-id-legacy-2}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{rpm-shipper-id-2}"
    ####
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page:
      | name   | {KEY_CREATED_RESERVATION_GROUP[1].name}   |
      | driver | ^{KEY_DRIVER_LIST_OF_DRIVERS[1].firstName}.* |
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    ###
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId        | addressId                                     | action | milkrunGroupId                          | days            | startTime | endTime |
      | {rpm-shipper-id} | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} | add    | {KEY_CORE_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId          | addressId                                     | action | milkrunGroupId                          | days            | startTime | endTime |
      | {rpm-shipper-id}   | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} | delete | {KEY_CORE_CREATED_RESERVATION_GROUP_ID} |                 |           |         |
      | {rpm-shipper-id-2} | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[2].id} | add    | {KEY_CORE_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    Then Operator verifies that success toast displayed:
      | top | ^Deleted milkruns.* |
    And DB Shipper - verify shipper_addresses record:
      | id        | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} |
      | shipperId | {rpm-shipper-id}                              |
      | isMilkRun | 0                                             |
    And DB Shipper - verify shipper_address_milkrun_settings record does not exist:
      | addressId | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id} |
    And DB Shipper - verify shipper_addresses record:
      | id        | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[2].id} |
      | shipperId | {rpm-shipper-id-2}                            |
      | isMilkRun | 1                                             |
    And DB Shipper - verify shipper_address_milkrun_settings record:
      | addressId | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[2].id} |
      | startTime | 15:00                                         |
      | endTime   | 18:00                                         |
      | days      | [1,2,3,4,5,6,7]                               |

  @DeleteDriverV2 @CancelCreatedReservations @ReservationPresetManagementCleanup @HighPriority
  Scenario: Route Pending Reservations From the Reservation Preset Management Page - Reservation Added to Different Driver Route
    # Create 2 drivers
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}-{{TIMESTAMP}}", "display_name":"{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRI1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-3-day-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}-{{TIMESTAMP}}", "display_name":"{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DRI1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-3-day-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name-2}", "value": {hub-id-2} } } |
    # Create 1 Shipper, 1 Address
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {rpm-shipper-id}                                                                                                                                                                                                             |
      | generateAddress       | RANDOM                                                                                                                                                                                                                       |
      | shipperAddressRequest | {"name":"{rpm-shipper-name}","contact":"{rpm-shipper-contact}","email":"{rpm-shipper-email}","milkrun_settings":[{"start_time":"09:00","end_time":"22:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Shipper - Operator fetch shipper id by legacy shipper id "{rpm-shipper-id-legacy}"
    And API Shipper - Operator get all shipper addresses by shipper global id "{rpm-shipper-id}"
    # Assign shipper address to milkrun group
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                 |
      | driver | {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page:
      | name   | {KEY_CREATED_RESERVATION_GROUP[1].name}   |
      | driver | ^{KEY_DRIVER_LIST_OF_DRIVERS[1].firstName}.* |
      | hub    | {hub-name}                                |
    And API Route - Operator get created Reservation Group params:
      | reservationGroupName | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {rpm-shipper-name}                      |
      | group   | {KEY_CREATED_RESERVATION_GROUP[1].name} |
    Then Operator verifies that success toast displayed:
      | top | ^{rpm-shipper-name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP[1].name} |
    And Operator refresh page
    # Create route from RPM, and get auto created reservation details
    When Operator go to menu Pick Ups -> Reservation Preset Management
    When Operator create route on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP[1].name} |
      | routeDate | {date: 0 days next, yyyy-MM-dd}         |
    Then Operator verifies that success toast displayed:
      | top | Routes have been created for all groups! |
    And Operator refresh page
    And API Core - Operator get reservation using filter with data below:
      | addressId      | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}  |
      | startReadydate | {date: 0 days next, yyyy-MM-dd}T09:00:00+08:00 |
    Then DB Core - verify shipper_pickup_search record:
      | reservationId  | {KEY_LIST_OF_RESERVATIONS[1].id}   |
      | status         | PENDING                            |
      | waypointStatus | Routed                             |
      | routeId        | not null                           |
      | driverId       | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
    And DB Route - get latest route_logs record for driver id "{KEY_DRIVER_LIST_OF_DRIVERS[1].id}"
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_RESERVATIONS[1].waypointId} |
      | status   | Routed                                   |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].legacyId} |
    #  Route 2nd reservation, route it, and force Success using 2nd driver
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{rpm-shipper-id-legacy}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_DRIVER_LIST_OF_DRIVERS[2].id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[2].id}       |
    And API Core - Operator success reservation for id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then DB Core - verify shipper_pickup_search record:
      | reservationId  | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | status         | SUCCESS                                  |
      | waypointStatus | Success                                  |
      | routeId        | {KEY_LIST_OF_CREATED_ROUTES[2].id}       |
      | driverId       | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}       |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_RESERVATIONS[1].waypointId} |
      | status   | Success                                  |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].legacyId} |
    And Operator refresh page
    # Create Route and 3rd Reservation for Tomorrow
    When Operator create route on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP[1].name} |
      | routeDate | {date: 1 days next, yyyy-MM-dd}         |
    Then Operator verifies that success toast displayed:
      | top | Routes have been created for all groups! |
    And Operator refresh page
    And API Core - Operator get reservation using filter with data below:
      | addressId      | {KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}  |
      | startReadydate | {date: 1 days next, yyyy-MM-dd}T09:00:00+08:00 |
    Then DB Core - verify shipper_pickup_search record:
      | reservationId  | {KEY_LIST_OF_RESERVATIONS[3].id}   |
      | status         | PENDING                            |
      | waypointStatus | Routed                             |
      | routeId        | not null                           |
      | driverId       | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
    # Pull out 3rd reservation from route
    And API Core - Operator remove reservation id "{KEY_LIST_OF_RESERVATIONS[3].id}" from route
    Then DB Core - verify shipper_pickup_search record:
      | reservationId  | {KEY_LIST_OF_RESERVATIONS[3].id} |
      | status         | PENDING                          |
      | waypointStatus | Pending                          |
      | routeId        | null                             |
      | driverId       | null                             |
    # Route Pending reservation for tommorow date
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator refresh page
    When Operator route pending reservations on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP[1].name} |
      | routeDate | {date: 1 days next, yyyy-MM-dd}         |
    Then Operator verifies that info toast displayed:
      | top | 1 reservations added to route |
    Then DB Core - verify shipper_pickup_search record:
      | reservationId  | {KEY_LIST_OF_RESERVATIONS[3].id}   |
      | status         | PENDING                            |
      | waypointStatus | Routed                             |
      | routeId        | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | driverId       | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_RESERVATIONS[3].waypointId} |
      | status   | Routed                                   |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].legacyId} |