@OperatorV2 @Core @Route @NewFeatures @StationRouteKeyword @BulkCreateCoverage
Feature: Bulk Create Coverage

#  Background:
#    Given Launch browser
#    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2
  Scenario: Operator Success Download CSV Template on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator click Bulk create coverage on Station Route Keyword page
    And Operator click Download template in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage template file is downloaded on Station Route Keyword page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Success Upload New Single Coverage on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                            | variations                                          | keywords                                      | primaryDriver                      | fallbackDriver                     |
      | Area bccs {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And Operator verifies that success react notification displayed:
      | top    | New coverages created |
      | bottom | 1 coverage(s) created |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA BCCS {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}     |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}     |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA BCCS {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                        |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}              |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}              |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA BCCS {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Success Upload New Multiple Coverages on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                              | variations                                            | keywords                                        | primaryDriver                      | fallbackDriver                     |
      | Area bccm {gradle-current-date-yyyyMMddHHmmsss}   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}   | Keyword {gradle-current-date-yyyyMMddHHmmsss}   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
      | Area bccm 2 {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And Operator verifies that success react notification displayed:
      | top    | New coverages created |
      | bottom | 2 coverage(s) created |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA BCCM {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}     |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}     |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA BCCM 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}       |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}       |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}   |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA BCCM {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                        |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}              |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}              |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA BCCM 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                               |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA BCCM {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA BCCM 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariation | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Success Upload New Coverages When Area Has No Keywords on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                            | variations                                          | keywords | primaryDriver                      | fallbackDriver                     |
      | Area bccn {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |          | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And Operator verifies that success react notification displayed:
      | top    | New coverages created |
      | bottom | 1 coverage(s) created |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA BCCN {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}     |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}     |
      | keywords       |                                                 |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA BCCN {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                        |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}              |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}              |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA BCCN {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords record was deleted:
      | coverageId | {KEY_COVERAGE_ID} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Success Upload New Coverage When Area, Area Var are Duplicate to Existing Coverage Area, Area Var but Different Keywords on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area bccv {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                            | variations                                          | keywords                                        | primaryDriver                      | fallbackDriver                     |
      | Area bccv {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And Operator verifies that success react notification displayed:
      | top    | New coverages created |
      | bottom | 1 coverage(s) created |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA BCCV {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}     |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}     |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA BCCV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                        |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}              |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}              |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA BCCV {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator  Fails Upload New Coverages When Driver Is Not Belong To Hub on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                            | variations                                          | keywords                                      | primaryDriver                      | fallbackDriver                     |
      | Area bcch {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 1: Primary driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} not in hub {hub-id} |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area                                            | variations                                          | keywords                                      | primaryDriver                      | fallbackDriver                     | error                                                                        |
      | Area bcch {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} | Row 1: Primary driver {KEY_DRIVER_LIST_OF_DRIVERS[1].id} not in hub {hub-id} |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Fails Upload New Coverages due Invalid CSV Format on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-2}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator upload invalid bulk create coverage CSV on Station Route Keyword page
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 1: Missing primary_driver_id |
      | Row 2: Missing primary_driver_id |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area  | variations | keywords | primaryDriver | fallbackDriver | error                            |
      | AREA1 |            |          |               |                | Row 1: Missing primary_driver_id |
      | AREA2 |            |          |               |                | Row 2: Missing primary_driver_id |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Fails Upload New Coverages When Area is Duplicate to Existing Coverage Area but Area Var is Different With Existing Coverage Area Var on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area bccd {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                            | variations                                            | keywords                                        | primaryDriver                      | fallbackDriver                     |
      | Area bccd {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 1: variations are different from the existing variations that the Area has, [coverages=[{"id"... |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area                                            | variations                                            | keywords                                        | primaryDriver                      | fallbackDriver                     | error                                                                                                |
      | Area bccd {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} | Row 1: variations are different from the existing variations that the Area has, [coverages=[{"id"... |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Fails Upload New Coverages When Area Var is Duplicate to Existing Coverage Area Var but Area is Different With Existing Coverage Area on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area bccde {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                               | variations                                          | keywords                                        | primaryDriver                      | fallbackDriver                     |
      | Area bccde 2 {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 1: variations already exist as area or variation of other coverages, [coverages=[{"id":{KEY_LIST_OF_COVERAGE[1].id},... |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area                                               | variations                                          | keywords                                        | primaryDriver                      | fallbackDriver                     | error                                                                                                                       |
      | Area bccde 2 {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} | Row 1: variations already exist as area or variation of other coverages, [coverages=[{"id":{KEY_LIST_OF_COVERAGE[1].id},... |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Fails Upload New Coverages When Area, Area Var, Keywords are Duplicate to Existing Coverage with Same Area, Area Var, Keywords on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area bccf {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                            | variations                                          | keywords                                      | primaryDriver                      | fallbackDriver                     |
      | Area bccf {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 1: keywords already exists as keywords of other coverages in the same hub, [duplicateKeywords... |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area                                            | variations                                          | keywords                                      | primaryDriver                      | fallbackDriver                     | error                                                                                                |
      | Area bccf {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} | Row 1: keywords already exists as keywords of other coverages in the same hub, [duplicateKeywords... |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Fails Upload New Coverages When Area is Duplicate to Existing Coverage as Area Var on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area bccfd {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                                | variations                                            | keywords                                        | primaryDriver                      | fallbackDriver                     |
      | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 1: area already exists as variation of other coverages, [coverages=[{"id":{KEY_LIST_OF_COVERAGE[1].id},"system_id":"... |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area                                             | variations                                          | keywords                                      | primaryDriver                      | fallbackDriver                     | error                                                                                                                       |
      | Area bccfd {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} | Row 1: area already exists as variation of other coverages, [coverages=[{"id":{KEY_LIST_OF_COVERAGE[1].id},"system_id":"... |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Fails Upload New Coverages When Area Has No Keyword is Duplicate to Existing Coverage with Same Area Has No Keyword on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area bccfn {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                             | variations                                          | keywords | primaryDriver                      | fallbackDriver                     |
      | Area bccfn {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |          | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 1: there is another existing coverage with the same area and no keyword in the same hub |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area                                             | variations                                          | keywords | primaryDriver                      | fallbackDriver                     | error                                                                                       |
      | Area bccfn {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |          | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} | Row 1: there is another existing coverage with the same area and no keyword in the same hub |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Partial Upload New Coverages When Area Var is Duplicate but Area is Different Within New Coverages on CSV File on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                              | variations                                          | keywords                                        | primaryDriver                      | fallbackDriver                     |
      | Area bccp {gradle-current-date-yyyyMMddHHmmsss}   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword {gradle-current-date-yyyyMMddHHmmsss}   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
      | Area bccp 2 {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA BCCP {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                        |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}              |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}              |
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 2: variations already exist as area or variation of other coverages, [coverages=[{"id":{KEY_COVERAGE_ID},... |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area                                              | variations                                          | keywords                                        | primaryDriver                      | fallbackDriver                     | error                                                                                                            |
      | Area bccp 2 {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} | Row 2: variations already exist as area or variation of other coverages, [coverages=[{"id":{KEY_COVERAGE_ID},... |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    And Operator verifies that success react notification displayed:
      | top    | New coverages created |
      | bottom | 1 coverage(s) created |
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA BCCP {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}     |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}     |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA BCCP {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Partial Upload New Coverages When Area is Duplicate but Area Var is Different Within New Coverages on CSV File on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                             | variations                                            | keywords                                        | primaryDriver                      | fallbackDriver                     |
      | Area bccpd {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}   | Keyword {gradle-current-date-yyyyMMddHHmmsss}   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
      | Area bccpd {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 2: variations are different from the existing variations that the Area has, [coverages=[{"id"... |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area                                             | variations                                            | keywords                                        | primaryDriver                      | fallbackDriver                     | error                                                                                                |
      | Area bccpd {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} | Row 2: variations are different from the existing variations that the Area has, [coverages=[{"id"... |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    And Operator verifies that success react notification displayed:
      | top    | New coverages created |
      | bottom | 1 coverage(s) created |
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA BCCPD {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA BCCPD {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA BCCPD {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Partial Upload New Coverages When Area, Area Var, and Keywords are Duplicate Within New Coverages on CSV File on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                             | variations                                          | keywords                                       | primaryDriver                      | fallbackDriver                     |
      | Area bccpn {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword {gradle-current-date-yyyyMMddHHmmsss}  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
      | Area bccpn {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | Keyword  {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 2: keywords already exists as keywords of other coverages in the same hub, [duplicateKeywords... |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area                                             | variations                                            | keywords                                        | primaryDriver                      | fallbackDriver                     | error                                                                                                |
      | Area bccpn {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} | Row 2: keywords already exists as keywords of other coverages in the same hub, [duplicateKeywords... |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    And Operator verifies that success react notification displayed:
      | top    | New coverages created |
      | bottom | 1 coverage(s) created |
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA BCCPN {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA BCCPN {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA BCCPN {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Partial Upload New Coverages When Area is Duplicate as Area Var Within New Coverages on CSV File on Bulk Create Coverage
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator bulk create new coverages on Station Route Keyword page:
      | area                                                | variations                                            | keywords                                        | primaryDriver                      | fallbackDriver                     |
      | Area bccad {gradle-current-date-yyyyMMddHHmmsss}    | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}   | Keyword {gradle-current-date-yyyyMMddHHmmsss}   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
      | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And DB Route - verify that sr_coverages record is created:
      | area           | AREA BCCAD {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                         |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    Then Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:
      | Row 2: area already exists as variation of other coverages, [coverages=[{"id":{KEY_COVERAGE_ID},"system_id":"... |
    And Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page
    When Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page
    Then Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:
      | area                                                | variations                                            | keywords                                        | primaryDriver                      | fallbackDriver                     | error                                                                                                            |
      | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} | Row 2: area already exists as variation of other coverages, [coverages=[{"id":{KEY_COVERAGE_ID},"system_id":"... |
    When Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page
    And Operator verifies that success react notification displayed:
      | top    | New coverages created |
      | bottom | 1 coverage(s) created |
    Then Operator verify Bulk create coverage dialog is closed on Station Route Keyword page
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA BCCAD {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}      |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].displayName}      |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA BCCAD {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
