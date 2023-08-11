@OperatorV2 @Core @Route @NewFeatures @StationRouteKeyword @RemoveKeywords
Feature: Remove Keywords

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Remove Keywords on Station Route Keyword - Single Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "DC8{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "DC8{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                                                                      |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}                                                    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}                                           |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss},Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                                                            |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                                                            |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area on Station Route Keyword page
    And Operator remove keywords on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verify keywords on Remove keywords dialog:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'Yes, remove' button on Remove keywords dialog:
    Then Operator verifies that success react notification displayed:
      | top    | Keywords removed |
      | bottom | 1 keywords       |
    And Operator verify keywords on Remove keywords tab on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records are created:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords multiple records were deleted:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Remove Keywords on Station Route Keyword - Multiple Keywords
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "DC8{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "DC8{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                                                                                                                      |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}                                                                                                    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}                                                                                           |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss},Keyword 2 {gradle-current-date-yyyyMMddHHmmsss},Keyword 3 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                                                                                                            |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                                                                                                            |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area on Station Route Keyword page
    And Operator remove keywords on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verify keywords on Remove keywords dialog:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'Yes, remove' button on Remove keywords dialog:
    Then Operator verifies that success react notification displayed:
      | top    | Keywords removed |
      | bottom | 2 keywords       |
    And Operator verify keywords on Remove keywords tab on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Route - verifies that route_qa_gl.sr_keywords multiple records are created:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verifies that route_qa_gl.sr_keywords multiple records were deleted:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | {KEY_LIST_OF_COVERAGE[1].id} | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Remove Keywords on Station Route Keyword - Multiple Keywords - Coverages Have Duplicate Empty Keyword
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "DC8{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    Given API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "DC8{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": {hub-id} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                 |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id}                                                                                                                                      |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}                                                                                                    |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}                                                                                           |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss},Keyword 2 {gradle-current-date-yyyyMMddHHmmsss},Keyword 3 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                                                                                                           |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                                                                                                           |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss}                                                                                                    |
      | keywords | Keyword {gradle-current-date-yyyyMMddHHmmsss},Keyword 2 {gradle-current-date-yyyyMMddHHmmsss},Keyword 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator remove keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verify keywords on Remove keywords dialog:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'Yes, remove' button on Remove keywords dialog:
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                                                            |
      | bottom | ^.*Error Message: cannot delete all keywords of current coverage. \[area: AREA {gradle-current-date-yyyyMMddHHmmsss}\]: there is another existing coverage with the same area and no keyword.* |
