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
      | area             | Area eada {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area eada 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area eada 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area | Area eada {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                              |
      | bottom | ^.*Error Message: \[duplicatedNames: AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss}\]: name already exists as area or area variation of other coverages.* |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area Variation
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area eadav {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area eadav 2 {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area eadav 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | areaVariations | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                            |
      | bottom | ^.*Error Message: \[duplicatedNames: AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss}\]: name already exists as area or area variation of other coverages.* |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area and Duplicate Area Variation
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area eadaav {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area eadaav 2 {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area eadaav 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | Area eadaav {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                                                                           |
      | bottom | Area AREA eadaav {gradle-current-date-yyyyMMddHHmmsss} with variations AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE[1].id}                      |
      | area           | AREA EADAAV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And DB Route - verify that sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE[2].id}                      |
      | area           | AREA EADAAV {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA EADAAV {gradle-current-date-yyyyMMddHHmmsss}   |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is not created for "AREA EADAAV 2 {gradle-current-date-yyyyMMddHHmmsss}" area

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword -  Duplicate Area and Duplicate Area Variation Do Not Match
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area eadm {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area eadm 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area eadm 3 {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation 3 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 3 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area eadm {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | Area eadm 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations | AreaVariation 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                              |
      | bottom | ^.*Error Message: \[duplicatedNames: AREAVARIATION 3 {gradle-current-date-yyyyMMddHHmmsss}\]: name already exists as area or area variation of other coverages.* |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - New Area
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | Area eana {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}              |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}              |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area eana {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area | Area eana 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                         |
      | bottom | Area AREA EANA 2 {gradle-current-date-yyyyMMddHHmmsss} with variations - |
    And DB Route - verify that sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE[1].id}                      |
      | area           | AREA EANA 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                          |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And DB Route - verify that sr_area_variations record is not created for "AREA EANA 2 {gradle-current-date-yyyyMMddHHmmsss}" area

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - New Area Variation
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area eanv {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area eanv {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | areaVariations | AreaVariation {gradle-current-date-yyyyMMddHHmmsss},AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                                                                                                                                |
      | bottom | Area AREA EANV {gradle-current-date-yyyyMMddHHmmsss} with variations AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss}, AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA EANV {gradle-current-date-yyyyMMddHHmmsss}     |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA EANV {gradle-current-date-yyyyMMddHHmmsss}       |
      | variationName | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - New Area and New Area Variation
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area eanaav {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area eanaav {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | Area eanaav 2 {gradle-current-date-yyyyMMddHHmmsss}   |
      | areaVariations | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                                                                               |
      | bottom | Area AREA EANAAV 2 {gradle-current-date-yyyyMMddHHmmsss} with variations AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE[1].id}                        |
      | area           | AREA EANAAV 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                            |
      | primaryDriver  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriver | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And DB Route - verify that sr_area_variations record is not created:
      | area          | AREA EANAAV {gradle-current-date-yyyyMMddHHmmsss}   |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is not created:
      | area          | AREA EANAAV 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_area_variations record is created:
      | area          | AREA EANAAV 2 {gradle-current-date-yyyyMMddHHmmsss}   |
      | variationName | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area Variation with Exist Area
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                         |
      | area             | AREA EADEA {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss}  |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}               |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}               |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                           |
      | area             | AREA EADEA 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION 2 {gradle-current-date-yyyyMMddHHmmsss}  |
      | keywords         | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | AREA EADEA 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | areaVariations | AREA EADEA {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                         |
      | bottom | ^.*Error Message: \[duplicatedNames: AREA EADEA {gradle-current-date-yyyyMMddHHmmsss}\]: name already exists as area or area variation of other coverages.* |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area, Duplicate Area Variation, and Duplicate Empty Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC6{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA EADL {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}              |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}              |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                          |
      | area             | AREA EADL 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations   | VARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area eadl 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | AREA EADL {gradle-current-date-yyyyMMddHHmmsss} |
      | areaVariations | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                                                                                                |
      | bottom | ^.*Error Message: Current coverage has no keyword, and there is another existing coverage with the area to be updated without keyword. Cannot update current coverage. \[area: AREA EADL {gradle-current-date-yyyyMMddHHmmsss}\].* |

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
      | area             | AREA EADH {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                  |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-6}                                            |
      | area             | AREA EADH 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | areaVariations   | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}                    |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}                    |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name-6}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area eadh 2 {gradle-current-date-yyyyMMddHHmmsss} |
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