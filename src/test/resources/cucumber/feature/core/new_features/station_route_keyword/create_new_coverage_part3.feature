@OperatorV2 @Core @Route @NewFeatures @StationRouteKeyword @StationRoute @CreateNewCoveragePart3
Feature: Create New Coverage

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Multiple Duplicate Area and Area Variation - Some Have Empty Keyword - Transfer Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}             |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariation  | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName}    |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                                                             |
      | bottom | ^.*Error Message: cannot delete all keywords of current coverage\. \[area: AREA {gradle-current-date-yyyyMMddHHmmsss}\]: there is another existing coverage with the same area and no keyword.* |
    And DB Route - verify that sr_coverages record is not created:
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[3].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[4].id}        |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Multiple Duplicate Area and Area Variation - Some Have Empty Keyword - Not Transfer Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}             |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariation  | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | keyword        | Keyword {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName}    |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName}    |
    Then Operator verify data on Transfer duplicate keywords dialog:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                                                                   |
      | bottom | ^.*Error Message: cannot create current coverage. Please adjust your input. \[area: AREA {gradle-current-date-yyyyMMddHHmmsss}\]: there is another existing coverage with the same area and n\.\.\..* |
    And DB Route - verify that sr_coverages record is not created:
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[3].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[4].id}        |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Empty Area Variation, and Duplicate Keyword - Not Transfer Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | keyword        | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName}  |
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
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName} |
      | keywordsAdded  | 0 keyword(s) added                           |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName} |
      | keywords       |                                              |
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[3].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[4].id}        |
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Empty Area Variation, and Duplicate Keyword - Transfer Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                        |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | keyword        | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName}  |
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
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywords       |                                              |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[3].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[4].id}        |
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Empty Area Variation, and Duplicate Keyword - Not Transfer Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                      |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}           |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}           |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | keyword        | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName}  |
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
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName} |
      | keywordsAdded  | 0 keyword(s) added                           |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName} |
      | keywords       |                                              |
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[3].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[4].id}        |
    And DB Route - verify that sr_area_variations record is not created for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Creates New Coverage on Station Route Keyword - Duplicate Area, Duplicate Empty Area Variation, and Duplicate Keyword - Transfer Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                      |
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | keywords         | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}           |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}           |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator create new coverage on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | keyword        | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName}  |
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
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator close New coverage created dialog
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | keywords       |                                              |
    Then Operator verify coverage displayed on Station Route Keyword page:
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss}    |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[3].getFullName}  |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[4].getFullName}  |
      | keywords       | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that sr_keywords record is not created for "{KEY_COVERAGE_ID}" coverageId
    And DB Route - verify that sr_area_variations record is not created for "AREA {gradle-current-date-yyyyMMddHHmmsss}" area
    And DB Route - verify that sr_coverages record is created:
      | area             | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId            | {hub-id}                                   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[3].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[4].id}        |
    And DB Operator verifies that route_qa_gl/sr_keywords record is created:
      | coverageId | {KEY_COVERAGE_ID}                             |
      | value      | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op