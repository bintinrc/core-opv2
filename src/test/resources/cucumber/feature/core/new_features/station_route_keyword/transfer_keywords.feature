@OperatorV2 @Route @NewFeatures @StationRouteKeyword @StationRoute
Feature: Transfer Keywords

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Transfer Keywords for Coverage on Station Route Keyword - Coverages found - Single Keyword
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                                                                                                                        |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}                                                                                                      |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}                                                                                             |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}, Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}, Keyword 3 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                                                                                                             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                                                                                                             |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 4 {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 5 {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss}    |
      | keywords | Keyword {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator transfer keywords on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify keywords on Transfer keywords dialog:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verify coverages on Transfer keywords dialog:
      | area                                       | keywords                                        | primaryDriver                                | fallbackDriver                               |
      | AREA {gradle-current-date-yyyyMMddHHmmsss} | KEYWORD 4 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | AREA {gradle-current-date-yyyyMMddHHmmsss} | KEYWORD 5 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
    When Operator select coverage on Transfer keywords dialog:
      | AREA {gradle-current-date-yyyyMMddHHmmsss} | KEYWORD 4 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator click 'Yes, transfer' button on Transfer keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords transferred                                                 |
      | bottom | 1 keywords transferred to AREA {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_keywords records were deleted:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE_ID[1]} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Transfer Keywords for Coverage on Station Route Keyword - Coverages found - Multiple Keywords
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                                                                                                                        |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}                                                                                                      |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}                                                                                             |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}, Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}, Keyword 3 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                                                                                                             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                                                                                                             |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 4 {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 5 {gradle-current-date-yyyyMMddHHmmsss}     |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss}    |
      | keywords | Keyword {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator transfer keywords on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify keywords on Transfer keywords dialog:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verify coverages on Transfer keywords dialog:
      | area                                       | keywords                                        | primaryDriver                                | fallbackDriver                               |
      | AREA {gradle-current-date-yyyyMMddHHmmsss} | KEYWORD 4 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | AREA {gradle-current-date-yyyyMMddHHmmsss} | KEYWORD 5 {gradle-current-date-yyyyMMddHHmmsss} | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
    When Operator select coverage on Transfer keywords dialog:
      | AREA {gradle-current-date-yyyyMMddHHmmsss} | KEYWORD 4 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator click 'Yes, transfer' button on Transfer keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords transferred                                                 |
      | bottom | 2 keywords transferred to AREA {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_keywords records were deleted:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE_ID[1]} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | {KEY_LIST_OF_COVERAGE_ID[1]} | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Transfer Keywords for Coverage on Station Route Keyword - No coverages found
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                                                                                                                        |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}                                                                                                      |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}                                                                                             |
      | keywords         | Keyword {gradle-current-date-yyyyMMddHHmmsss}, Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}, Keyword 3 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                                                                                                             |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                                                                                                             |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator transfer keywords on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify keywords on Transfer keywords dialog:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verify no coverages displayed on Transfer keywords dialog
    And Operator verify 'Yes, transfer' button is disabled on Transfer keywords dialog

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Transfer Keywords for Coverage on Station Route Keyword - No keyword found
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify there are no keywords to transfer on Station Route Keyword page

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Transfer Keywords for Coverage on Station Route Keyword - Coverage Found - Coverages Have Duplicate Empty Keyword
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
      | hubId            | {hub-id}                                                                                         |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}                                                       |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss}                                              |
      | keywords         | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}, Keyword 3 {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                                                              |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                                                              |
    And API Operator create new coverage:
      | hubId            | {hub-id}                                            |
      | area             | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area     | Area {gradle-current-date-yyyyMMddHHmmsss}                                                       |
      | keywords | Keyword 2 {gradle-current-date-yyyyMMddHHmmsss}, Keyword 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator transfer keywords on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify keywords on Transfer keywords dialog:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | KEYWORD 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verify coverages on Transfer keywords dialog:
      | area                                       | keywords                                      | primaryDriver                                | fallbackDriver                               |
      | AREA {gradle-current-date-yyyyMMddHHmmsss} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
      | AREA {gradle-current-date-yyyyMMddHHmmsss} |                                               | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
    When Operator select coverage on Transfer keywords dialog:
      | AREA {gradle-current-date-yyyyMMddHHmmsss} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator click 'Yes, transfer' button on Transfer keywords dialog
    And Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                                                                                                                                                            |
      | bottom | ^.*Error Message: cannot transfer all keywords of current coverage \[area=AREA {gradle-current-date-yyyyMMddHHmmsss}\]: there is another existing coverage with the same area and no keyword.* |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Transfer Keywords for Coverage on Station Route Keyword - Coverage Found - Coverages Have Duplicate Empty Area Variation
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
    And Operator transfer keywords on Station Route Keyword page:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verify keywords on Transfer keywords dialog:
      | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verify coverages on Transfer keywords dialog:
      | area                                       | keywords                                      | primaryDriver                                | fallbackDriver                               |
      | AREA {gradle-current-date-yyyyMMddHHmmsss} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} | {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} | {KEY_LIST_OF_CREATED_DRIVERS[2].getFullName} |
    When Operator select coverage on Transfer keywords dialog:
      | AREA {gradle-current-date-yyyyMMddHHmmsss} | KEYWORD {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator click 'Yes, transfer' button on Transfer keywords dialog
    And Operator verifies that success react notification displayed:
      | top    | Keywords transferred                                                 |
      | bottom | 1 keywords transferred to AREA {gradle-current-date-yyyyMMddHHmmsss} |
    Then DB Operator verifies that route_qa_gl/sr_keywords records are created:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE_ID[1]} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_keywords records were deleted:
      | coverageId                   | value                                           |
      | {KEY_LIST_OF_COVERAGE_ID[2]} | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op