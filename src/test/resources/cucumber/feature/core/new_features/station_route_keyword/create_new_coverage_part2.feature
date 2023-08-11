@OperatorV2 @Core @Route @NewFeatures @StationRouteKeyword @CreateNewCoveragePart2
Feature: Create New Coverage

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Area Variation, and Duplicate Keyword - Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cntdak {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cntdak {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}         |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNTDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNTDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNTDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       |                                                   |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNTDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNTDAK {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNTDAK {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - fetch coverage id for "AREA CNTDAK {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verify that sr_keywords record is not created for "{KEY_LIST_OF_COVERAGE[1].id}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, Duplicate Area Variation, and Duplicate Keyword - Not Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cntna {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cntna 2 {gradle-current-date-yyyyMMddHHmmsss}  |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}         |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNTNA {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNTNA {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywordsAdded  | 0 keyword(s) added                               |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNTNA {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNTNA {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       |                                                  |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNTNA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNTNA {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_LIST_OF_COVERAGE[1].id}                  |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - fetch coverage id for "AREA CNTNA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verify that sr_keywords record is not created for "{KEY_COVERAGE_ID}" area

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, Duplicate Area Variation, and Duplicate Keyword - Transfer Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cntnat {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cntnat 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}         |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA CNTNAT {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNTNAT {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNTNAT {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       |                                                   |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNTNAT {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}     |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNTNAT {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNTNAT {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verify that sr_keywords record is not created for "{KEY_LIST_OF_COVERAGE[1].id}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Searches Created Coverage on Station Route Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area cnts {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    When Operator filter coverages on Station Route Keyword page:
      | area | AREA CNTS |
    Then Operator verify filter results on Station Route Keyword page:
      | area | AREA CNTS |
    When Operator filter coverages on Station Route Keyword page:
      | keywords | KEYWORD |
    Then Operator verify filter results on Station Route Keyword page:
      | keywords | KEYWORD |
    When Operator filter coverages on Station Route Keyword page:
      | primaryDriver | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
    Then Operator verify filter results on Station Route Keyword page:
      | primaryDriver | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
    When Operator filter coverages on Station Route Keyword page:
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName} |
    Then Operator verify filter results on Station Route Keyword page:
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword with VN Special Characters
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | 135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariation  | 135 Đ NAM KỲ KHỞI NGHĨA 2 {gradle-current-date-yyyyMMddHHmmsss}               |
      | keyword        | THÀNH PHỐ HỒ CHÍ MINH VN {gradle-current-date-yyyyMMddHHmmsss}                |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}                                   |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}                                   |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | 135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}                                   |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}                                   |
      | keyword        | THÀNH PHỐ HỒ CHÍ MINH VN {gradle-current-date-yyyyMMddHHmmsss}                |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | 135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}                                   |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}                                   |
      | keyword        | THÀNH PHỐ HỒ CHÍ MINH VN {gradle-current-date-yyyyMMddHHmmsss}                |
    And DB Route - verify that sr_coverages record is created:
      | area           | 135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                                                      |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                                            |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                                            |
    And DB Route - verify that sr_area_variations record is created:
      | area          | 135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariation | 135 Đ NAM KỲ KHỞI NGHĨA 2 {gradle-current-date-yyyyMMddHHmmsss}               |
    And DB Route - fetch coverage id for "135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                                              |
      | keyword    | THÀNH PHỐ HỒ CHÍ MINH VN {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area Variation with Exist Area
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                         |
      | area             | AREA CNTDV {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA CNTDV 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariation  | AREA {gradle-current-date-yyyyMMddHHmmsss}         |
      | keyword        | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}        |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNTDV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}  |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNTDV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}  |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNTDV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNTDV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNTDV {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariation | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}     |
    And DB Route - fetch coverage id for "AREA CNTDV {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                               |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, New Area Variation, and Empty Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cntek {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}         |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNTEK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNTEK {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA CNTEK {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA CNTEK {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - fetch coverage id for "AREA CNTEK {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verify that sr_keywords record is not created for "{KEY_COVERAGE_ID}" area

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, Empty Area Variation, and Empty Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area cntev {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA CNTEV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA CNTEV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA CNTEV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - verify that sr_area_variations record is not created for "AREA CNTEV {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - fetch coverage id for "AREA CNTEV {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verify that sr_keywords record is not created for "{KEY_COVERAGE_ID}" area

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, New Area Variation, and Duplicate Empty Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                         |
      | area             | AREA CNTDK {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss}  |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA CNTDK {gradle-current-date-yyyyMMddHHmmsss}  |
      | areaVariation  | VARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}       |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                                                                         |
      | bottom | ^.*Error Message: cannot create current coverage. Please adjust your input. \[area: AREA CNTDK {gradle-current-date-yyyyMMddHHmmsss}\]: there is another existing coverage with the same area and n\.\.\..* |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           |  |
      | primaryDriver  |  |
      | fallbackDriver |  |
      | keywords       |  |
    And DB Route - verify that sr_coverages record is not created:
      | area             | AREA CNTDK {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                         |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}               |
    And DB Route - verify that sr_area_variations record is not created:
      | area          | AREA CNTDK {gradle-current-date-yyyyMMddHHmmsss}  |
      | variationName | VARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Area Variation, and Duplicate Empty Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}"-{{TIMESTAMP}}, "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC4{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                           |
      | area             | AREA CNTDAVK {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA CNTDAVK {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariation  | VARIATION {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].displayName}        |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].displayName}        |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                                                                           |
      | bottom | ^.*Error Message: cannot create current coverage. Please adjust your input. \[area: AREA CNTDAVK {gradle-current-date-yyyyMMddHHmmsss}\]: there is another existing coverage with the same area and n\.\.\..* |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           |  |
      | primaryDriver  |  |
      | fallbackDriver |  |
      | keywords       |  |
    And DB Route - verify that sr_coverages record is not created:
      | area             | AREA CNTDAVK {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                           |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}                 |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}                 |
