@OperatorV2 @Core @Route @NewFeatures @StationRouteKeyword @CreateNewCoveragePart3
Feature: Create New Coverage

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteCoverageV2 @MediumPriority
  Scenario: Operator Creates New Coverage on Station Route Keyword - Multiple Duplicate Area and Area Variation - Some Have Empty Keyword - Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                         |
      | area             | AREA CNHMD {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss}  |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                         |
      | area             | AREA CNHMD {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss}  |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA CNHMD {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariation  | VARIATION {gradle-current-date-yyyyMMddHHmmsss}  |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}      |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNHMD {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that error react notification displayed:
      | bottom | ^.*Error Message: cannot create current coverage\. Please adjust your input. \[area: AREA CNHMD {gradle-current-date-yyyyMMddHHmmsss}\]: there is another existing coverage with the same ar....* |
    And DB Route - verify that sr_coverages record is not created:
      | area             | AREA CNHMD {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                         |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}               |

  @DeleteDriverV2 @DeleteCoverageV2 @MediumPriority
  Scenario: Operator Creates New Coverage on Station Route Keyword - Multiple Duplicate Area and Area Variation - Some Have Empty Keyword - Not Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                           |
      | area             | AREA CNHMDAV {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                 |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                           |
      | area             | AREA CNHMDAV {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss}    |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA CNHMDAV {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariation  | VARIATION {gradle-current-date-yyyyMMddHHmmsss}    |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}        |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNHMDAV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}        |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}      |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that error react notification displayed:
      | bottom | ^.*Error Message: cannot create current coverage. Please adjust your input. \[area: AREA CNHMDAV {gradle-current-date-yyyyMMddHHmmsss}\]: there is another existing coverage with the same ar....* |
    And DB Route - verify that sr_coverages record is not created:
      | area             | AREA CNHMDAV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                           |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}                 |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}                 |

  @DeleteDriverV2 @DeleteCoverageV2 @MediumPriority
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Empty Area Variation, and Duplicate Keyword - Not Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                         |
      | area             | AREA CNHEV {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss}  |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA CNHEV {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}      |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNHEV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNHEV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}      |
      | keywordsAdded  | 0 keyword(s) added                               |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNHEV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}      |
      | keywords       |                                                  |
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA CNHEV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                         |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}               |
    And DB Route - verify that sr_keywords record is not created for "{KEY_COVERAGE_ID}" area

  @DeleteDriverV2 @DeleteCoverageV2 @MediumPriority
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Empty Area Variation, and Duplicate Keyword - Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                          |
      | area             | AREA CNHDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss}   |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA CNHDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}       |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNHDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNHDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNHDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       |                                                   |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNHDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA CNHDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                          |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And DB Route - verify that sr_keywords record is not created for "{KEY_LIST_OF_COVERAGE[1].id}" area
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA CNHDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                          |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}                |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2 @MediumPriority
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Empty Area Variation, and Duplicate Keyword - Not Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                          |
      | area             | AREA CNHDEV {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA CNHDEV {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}       |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNHDEV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNHDEV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}       |
      | keywordsAdded  | 0 keyword(s) added                                |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNHDEV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}       |
      | keywords       |                                                   |
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA CNHDEV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                          |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}                |
    And DB Route - verify that sr_area_variations record is not created for "AREA CNHDEV {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verify that sr_keywords record is not created for "{KEY_COVERAGE_ID}" area

  @DeleteDriverV2 @DeleteCoverageV2 @MediumPriority
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Empty Area Variation, and Duplicate Keyword - Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC5{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                         |
      | area             | AREA CNHDL {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA CNHDL {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}      |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNHDL {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNHDL {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNHDL {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       |                                                  |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNHDL {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA CNHDL {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                         |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - verify that sr_keywords record is not created for "{KEY_LIST_OF_COVERAGE[1].id}" area
    And DB Route - verify that sr_area_variations record is not created for "AREA CNHDL {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA CNHDL {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                         |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[3].id}              |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[4].id}              |
    And DB Route - fetch coverage id for "AREA CNHDL {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2 @MediumPriority
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area with Exist Area Variation in Different Hub
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-4}, "hub": { "displayName": "{hub-name-4}", "value": {hub-id-4} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-4}, "hub": { "displayName": "{hub-name-4}", "value": {hub-id-4} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-5}, "hub": { "displayName": "{hub-name-5}", "value": {hub-id-5} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-5}, "hub": { "displayName": "{hub-name-5}", "value": {hub-id-5} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-4}                                          |
      | area             | AREA CNHDH {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name-5}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariation  | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}           |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}           |
    Then Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    And Operator verify data on New coverage created dialog:
      | area           | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}         |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}         |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}     |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNHDH {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id-4}                                       |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id-5}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}                  |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}                  |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNHDH {gradle-current-date-yyyyMMddHHmmsss}    |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss}   |
      | variationName | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |