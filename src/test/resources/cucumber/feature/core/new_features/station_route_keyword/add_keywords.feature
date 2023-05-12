@OperatorV2 @Core @Route @NewFeatures @StationRouteKeyword @StationRoute @AddKeywords
Feature: Add Keywords

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - No Duplicate Keyword
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
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 2 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}                                                       |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}                                                     |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}                                                     |
      | keywords       | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}, KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator fetch coverage id for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId        | value                                           |
      | {KEY_COVERAGE_ID} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | {KEY_COVERAGE_ID} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | {KEY_COVERAGE_ID} | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Keyword - Not Transfer Keyword
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
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}            |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                   |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                   |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss}      |
      | keywords | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top | Keywords added |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}                                                    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}                                                  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}                                                  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss},KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE_ID[1]} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Keyword - Transfer Keyword
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
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}            |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                   |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                   |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss}      |
      | keywords | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top    | Keywords added |
      | bottom | 2 keywords     |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}                                                     |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}                                                   |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}                                                   |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}, KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that sr_keywords record is not created for "{KEY_LIST_OF_COVERAGE_ID[1]}" coverageId
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD  {gradle-current-date-yyyyMMddHHmmsss}  |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Empty Area Variation and Duplicate Keyword - Not Transfer Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                      |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}    |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}           |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}           |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}      |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss}      |
      | keywords | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top | Keywords added |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywordsAdded  | 0 keyword(s) added                           |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Operator verifies that route_qa_gl/sr_keywords records were deleted:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Empty Area Variation and Duplicate Keyword - Transfer Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                      |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}    |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}           |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}           |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}      |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss}      |
      | keywords | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top | Keywords added |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywordsAdded  | 1 keyword(s) added                           |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Operator verifies that route_qa_gl/sr_keywords records were deleted:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE_ID[1]} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Keyword from Empty Coverage Keyword - Transfer Keyword
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
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords | empty                                      |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top | Keywords added |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywordsAdded  | 1 keyword(s) added                            |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify keywords on Add Keywords tab on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Operator verifies that route_qa_gl/sr_keywords records were deleted:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE_ID[1]} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Add New Keywords for Coverage on Station Route Keyword - Duplicate Keyword from Empty Coverage Keyword - Not Transfer Keyword
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
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords | empty                                      |
    And Operator add keywords on Station Route Keyword page:
      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    Then Operator verifies that success react notification displayed:
      | top | Keywords added |
    Then Operator verify data on New coverage created dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywordsAdded  | 0 keyword(s) added                           |
    When Operator close New coverage created dialog
    Then Operator verify there are no keywords on Add Keywords tab on Station Route Keyword page
    Then DB Operator verifies that route_qa_gl/sr_keywords records were deleted:
      | coverageId                   | value                                         |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op