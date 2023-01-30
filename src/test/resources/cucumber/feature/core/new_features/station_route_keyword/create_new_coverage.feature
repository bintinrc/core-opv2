@OperatorV2 @Route @NewFeatures @StationRouteKeyword @StationRoute
Feature: Create New Coverage

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, New Area Variation, and New Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}        |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, New Area Variation, and New Keyword
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
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}            |
      | areaVariation  | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}          |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}          |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
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
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}            |
      | areaVariation | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                               |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, Duplicate Area Variation, and New Keyword
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
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area 2 {gradle-current-date-yyyyMMddHHmmsss}        |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}        |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
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
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                               |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, New Area Variation, and Duplicate Keyword
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
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation  | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}         |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}          |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}          |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}  |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}  |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                     |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}          |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}          |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA 2 {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Area Variation, and New Keyword
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
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}        |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
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
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                               |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, Empty Area Variation, and New Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}    |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area and Duplicate Area Variation Do Not Match
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
      | hubId            | {hub-id}                                              |
      | area             | Area 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                   |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                   |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}            |
      | areaVariation  | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword 3 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}          |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}          |
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                                                        |
      | bottom | ^.*Error Message: More than one existing area names are found in area and areaVariation: \[\[AREA {gradle-current-date-yyyyMMddHHmmsss} AREA 2 {gradle-current-date-yyyyMMddHHmmsss}\]\].* |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, New Area Variation, and Duplicate Keyword - Not Transfer Keyword
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
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}            |
      | areaVariation  | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}         |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}          |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}          |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywordsAdded  | 0 keywords added                             |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywords       |                                              |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, New Area Variation, and Duplicate Keyword - Transfer Keyword
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
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}            |
      | areaVariation  | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}         |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}          |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}          |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywords       |                                              |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Area Variation, and Duplicate Keyword - Not Transfer Keyword
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
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}        |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywordsAdded  | 0 keywords added                             |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywords       |                                              |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Area Variation, and Duplicate Keyword - Transfer Keyword
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
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}        |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywords       |                                              |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, Duplicate Area Variation, and Duplicate Keyword - Not Transfer Keyword
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
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area 2 {gradle-current-date-yyyyMMddHHmmsss}        |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}        |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 0 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywordsAdded  | 0 keywords added                             |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywords       |                                              |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - New Area, Duplicate Area Variation, and Duplicate Keyword - Transfer Keyword
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
    And Operator create new coverage on Station Route Keyword page:
      | area           | Area 2 {gradle-current-date-yyyyMMddHHmmsss}        |
      | areaVariation  | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}        |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywords       |                                              |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Searches Created Coverage on Station Route Keyword
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
    When Operator filter coverages on Station Route Keyword page:
      | area | AREA |
    Then Operator verify filter results on Station Route Keyword page:
      | area | AREA |
    When Operator filter coverages on Station Route Keyword page:
      | keywords | KEYWORD |
    Then Operator verify filter results on Station Route Keyword page:
      | keywords | KEYWORD |
    When Operator filter coverages on Station Route Keyword page:
      | primaryDriver | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
    Then Operator verify filter results on Station Route Keyword page:
      | primaryDriver | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
    When Operator filter coverages on Station Route Keyword page:
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
    Then Operator verify filter results on Station Route Keyword page:
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |

  @DeleteDriver @DeleteCoverage
  Scenario: OOperator Creates New Coverage on Station Route Keyword with VN Special Characters
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | 135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss}  |
      | areaVariation  | 135 Đ NAM KỲ KHỞI NGHĨA, PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | THÀNH PHỐ HỒ CHÍ MINH VN {gradle-current-date-yyyyMMddHHmmsss}                 |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}                                   |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}                                   |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | 135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}                                  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}                                  |
      | keyword        | THÀNH PHỐ HỒ CHÍ MINH VN {gradle-current-date-yyyyMMddHHmmsss}                |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | 135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}                                  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}                                  |
      | keyword        | THÀNH PHỐ HỒ CHÍ MINH VN {gradle-current-date-yyyyMMddHHmmsss}                |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | 135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                                                      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                                           |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                                           |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | 135 Đ NAM KỲ KHỞI NGHĨA PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss}  |
      | areaVariation | 135 Đ NAM KỲ KHỞI NGHĨA, PHƯỜNG BẾN THÀN {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                                              |
      | keyword    | THÀNH PHỐ HỒ CHÍ MINH VN {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area Variation with Exist Area
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation  | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | keyword        | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                               |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area Variation with Exist Area
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}    |
      | areaVariation  | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | keyword        | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
    And Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 1 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}    |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariation | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                               |
      | value      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op