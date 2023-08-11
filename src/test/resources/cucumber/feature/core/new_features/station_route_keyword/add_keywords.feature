@OperatorV2 @Core @Route @NewFeatures @StationRouteKeyword @AddKeywords
Feature: Add Keywords

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - No Duplicate Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area akndk {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings for "AREA AKNDK {gradle-current-date-yyyyMMddHHmmsss}" area on Station Route Keyword page
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 2 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA AKNDK {gradle-current-date-yyyyMMddHHmmsss}                                                 |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}                                                      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}                                                      |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}, KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records are created:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Keyword - Not Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area akntk {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area akntk {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area akntk {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}  |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA AKNTK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top | Keywords added |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA AKNTK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywordsAdded  | 0 keyword(s) added                               |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records are created:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records are created:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE[2].id} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Keyword - Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area aktk {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area aktk {gradle-current-date-yyyyMMddHHmmsss}       |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area aktk {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA AKTK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}     |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}     |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 2 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA AKTK {gradle-current-date-yyyyMMddHHmmsss}                                                |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}                                                    |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}                                                    |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}, KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_keywords record is not created for "{KEY_LIST_OF_COVERAGE[1].id}" area
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records are created:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE[2].id} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | {KEY_LIST_OF_COVERAGE[2].id} | KEYWORD  {gradle-current-date-yyyyMMddHHmmsss}  |
      | {KEY_LIST_OF_COVERAGE[2].id} | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Empty Area Variation and Duplicate Keyword - Not Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                           |
      | area             | Area akdentk {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                 |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                           |
      | area             | Area akdentk {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area akdentk {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}    |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA AKDENTK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}        |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}      |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA AKDENTK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}        |
      | keywordsAdded  | 0 keyword(s) added                                 |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records were deleted:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE[2].id} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Empty Area Variation and Duplicate Keyword - Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                          |
      | area             | Area akdeav {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                          |
      | area             | Area akdeav {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area akdeav {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}   |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA AKDEAV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top                | Keywords added |
      | waitUntilInvisible | true           |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA AKDEAV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywordsAdded  | 1 keyword(s) added                                |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records were deleted:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records are created:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE[2].id} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Keyword from Empty Coverage Keyword - Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area akdke {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area akdke {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area akdke {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords | empty                                            |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA AKDKE {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top | Keywords added |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA AKDKE {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywordsAdded  | 1 keyword(s) added                               |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records were deleted:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records are created:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE[2].id} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Keyword from Empty Coverage Keyword - Not Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area akdkec {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area akdkec {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area akdkec {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords | empty                                             |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA AKDKEC {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top | Keywords added |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA AKDKEC {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywordsAdded  | 0 keyword(s) added                                |
    When Operator close New coverage created dialog
    Then Operator verify there are no keywords on Add Keywords tab on Station Route Keyword page
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records were deleted:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE[2].id} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

