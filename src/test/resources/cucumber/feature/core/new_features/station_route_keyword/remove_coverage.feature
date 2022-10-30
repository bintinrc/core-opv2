@OperatorV2 @Core @NewFeatures @StationRouteKeyword @NewFeatures2
Feature: Remove Coverage

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Remove Coverage on Station Route Keyword - No Duplicate Area and Duplicate Area Variation
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area on Station Route Keyword page
    And Operator remove coverage on Station Route Keyword page
    And Operator verifies that success react notification displayed:
      | top    | Coverage deleted                                                    |
      | bottom | Area AREA {gradle-current-date-yyyyMMddHHmmsss}, 1 keywords deleted |
    And Operator verify coverage is not displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that sr_coverages record is not created for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that sr_area_variations record is not created for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Remove Coverage on Station Route Keyword - Duplicate Area and Duplicate Area Variation
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss}    |
      | keywords | Keyword {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator remove coverage on Station Route Keyword page
    And Operator verifies that success react notification displayed:
      | top    | Coverage deleted                                                    |
      | bottom | Area AREA {gradle-current-date-yyyyMMddHHmmsss}, 1 keywords deleted |
    And Operator verify coverage is not displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that sr_keywords record is not created for "{KEY_LIST_OF_COVERAGE_ID[1]}" coverageId
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_LIST_OF_COVERAGE_ID[2]}                    |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op