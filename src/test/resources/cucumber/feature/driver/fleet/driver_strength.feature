@OperatorV2 @Driver @Fleet @DriverStrengthV2
Feature: Driver Strength

  Background:
    When Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverType
  Scenario: Create New Driver Account
    Given Operator loads Operator portal home page
    And API Operator create new driver type with the following attributes:
      | driverTypeRequest | { "driverType": { "name": "DT-{gradle-current-date-yyyyMMddHHmmsss}"} } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator create new Driver on Driver Strength page using data below:
      | displayName          | GENERATED                                                        |
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 100                                                              |
      | hub                  | {hub-name}                                                       |
      | employmentStartDate  | {gradle-current-date-yyyy-MM-dd}                                 |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleType          | Car                                                              |
      | vehicleCapacity      | 100                                                              |
      | contactType          | {contact-type-name}                                              |
      | contact              | GENERATED                                                        |
      | zoneId               | {zone-name-2}                                                    |
      | zoneMin              | 1                                                                |
      | zoneMax              | 2                                                                |
      | zoneCost             | 1                                                                |
      | username             | GENERATED                                                        |
      | password             | GENERATED                                                        |
      | comments             | This driver is created by "Automation Test" for testing purpose. |
    And DB Operator get data of created driver
    And Operator load all data for driver on Driver Strength Page
    Then Operator verify driver strength params of created driver on Driver Strength page
    When Operator delete created driver on Driver Strength page

  @DeleteDriverV2
  Scenario: Update Driver Account
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    When Operator edit created Driver on Driver Strength page using data below:
      | displayName          | GENERATED                                                        |
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 200                                                              |
      | vehicleType          | Car                                                              |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleCapacity      | 200                                                              |
      | contact              | GENERATED                                                        |
      | zoneId               | {zone-name-2}                                                    |
      | zoneMin              | 2                                                                |
      | zoneMax              | 3                                                                |
      | zoneCost             | 2                                                                |
      | password             | GENERATED                                                        |
      | comments             | This driver is UPDATED by "Automation Test" for testing purpose. |
    Then Operator verifies that success notification displayed in Driver Strength:
      | title | Driver Updated                 |
      | desc  | Driver {KEY_CREATED_DRIVER_ID} |
    And Operator filter driver strength using data below:
      | zones       | {zone-name-2}      |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    And Operator wait until table loaded
    And Operator verify driver strength params of created driver on Driver Strength page

  Scenario Outline: Create New Driver Account with DPMS ID
    Given Operator loads Operator portal home page
    When Operator go to menu Fleet -> Driver Strength
    And Operator create new Driver on Driver Strength page using data below:
      | displayName          | GENERATED                                                        |
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | type                 | <DriverType>                                                     |
      | dpmsId               | <DpmsId>                                                         |
      | codLimit             | 100                                                              |
      | hub                  | {hub-name}                                                       |
      | employmentStartDate  | {gradle-current-date-yyyy-MM-dd}                                 |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleType          | <VehicleType>                                                    |
      | vehicleCapacity      | 100                                                              |
      | contactType          | {contact-type-name}                                              |
      | contact              | GENERATED                                                        |
      | zoneId               | {zone-name-2}                                                    |
      | zoneMin              | 1                                                                |
      | zoneMax              | 2                                                                |
      | zoneCost             | 1                                                                |
      | username             | GENERATED                                                        |
      | password             | GENERATED                                                        |
      | comments             | This driver is created by "Automation Test" for testing purpose. |
    And DB Operator get data of created driver
    And Operator load all data for driver on Driver Strength Page
    Then Operator verify driver strength params of created driver on Driver Strength page
    And DB Operator verifies that 1 row is added for the change type: "<ChangeType1>" in account_audit_logs table in driver db
    And DB Operator verifies that 1 row is added for the change type: "<ChangeType2>" in account_audit_logs table in driver db
    And Operator delete created driver on Driver Strength page

    Examples:
      | DriverType    | VehicleType | DpmsId    | ChangeType1 | ChangeType2 |
      | Mitra - Fleet | Car         | GENERATED | CREATE      | UPDATE      |

  @DeleteDriverType
  Scenario: Can Not Create New Driver Account Without Active Vehicle
    Given Operator loads Operator portal home page
    And API Operator create new driver type with the following attributes:
      | driverTypeRequest | { "driverType": { "name": "DT-{gradle-current-date-yyyyMMddHHmmsss}"} } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator opens Add Driver dialog on Driver Strength
    And Operator fill Add Driver form on Driver Strength page using data below:
      | displayName         | GENERATED                                                        |
      | firstName           | GENERATED                                                        |
      | lastName            | GENERATED                                                        |
      | licenseNumber       | GENERATED                                                        |
      | codLimit            | 100                                                              |
      | hub                 | {hub-name}                                                       |
      | employmentStartDate | {gradle-current-date-yyyy-MM-dd}                                 |
      | contactType         | {contact-type-name}                                              |
      | contact             | GENERATED                                                        |
      | zoneId              | {zone-name}                                                      |
      | zoneMin             | 1                                                                |
      | zoneMax             | 1                                                                |
      | zoneCost            | 1                                                                |
      | username            | GENERATED                                                        |
      | password            | GENERATED                                                        |
      | comments            | This driver is created by "Automation Test" for testing purpose. |
    Then Operator click Submit button in Add Driver dialog
    And Operator verifies error message "Vehicle Type is required" is displayed in Driver dialog
    And Operator verifies error message "Vehicle No. is required." is displayed in Driver dialog
    And Operator verifies error message "Capacity is required." is displayed in Driver dialog

  @DeleteDriverType
  Scenario: Can Not Create New Driver Account Without Preferred Zone and Capacity
    Given Operator loads Operator portal home page
    And API Operator create new driver type with the following attributes:
      | driverTypeRequest | { "driverType": { "name": "DT-{gradle-current-date-yyyyMMddHHmmsss}"} } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator opens Add Driver dialog on Driver Strength
    And Operator fill Add Driver form on Driver Strength page using data below:
      | displayName          | GENERATED                                                        |
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 100                                                              |
      | hub                  | {hub-name}                                                       |
      | employmentStartDate  | {gradle-current-date-yyyy-MM-dd}                                 |
      | vehicleType          | Car                                                              |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleCapacity      | 100                                                              |
      | contactType          | {contact-type-name}                                              |
      | contact              | GENERATED                                                        |
      | username             | GENERATED                                                        |
      | password             | GENERATED                                                        |
      | comments             | This driver is created by "Automation Test" for testing purpose. |
    Then Operator click Submit button in Add Driver dialog
    And Operator verifies error message "Zone is required." is displayed in Driver dialog
    And Operator verifies error message "Min is required." is displayed in Driver dialog
    And Operator verifies error message "Max is required." is displayed in Driver dialog
    And Operator verifies error message "Cost is required." is displayed in Driver dialog

  @DeleteDriverV2
  Scenario: Can Not Update Driver Account Without Active Vehicle
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator load all data for driver on Driver Strength Page
    And Operator opens Edit Driver dialog for created driver on Driver Strength page
    And  Operator removes vehicle details on Edit Driver dialog on Driver Strength page
    And Operator click Submit button in Add Driver dialog
    And Operator verifies error message "Vehicle No. is required." is displayed in Driver dialog

  @DeleteDriverV2
  Scenario: Can Not Update Driver Account Without Preferred Zone and Capacity
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator load all data for driver on Driver Strength Page
    And Operator opens Edit Driver dialog for created driver on Driver Strength page
    And Operator removes zone preferences on Edit Driver dialog on Driver Strength page
    And Operator click Submit button in Add Driver dialog
    And Operator verifies error message "zonePreferences.minWaypoints" is displayed in Driver dialog
    And Operator verifies error message "zonePreferences.maxWaypoints" is displayed in Driver dialog
    And Operator verifies error message "zonePreferences.cost" is displayed in Driver dialog

  @DeleteDriverType
  Scenario: Can Not Create New Driver Account Without Active Contact
    Given Operator loads Operator portal home page
    And API Operator create new driver type with the following attributes:
      | driverTypeRequest | { "driverType": { "name": "DT-{gradle-current-date-yyyyMMddHHmmsss}"} } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator opens Add Driver dialog on Driver Strength
    And Operator fill Add Driver form on Driver Strength page using data below:
      | displayName          | GENERATED                                                        |
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 100                                                              |
      | hub                  | {hub-name}                                                       |
      | employmentStartDate  | {gradle-current-date-yyyy-MM-dd}                                 |
      | vehicleType          | Car                                                              |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleCapacity      | 100                                                              |
      | zoneId               | {zone-name}                                                      |
      | zoneMin              | 1                                                                |
      | zoneMax              | 1                                                                |
      | zoneCost             | 1                                                                |
      | username             | GENERATED                                                        |
      | password             | GENERATED                                                        |
      | comments             | This driver is created by "Automation Test" for testing purpose. |
    And Operator click Submit button in Add Driver dialog
    And Operator verifies error message "Mobile Phone is required." is displayed in Driver dialog

  @DeleteDriverV2
  Scenario: Create New Driver Account and Verify Contact Detail is Correct
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    When API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator load all data for driver on Driver Strength Page
    And Operator wait until table loaded
    Then Operator verify contact details of created driver on Driver Strength page

  Scenario: Delete Driver Account (uid:4cdc0535-7095-463e-87da-ea108e500644)
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator load all data for driver on Driver Strength Page
    When Operator delete created driver on Driver Strength page
    Then Operator verify new driver is deleted successfully on Driver Strength page

  @DeleteDriverV2
  Scenario: Operator Should Be Able to Change The 'Coming' Value (uid:32abe41c-49be-4d54-8f11-3891bcd81afb)
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator load all data for driver on Driver Strength Page
    And Operator wait until table loaded
    When Operator change Coming value for created driver on Driver Strength page
    Then Operator verify Coming value for created driver has been changed on Driver Strength page

  @DeleteDriverV2
  Scenario: Filter Driver Account by Zones (uid:fa20ebea-5a9c-43bb-88ad-a93aa94ef18f)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And  Operator filter driver strength using data below:
      | zones | {zone-name} |
    And Operator wait until table loaded
    Then Operator verify driver strength is filtered by "{zone-name}" zone

  @DeleteDriverV2
  Scenario: Filter Driver Account by Driver Types (uid:74653b45-cba6-464b-a874-e9ddbc9759bb)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | driverTypes | {driver-type-name} |
    And Operator wait until table loaded
    Then Operator verify driver strength is filtered by "{driver-type-name}" driver type

  @DeleteDriverV2
  Scenario: Filter Driver Account by Resigned - Yes (uid:aa65bb50-5bd7-44e7-87cd-8621953e95f6)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | resigned | Yes |
    And Operator wait until table loaded
    Then Operator verify driver strength is filtered by "Yes" resigned

  @DeleteDriverV2
  Scenario: Filter Driver Account by Resigned - No (uid:d587886b-6721-4b48-9e5d-749a0d0eed22)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | resigned | No |
    And Operator wait until table loaded
    Then Operator verify driver strength is filtered by "No" resigned

  @DeleteDriverV2
  Scenario: Filter Driver Account by Driver Zones, Driver Types, and Resigned - Yes (uid:dd1e88b6-ecd4-410c-a1f4-0d7cf468f3cd)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | Yes                |
    And Operator wait until table loaded
    Then Operator verify driver strength is filtered by "{zone-name}" zone
    And Operator verify driver strength is filtered by "{driver-type-name}" driver type
    And Operator verify driver strength is filtered by "Yes" resigned

  @DeleteDriverV2
  Scenario: Filter Driver Account by Driver Types, Zones, and Resigned - No (uid:3227cea9-887f-47df-b403-de16558eaf68)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    And Operator wait until table loaded
    Then Operator verify driver strength is filtered by "{zone-name}" zone
    Then Operator verify driver strength is filtered by "{driver-type-name}" driver type
    Then Operator verify driver strength is filtered by "No" resigned

  @DeleteDriverV2
  Scenario: Filter Driver Account by Edit Search Filter after Load Driver without using Search Filter first (uid:1083c42d-5fcb-4e08-a838-0072a7e1e36f)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator load all data for driver on Driver Strength Page
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    And Operator wait until table loaded
    Then Operator verify driver strength is filtered by "{zone-name}" zone
    And Operator verify driver strength is filtered by "{driver-type-name}" driver type
    And Operator verify driver strength is filtered by "No" resigned

  @DeleteDriverV2
  Scenario: Filter Driver Account by Edit Search Filter after Load Driver with using Search Filter first (uid:481ba3a2-07a5-4156-ae14-8bae483d0773)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | zones       | {zone-name-2}        |
      | driverTypes | {driver-type-name-2} |
      | resigned    | Yes                  |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    And Operator wait until table loaded
    Then Operator verify driver strength is filtered by "{zone-name}" zone
    And Operator verify driver strength is filtered by "{driver-type-name}" driver type
        #To be unlocked when slide/horizontal scroll action is solved on react page
    And Operator verify driver strength is filtered by "No" resigned

  @DeleteDriverV2
  Scenario: Can Not Update Driver Account Without Active Contact (uid:d2db97f9-190d-4b03-8bb5-249fd1bf60c5)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator load all data for driver on Driver Strength Page
    And Operator opens Edit Driver dialog for created driver on Driver Strength page
    And  Operator removes contact details on Edit Driver dialog on Driver Strength page
    And  Operator click Submit button in Update Driver dialog
    Then Operator verifies hint "At least one contact required." is displayed in Add Driver dialog

  Scenario Outline: Update DPMS ID of Driver Account with DPMS ID (uid:6efb7bbd-58b8-4218-9a92-48804bb3a43a)
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "<DriverType>", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}  |
      | driverTypes | <DriverType> |
      | resigned    | No           |
    When Operator edit created Driver on Driver Strength page using data below:
      | firstName | GENERATED                                                        |
      | lastName  | GENERATED                                                        |
      | dpmsId    | <DpmsId>                                                         |
      | password  | GENERATED                                                        |
      | comments  | This driver is UPDATED by "Automation Test" for testing purpose. |
    And DB Operator get data of created driver
    And Operator load all data for driver on Driver Strength Page
    Then Operator verify driver strength params of created driver on Driver Strength page
    And DB Operator verifies that 2 rows are added for the change type: "<ChangeType2>" in account_audit_logs table in driver db
    And Operator delete created driver on Driver Strength page

    Examples:
      | DriverType    | DpmsId    | ChangeType2 |
      | Mitra - Fleet | GENERATED | UPDATE      |

  Scenario Outline: View DPMS ID of Driver Account with DPMS ID (uid:50a6e582-fb8a-4327-a0db-18689faba0db)
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "<DriverType>", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}  |
      | driverTypes | <DriverType> |
      | resigned    | No           |
    Then Operator verifies that the column: "DPMS ID" displays between the columns: "Type" and "Vehicle"
    And Operator delete created driver on Driver Strength page

    Examples:
      | DriverType    |
      | Mitra - Fleet |

  @DeleteDriverType
  Scenario Outline: Can Not Create New Driver Account with Invalid Phone Number (uid:5012477c-39d3-419b-8aee-f6201203ef99)
    Given Operator loads Operator portal home page
    And API Operator create new driver type with the following attributes:
      | driverTypeRequest | { "driverType": { "name": "DT-{gradle-current-date-yyyyMMddHHmmsss}"} } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator opens Add Driver dialog on Driver Strength
    And Operator fill Add Driver form on Driver Strength page using data below:
      | displayName          | GENERATED                                                        |
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 100                                                              |
      | hub                  | {hub-name}                                                       |
      | employmentStartDate  | {gradle-current-date-yyyy-MM-dd}                                 |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleType          | <VehicleType>                                                    |
      | vehicleCapacity      | 100                                                              |
      | contactType          | {contact-type-name}                                              |
      | contact              | <ContactNumber>                                                  |
      | zoneId               | {zone-name-2}                                                    |
      | zoneMin              | 1                                                                |
      | zoneMax              | 1                                                                |
      | zoneCost             | 1                                                                |
      | username             | GENERATED                                                        |
      | password             | GENERATED                                                        |
      | comments             | This driver is created by "Automation Test" for testing purpose. |
    Then Operator click Submit button in Add Driver dialog
    And Operator verifies hint "<ErrorMessage>" is displayed in Add Driver dialog

    Examples:
      | VehicleType | ContactNumber    | ErrorMessage                                              |
      | Car         | 3159432900000000 | Please input a valid mobile phone number (e.g. 8123 4567) |

  @DeleteDriverType @DeleteDriverV2
  Scenario Outline: Can Not Update Driver Account with Invalid Phone Number (uid:1d5d6d06-3bc5-4a19-91f9-1a7e892f8bc6)
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new driver type with the following attributes:
      | driverTypeRequest | { "driverType": { "name": "DT-{gradle-current-date-yyyyMMddHHmmsss}" } } |
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{KEY_CREATED_DRIVER_TYPE_NAME}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}                    |
      | driverTypes | {KEY_CREATED_DRIVER_TYPE_NAME} |
      | resigned    | No                             |
    When Operator updates created Driver on Driver Strength page using data below:
      | firstName            | GENERATED                                                        |
      | lastName             | GENERATED                                                        |
      | licenseNumber        | GENERATED                                                        |
      | codLimit             | 200                                                              |
      | vehicleLicenseNumber | GENERATED                                                        |
      | vehicleCapacity      | 200                                                              |
      | contact              | <ContactNumber>                                                  |
      | zoneId               | {zone-name-2}                                                    |
      | zoneMin              | 2                                                                |
      | zoneMax              | 2                                                                |
      | zoneCost             | 2                                                                |
      | password             | GENERATED                                                        |
      | comments             | This driver is UPDATED by "Automation Test" for testing purpose. |
    Then Operator click Submit button in Edit Driver dialog
    And Operator verifies hint "<ErrorMessage>" is displayed in Edit Driver dialog

    Examples:
      | ContactNumber    | ErrorMessage                                              |
      | 3159432900000000 | Please input a valid mobile phone number (e.g. 8123 4567) |

  @DeleteDriverType @DeleteDriverV2
  Scenario Outline: Download All Shown CSV (uid:58a58dac-b1f6-49ab-8b69-f8db23934f4c)
    Given Operator loads Operator portal home page
    And API Operator create new driver type with the following attributes:
      | driverTypeRequest | { "driverType": { "name": "DT-{gradle-current-date-yyyyMMddHHmmsss}" } } |
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{KEY_CREATED_DRIVER_TYPE_NAME}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    Then Operator verifies that the following buttons are displayed in driver strength page
      | Select Search Filters |
      | Update Driver Details |
      | Add New Driver        |
      | Clear Selection       |
      | Load Selection        |
    And Operator filter driver strength using data below:
      | driverTypes | {KEY_CREATED_DRIVER_TYPE_NAME} |
      | resigned    | <Resigned>                     |
    And Operator load all data for driver on Driver Strength Page
    And Operator verifies that the selected driver details can be downloaded with the file name: "<FileName>"
    And Operator verifies that the content in the downloaded csv file matches with the result displayed

    Examples:
      | FileName       | Resigned |
      | NV Drivers.csv | No       |

  @CleanDownloadFolder
  Scenario Outline: Download All to Update Prefilled Template (uid:23f6d92f-eb4b-41ea-a6f5-47a5e5840335)
    Given Operator go to menu Fleet -> Driver Strength
    When Operator filter driver strength using data below:
      | zones    | {zone-name} |
      | resigned | <Resigned>  |
    Then Operator verifies that the following buttons are displayed in driver strength page
      | Select Search Filters |
      | Update Driver Details |
      | Add New Driver        |
      | Clear Selection       |
      | Load Selection        |
    And Operator load all data for driver on Driver Strength Page
    And Operator verifies that the following options are displayed on clicking hamburger icon
      | Download all to update      |
      | Download selected to update |
    And Operator verifies that the file name: "<FileName>" can be downloaded on clicking the option: "<DownloadOption>"
    And Operator verifies that the following content displayed on the downloaded csv file: "<FileName>"
      | Driver ID             |
      | Driver Name           |
      | Driver Type           |
      | Driver Hub ID         |
      | Employment Start Date |
      | Employment End Date   |

    Examples:
      | FileName                                                                      | Resigned | DownloadOption         |
      | update_driver_details_{gradle-current-date-yyyy-MM-dd}_prefilled_template.csv | No       | Download all to update |

  @DeleteDriverType @DeleteDriverV2 @CleanDownloadFolder
  Scenario Outline: Download Selected to Update Prefilled Template (uid:13e78371-2b98-4f2c-8155-29f1dfd8d311)
    Given Operator loads Operator portal home page
    And API Operator create new driver type with the following attributes:
      | driverTypeRequest | { "driverType": { "name": "DT-{gradle-current-date-yyyyMMddHHmmsss}"} } |
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{KEY_CREATED_DRIVER_TYPE_NAME}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator verifies that the following buttons are displayed in driver strength page
      | Select Search Filters |
      | Update Driver Details |
      | Add New Driver        |
      | Clear Selection       |
      | Load Selection        |
    And Operator filter driver strength using data below:
      | driverTypes | {KEY_CREATED_DRIVER_TYPE_NAME} |
      | resigned    | <Resigned>                     |
    And Operator load all data for driver on Driver Strength Page
    Then Operator selects the records that are displayed in the result grid
    And Operator verifies that the following options are displayed on clicking hamburger icon
      | Download all to update      |
      | Download selected to update |
    And Operator verifies that the file name: "<FileName>" can be downloaded on clicking the option: "<DownloadOption>"
    And Operator verifies that the following content displayed on the downloaded csv file: "<FileName>"
      | Driver ID             |
      | Driver Name           |
      | Driver Type           |
      | Driver Hub ID         |
      | Employment Start Date |
      | Employment End Date   |

    Examples:
      | FileName                                                                      | Resigned | DownloadOption              |
      | update_driver_details_{gradle-current-date-yyyy-MM-dd}_prefilled_template.csv | No       | Download selected to update |

  Scenario Outline: Successfully Upload CSV for Bulk Update Drivers (uid:794ea7e6-ed1a-4fda-88fa-18c900eed07b)
    Given Operator loads Operator portal home page
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | resigned | <Resigned> |
    And Operator load all data for driver on Driver Strength Page
    Then Operator verifies that the following buttons are displayed in driver strength page
      | Select Search Filters |
      | Update Driver Details |
      | Add New Driver        |
      | Clear Selection       |
      | Load Selection        |
    And Operator verifies that the following UI elements are displayed in update driver modal up
      | Bulk update driver details by uploading CSV file. |
      | Download CSV Template                             |
      | Drag and drop CSV file here                       |
    And Operator uploads csv file: "<FileName>" to bulk update the driver details
    And Operator verifies that the notice message: "<Message>" is displayed

    Examples:
      | Resigned | FileName                              | Message                                 |
      | No       | {update_driver_details_prefilled_csv} | Successfully updated 1 drivers' details |

  Scenario Outline: Cannot Upload Non-CSV File for Bulk Update Drivers (uid:b675717c-bcd5-4fa2-9db0-f8057ba7c0f0)
    Given Operator loads Operator portal home page
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | resigned | <Resigned> |
    And Operator load all data for driver on Driver Strength Page
    Then Operator verifies that the following buttons are displayed in driver strength page
      | Select Search Filters |
      | Update Driver Details |
      | Add New Driver        |
      | Clear Selection       |
      | Load Selection        |
    And Operator verifies that the following UI elements are displayed in update driver modal up
      | Bulk update driver details by uploading CSV file. |
      | Download CSV Template                             |
      | Drag and drop CSV file here                       |
    And Operator uploads csv file: "<FileName>" to bulk update the driver details
    And Operator verifies that the notice message: "<Message>" is displayed

    Examples:
      | Resigned | FileName                                       | Message                                              |
      | No       | {update_driver_details_prefilled_xlsx_invalid} | Invalid file upload! Please upload a valid CSV file. |

  Scenario Outline: Cannot Bulk Update More than 200 Drivers (uid:0838cfce-c768-4d84-822e-d0a13781bdb9)
    Given Operator loads Operator portal home page
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | resigned | <Resigned> |
    And Operator load all data for driver on Driver Strength Page
    Then Operator verifies that the following buttons are displayed in driver strength page
      | Select Search Filters |
      | Update Driver Details |
      | Add New Driver        |
      | Clear Selection       |
      | Load Selection        |
    And Operator verifies that the following UI elements are displayed in update driver modal up
      | Bulk update driver details by uploading CSV file. |
      | Download CSV Template                             |
      | Drag and drop CSV file here                       |
    And Operator uploads csv file: "<FileName>" to bulk update the driver details
    And Operator verifies that the alert message: "<Message>" is displayed

    Examples:
      | Resigned | FileName                                                   | Message                                                                                           |
      | No       | {update_driver_details_prefilled_csv_2000_records_invalid} | You have exceeded the maximum no. of rows in a file upload. Please upload 200 accounts at a time. |

  @CleanDownloadFolder
  Scenario Outline: Download Failure Reason of Failed Updated Driver
    Given Operator loads Operator portal home page
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | resigned | <Resigned> |
    And Operator load all data for driver on Driver Strength Page
    Then Operator verifies that the following buttons are displayed in driver strength page
      | Select Search Filters |
      | Update Driver Details |
      | Add New Driver        |
      | Clear Selection       |
      | Load Selection        |
    And Operator verifies that the following UI elements are displayed in update driver modal up
      | Bulk update driver details by uploading CSV file. |
      | Download CSV Template                             |
      | Drag and drop CSV file here                       |
    And Operator uploads csv file: "<FileName>" to bulk update the driver details
    And Operator verifies that the following UI element is displayed in update driver modal up
      | The list of drivers' details were not successfully updated. Please download the list and failure reasons to troubleshoot. |
    And Operator verifies that the failure reasons can be downloaded with file name: "<ErrorFileName>"
    And Operator verifies that the following content displayed on the downloaded csv file: "<ErrorFileName>"
      | Driver ID             |
      | Driver Name           |
      | Driver Type           |
      | Driver Hub ID         |
      | Employment Start Date |
      | Employment End Date   |
      | **Error Message       |
    And Operator verifies that the following content displayed on the downloaded csv file: "<ErrorFileName>"
      | Invalid hub ID |

    Examples:
      | Resigned | FileName                                           | ErrorFileName                                                        |
      | No       | {update_driver_details_prefilled_csv_data_invalid} | update_driver_details_{gradle-current-date-yyyy-MM-dd}_error_log.csv |

  @DeleteDriverType @DeleteDriverV2 @CleanDownloadFolder
  Scenario Outline: Filter by Hub and Download Selected to Update Prefilled Template (uid:c59656e9-b10c-4233-a9d9-dbf3867eb704)
    Given Operator loads Operator portal home page
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | hubs     | <HubName>  |
      | resigned | <Resigned> |
    And Operator load all data for driver on Driver Strength Page
    And Operator verifies that the following buttons are displayed in driver strength page
      | Select Search Filters |
      | Update Driver Details |
      | Add New Driver        |
      | Clear Selection       |
      | Load Selection        |
    Then Operator selects the records that are displayed in the result grid
    And Operator verifies that the following options are displayed on clicking hamburger icon
      | Download all to update      |
      | Download selected to update |
    And Operator verifies that the file name: "<FileName>" can be downloaded on clicking the option: "<DownloadOption>"
    And Operator verifies that the following content displayed on the downloaded csv file: "<FileName>"
      | Driver ID             |
      | Driver Name           |
      | Driver Type           |
      | Driver Hub ID         |
      | Employment Start Date |
      | Employment End Date   |
    And Operator verifies that the following content displayed on the downloaded csv file: "<FileName>"
      | <HubId> |

    Examples:
      | HubName    | HubId    | Resigned | DownloadOption              | FileName                                                                      |
      | {hub-name} | {hub-id} | No       | Download selected to update | update_driver_details_{gradle-current-date-yyyy-MM-dd}_prefilled_template.csv |

  @DeleteDriverType @DeleteDriverV2 @CleanDownloadFolder
  Scenario Outline: Filter by Type and Download Selected to Update Prefilled Template (uid:ea4229de-2a3a-49e0-94d8-94b2cb87ebad)
    Given Operator loads Operator portal home page
    And API Operator create new driver type with the following attributes:
      | driverTypeRequest | { "driverType": { "name": "DT-{gradle-current-date-yyyyMMddHHmmsss}"} } |
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{KEY_CREATED_DRIVER_TYPE_NAME}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | driverTypes | {KEY_CREATED_DRIVER_TYPE_NAME} |
      | resigned    | <Resigned>                     |
    And Operator load all data for driver on Driver Strength Page
    And Operator verifies that the following buttons are displayed in driver strength page
      | Select Search Filters |
      | Update Driver Details |
      | Add New Driver        |
      | Clear Selection       |
      | Load Selection        |
    Then Operator selects the records that are displayed in the result grid
    And Operator verifies that the following options are displayed on clicking hamburger icon
      | Download all to update      |
      | Download selected to update |
    And Operator verifies that the file name: "<FileName>" can be downloaded on clicking the option: "<DownloadOption>"
    And Operator verifies that the following content displayed on the downloaded csv file: "<FileName>"
      | Driver ID             |
      | Driver Name           |
      | Driver Type           |
      | Driver Hub ID         |
      | Employment Start Date |
      | Employment End Date   |
    And Operator verifies that the following content displayed on the downloaded csv file: "<FileName>"
      | {KEY_CREATED_DRIVER_TYPE_NAME} |

    Examples:
      | Resigned | DownloadOption              | FileName                                                                      |
      | No       | Download selected to update | update_driver_details_{gradle-current-date-yyyy-MM-dd}_prefilled_template.csv |

  @CleanDownloadFolder
  Scenario Outline: Download Empty CSV (uid:9356160e-bfb4-4b55-9cc9-a869577f81f7)
    Given Operator loads Operator portal home page
    When Operator go to menu Fleet -> Driver Strength
    And Operator filter driver strength using data below:
      | resigned | <Resigned> |
    And Operator load all data for driver on Driver Strength Page
    Then Operator verifies that the following buttons are displayed in driver strength page
      | Select Search Filters |
      | Update Driver Details |
      | Add New Driver        |
      | Clear Selection       |
      | Load Selection        |
    And Operator verifies that the following UI elements are displayed in update driver modal up
      | Bulk update driver details by uploading CSV file. |
      | Download CSV Template                             |
      | Drag and drop CSV file here                       |
    And Operator verifies that the template for updating driver details can be downloaded with the file name: "<FileName>"
    And Operator verifies that the following content displayed on the downloaded csv file: "<FileName>"
      | Driver ID             |
      | Driver Name           |
      | Driver Type           |
      | Driver Hub ID         |
      | Employment Start Date |
      | Employment End Date   |
    And Operator verifies that the following content displayed on the downloaded csv file: "<FileName>"
      | 0                                                                           |
      | [Sample] Driver First Name - 255 character limit                            |
      | [Sample] Driver Type - Please make sure type exists and check spelling      |
      | [Sample] Hub ID - Please make sure hub exists on Facilities Management Page |
      | YYYY-MM-DD                                                                  |
      | YYYY-MM-DD                                                                  |
      | This is a sample row. Please delete row before using template               |

    Examples:
      | Resigned | FileName                                 |
      | No       | update_driver_details_blank_template.csv |

  @DeleteDriverV2
  Scenario: Verify Driver Contacts When Updating Drivers if Number has Never Been Verified
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    When Operator edit created Driver on Driver Strength page using data below:
      | displayName          | {KEY_CREATED_DRIVER.displayName}                                 |
      | firstName            | {KEY_CREATED_DRIVER.firstName}                                   |
      | lastName             | {KEY_CREATED_DRIVER.lastName}                                    |
      | licenseNumber        | {KEY_CREATED_DRIVER.licenseNumber}                               |
      | codLimit             | {KEY_CREATED_DRIVER.codLimit}                                    |
      | vehicleType          | Car                                                              |
      | vehicleLicenseNumber | {KEY_CREATED_DRIVER.licenseNumber}                               |
      | vehicleCapacity      | {KEY_CREATED_DRIVER.vehicles[1].capacity}                        |
      | contact              | GENERATED                                                        |
      | zoneId               | {zone-name-2}                                                    |
      | zoneMin              | 1                                                                |
      | zoneMax              | 2                                                                |
      | zoneCost             | 5                                                                |
      | password             | GENERATED                                                        |
      | comments             | This driver is UPDATED by "Automation Test" for testing purpose. |
    Then Operator verifies that success notification displayed in Driver Strength:
      | title | Driver Updated                 |
      | desc  | Driver {KEY_CREATED_DRIVER_ID} |
    Then Operator verify contact details of created driver on Driver Strength page
    And Operator verify contact details already verified on Driver Strength page

  @DeleteDriverV2
  Scenario: Verify Driver Contacts When Updating Drivers Phone Number if Previous Number has been Verified
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator verify driver contact detail in Driver Strength
      | driverId | {KEY_CREATED_DRIVER_ID} |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    When Operator edit created Driver on Driver Strength page using data below:
      | displayName          | {KEY_CREATED_DRIVER.displayName}                                 |
      | firstName            | {KEY_CREATED_DRIVER.firstName}                                   |
      | lastName             | {KEY_CREATED_DRIVER.lastName}                                    |
      | licenseNumber        | {KEY_CREATED_DRIVER.licenseNumber}                               |
      | codLimit             | {KEY_CREATED_DRIVER.codLimit}                                    |
      | vehicleType          | Car                                                              |
      | vehicleLicenseNumber | {KEY_CREATED_DRIVER.licenseNumber}                               |
      | vehicleCapacity      | {KEY_CREATED_DRIVER.vehicles[1].capacity}                        |
      | zoneId               | {zone-name-2}                                                    |
      | zoneMin              | 1                                                                |
      | zoneMax              | 2                                                                |
      | zoneCost             | 5                                                                |
      | password             | GENERATED                                                        |
      | comments             | This driver is UPDATED by "Automation Test" for testing purpose. |
    Then Operator verifies that success notification displayed in Driver Strength:
      | title | Driver Updated                 |
      | desc  | Driver {KEY_CREATED_DRIVER_ID} |
    Then Operator verify contact details of created driver on Driver Strength page
    And Operator verify contact details already verified on Driver Strength page

  @DeleteDriverV2
  Scenario: Update Drivers Details without Verify the Phone Number
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    When Operator edit created Driver on Driver Strength page using data below:
      | displayName          | {KEY_CREATED_DRIVER.displayName}                                 |
      | firstName            | {KEY_CREATED_DRIVER.firstName}                                   |
      | lastName             | {KEY_CREATED_DRIVER.lastName}                                    |
      | licenseNumber        | {KEY_CREATED_DRIVER.licenseNumber}                               |
      | codLimit             | {KEY_CREATED_DRIVER.codLimit}                                    |
      | vehicleType          | Car                                                              |
      | vehicleLicenseNumber | {KEY_CREATED_DRIVER.licenseNumber}                               |
      | vehicleCapacity      | {KEY_CREATED_DRIVER.vehicles[1].capacity}                        |
      | zoneId               | {zone-name-2}                                                    |
      | zoneMin              | 1                                                                |
      | zoneMax              | 2                                                                |
      | zoneCost             | 5                                                                |
      | password             | GENERATED                                                        |
      | comments             | This driver is UPDATED by "Automation Test" for testing purpose. |
      | contact              | GENERATED                                                        |
      | isVerified           | false                                                            |
    And Operator verifies error message "Please verify the mobile phone number." is displayed in Driver dialog

  @DeleteDriverV2
  Scenario: Can Not Update Driver Contacts Without Verify the Phone Number if Previous Number has been Verified
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Strength
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    And Operator verify driver contact detail in Driver Strength
      | driverId | {KEY_CREATED_DRIVER_ID} |
    And Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
      | resigned    | No                 |
    When Operator edit created Driver on Driver Strength page using data below:
      | displayName          | {KEY_CREATED_DRIVER.displayName}                                 |
      | firstName            | {KEY_CREATED_DRIVER.firstName}                                   |
      | lastName             | {KEY_CREATED_DRIVER.lastName}                                    |
      | licenseNumber        | {KEY_CREATED_DRIVER.licenseNumber}                               |
      | codLimit             | {KEY_CREATED_DRIVER.codLimit}                                    |
      | vehicleType          | Car                                                              |
      | vehicleLicenseNumber | {KEY_CREATED_DRIVER.licenseNumber}                               |
      | vehicleCapacity      | {KEY_CREATED_DRIVER.vehicles[1].capacity}                        |
      | zoneId               | {zone-name-2}                                                    |
      | zoneMin              | 1                                                                |
      | zoneMax              | 2                                                                |
      | zoneCost             | 5                                                                |
      | password             | GENERATED                                                        |
      | comments             | This driver is UPDATED by "Automation Test" for testing purpose. |
      | contact              | GENERATED                                                        |
      | isVerified           | false                                                            |
    And Operator verifies error message "Please verify the mobile phone number." is displayed in Driver dialog

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
