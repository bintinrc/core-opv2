@OperatorV2 @Core @Route @NewFeatures @StationRouteKeyword @EditArea
Feature: Edit Area

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                              |
      | bottom | ^.*Error Message: \[duplicatedNames: AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss}\]: name already exists as area or area variation of other coverages.* |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area Variation
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | areaVariations | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                            |
      | bottom | ^.*Error Message: \[duplicatedNames: AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss}\]: name already exists as area or area variation of other coverages.* |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area and Duplicate Area Variation
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                                                                    |
      | bottom | Area AREA {gradle-current-date-yyyyMMddHHmmsss} with variations AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE[1].id}               |
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}         |
    And DB Route - verify that sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE[2].id}               |
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}         |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}         |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is not created for "AREA 2 {gradle-current-date-yyyyMMddHHmmsss}" area

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword -  Duplicate Area and Duplicate Area Variation Do Not Match
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area 3 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation 3 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 3 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | Area 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations | AreaVariation 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                              |
      | bottom | ^.*Error Message: \[duplicatedNames: AREAVARIATION 3 {gradle-current-date-yyyyMMddHHmmsss}\]: name already exists as area or area variation of other coverages.* |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - New Area
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                      |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}    |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}            |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}            |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area | Area 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                    |
      | bottom | Area AREA 2 {gradle-current-date-yyyyMMddHHmmsss} with variations - |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE[1].id}                 |
      | area           | AREA 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                     |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}           |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}           |
    And DB Route - verify that sr_area_variations record is not created for "AREA 2 {gradle-current-date-yyyyMMddHHmmsss}" area

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - New Area Variation
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | areaVariations | AreaVariation {gradle-current-date-yyyyMMddHHmmsss},AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                                                                                                                           |
      | bottom | Area AREA {gradle-current-date-yyyyMMddHHmmsss} with variations AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss}, AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}            |
      | variationName | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - New Area and New Area Variation
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | Area 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                                                                        |
      | bottom | Area AREA 2 {gradle-current-date-yyyyMMddHHmmsss} with variations AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE[1].id}                 |
      | area           | AREA 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                     |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}           |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}           |
    And DB Route - verify that sr_area_variations record is not created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is not created:
      | area          | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}        |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | variationName | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area Variation with Exist Area
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}              |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}              |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                          |
      | area             | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | AREA 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | areaVariations | AREA {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                   |
      | bottom | ^.*Error Message: \[duplicatedNames: AREA {gradle-current-date-yyyyMMddHHmmsss}\]: name already exists as area or area variation of other coverages.* |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area, Duplicate Area Variation, and Duplicate Empty Keyword
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}              |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}              |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                          |
      | area             | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                                           |
      | bottom | ^.*Error Message: Current coverage has no keyword, and there is another existing coverage with the area to be updated without keyword. Cannot update current coverage\.\.\..* |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area with Exist Area Variation in Different Hub
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-5}, "hub": { "displayName": "{hub-name-5}", "value": {hub-id-5} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-5}, "hub": { "displayName": "{hub-name-5}", "value": {hub-id-5} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-6}, "hub": { "displayName": "{hub-name-6}", "value": {hub-id-6} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-6}, "hub": { "displayName": "{hub-name-6}", "value": {hub-id-6} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-5}                                          |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-6}                                            |
      | area             | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name-6}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations | VARIATION 3 {gradle-current-date-yyyyMMddHHmmsss}   |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                                                                           |
      | bottom | Area AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} with variations VARIATION 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE[2].id}                        |
      | area           | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id-6}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}                  |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}                  |
