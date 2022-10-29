@OperatorV2 @Core @NewFeatures @StationRouteKeyword @NewFeatures2
Feature: Remove Keywords

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Operator Remove Keywords on Station Route Keyword - Single Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}                                                    |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}                                           |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss},Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}                                                  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}                                                  |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 2 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}                                                     |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}                                                   |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}                                                   |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}, KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
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
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId        | value                                         |
      | {KEY_COVERAGE_ID} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_keywords records were deleted:
      | coverageId        | value                                           |
      | {KEY_COVERAGE_ID} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver
  Scenario: Operator Remove Keywords on Station Route Keyword - Multiple Keywords
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}                                                                                                    |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}                                                                                           |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss},Keyword 2 {gradle-current-date-yyyyMMddHHmmsss},Keyword 3 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}                                                                                                  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}                                                                                                  |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 3 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}                                                                                                     |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}                                                                                                   |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}                                                                                                   |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}, KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss},KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
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
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId        | value                                         |
      | {KEY_COVERAGE_ID} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_keywords records were deleted:
      | coverageId        | value                                           |
      | {KEY_COVERAGE_ID} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | {KEY_COVERAGE_ID} | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
