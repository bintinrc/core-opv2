@OperatorV2 @Core @Route @NewFeatures @StationRouteKeyword @CreateNewCoveragePart1
Feature: Create New Coverage

#  Background:
#    Given Launch browser
#    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, New Area Variation, and New Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cncn {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}         |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNCN {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}     |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}     |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNCN {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}     |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}     |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNCN {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                        |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}              |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}              |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNCN {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, New Area Variation, and New Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cncda {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cncda {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariation  | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}           |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}           |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNCDA {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}  |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNCDA {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}  |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNCDA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNCDA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariation | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - fetch coverage id for "AREA CNCDA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                               |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, Duplicate Area Variation, and New Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cncdv {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cncdv 2 {gradle-current-date-yyyyMMddHHmmsss}  |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}         |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNCDV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}  |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNCDV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}  |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNCDV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNCDV {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - fetch coverage id for "AREA CNCDV {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                               |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, New Area Variation, and Duplicate Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cncdk {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cncdk 2 {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation  | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}           |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}           |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNCDK 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}        |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}      |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNCDK 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}        |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}      |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNCDK 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                           |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                 |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                 |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNCDK 2 {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - fetch coverage id for "AREA CNCDK 2 {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Area Variation, and New Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cncdav {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cncdav {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}         |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNCDAV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}   |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNCDAV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}   |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNCDAV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNCDAV {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - fetch coverage id for "AREA CNCDAV {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                               |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, Empty Area Variation, and New Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cncev {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNCEV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNCEV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNCEV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - fetch coverage id for "AREA CNCEV {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area and Duplicate Area Variation Do Not Match
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cncnm {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area cncnm 2 {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cncnm {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariation  | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword 3 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}           |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}           |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                                                                                            |
      | bottom | ^.*Error Message: More than one existing areas are found in the area and area variation input: \[AREA cncnm {gradle-current-date-yyyyMMddHHmmsss},AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss}\]. Please adjust ....* |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, New Area Variation, and Duplicate Keyword - Not Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cncdak {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cncdak {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariation  | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}           |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}           |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNCDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNCDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywordsAdded  | 0 keyword(s) added                                |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNCDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       |                                                   |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNCDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNCDAK {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - fetch coverage id for "AREA CNCDAK {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verify that sr_keywords record is not created for "{KEY_COVERAGE_ID}" area

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, New Area Variation, and Duplicate Keyword - Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cncnda {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cncnda {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariation  | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}           |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}           |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNCNDA {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNCNDA {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNCNDA {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       |                                                   |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNCNDA {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNCNDA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNCNDA {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_keywords record is not created for "{KEY_COVERAGE_ID}" area
    And DB Route - fetch coverage id for "AREA CNCNDA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Area Variation, and Duplicate Keyword - Not Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cncdavk {gradle-current-date-yyyyMMddHHmmsss}  |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cncdavk {gradle-current-date-yyyyMMddHHmmsss}  |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}         |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNCDAVK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}        |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}      |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNCDAVK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}        |
      | keywordsAdded  | 0 keyword(s) added                                 |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNCDAVK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}        |
      | keywords       |                                                    |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNCDAVK {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                           |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                 |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                 |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNCDAVK {gradle-current-date-yyyyMMddHHmmsss}  |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - fetch coverage id for "AREA CNCDAVK {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verify that sr_keywords record is not created for "{KEY_COVERAGE_ID}" area

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
