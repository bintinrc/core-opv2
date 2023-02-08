@OperatorV2 @Route @NewFeatures @StationRouteKeyword @StationRoute
Feature: Edit Area

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area
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
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 500: Unknown                                                                                                                                                                                     |
      | bottom | ^.*Error Message: More than one existing SrAreaVariation found by variation names \[areaNames: \[AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss}\], duplicatedVariationNames: \[AREAVARIA\.\.\..* |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area Variation
    Given Operator go to menu Utilities -> QRCode Printing
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
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | areaVariations | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 500: Unknown                                                                                                                                                                                     |
      | bottom | ^.*Error Message: More than one existing SrAreaVariation found by variation names \[areaNames: \[AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss}\], duplicatedVariationNames: \[AREAVARIATI\.\.\..* |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area and Duplicate Area Variation
    Given Operator go to menu Utilities -> QRCode Printing
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
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | Area {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                                                                    |
      | bottom | Area AREA {gradle-current-date-yyyyMMddHHmmsss} with variations AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE_ID[1]}               |
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE_ID[2]}               |
      | area           | AREA {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                   |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that sr_area_variations record is not created for "AREA 2 {gradle-current-date-yyyyMMddHHmmsss}" area

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Edit Area for Coverage on Station Route Keyword -  Duplicate Area and Duplicate Area Variation Do Not Match
    Given Operator go to menu Utilities -> QRCode Printing
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
    And API Operator create new coverage:
      | hubId            | {hub-id}                                              |
      | area             | Area 3 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations   | AreaVariation 3 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | Keyword 3 {gradle-current-date-yyyyMMddHHmmsss}       |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                   |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                   |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | Area 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations | AreaVariation 3 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 500: Unknown                                                                                                                                                                                     |
      | bottom | ^.*Error Message: More than one existing SrAreaVariation found by variation names \[areaNames: \[AREAVARIATION 3 {gradle-current-date-yyyyMMddHHmmsss}\], duplicatedVariationNames: \[AREAVARIA\.\.\..* |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - New Area
    Given Operator go to menu Utilities -> QRCode Printing
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
      | id             | {KEY_LIST_OF_COVERAGE_ID[1]}                 |
      | area           | AREA 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                     |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}          |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}          |
    And DB Operator verifies that sr_area_variations record is not created for "AREA 2 {gradle-current-date-yyyyMMddHHmmsss}" area

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - New Area Variation
    Given Operator go to menu Utilities -> QRCode Printing
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
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | areaVariations | AreaVariation {gradle-current-date-yyyyMMddHHmmsss},AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                                                                                                                           |
      | bottom | Area AREA {gradle-current-date-yyyyMMddHHmmsss} with variations AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss}, AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}            |
      | variationName | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - New Area and New Area Variation
    Given Operator go to menu Utilities -> QRCode Printing
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
    And Operator open coverage settings on Station Route Keyword page:
      | area | Area {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | area           | Area 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | areaVariations | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top    | Coverage updated                                                                                                        |
      | bottom | Area AREA 2 {gradle-current-date-yyyyMMddHHmmsss} with variations AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_coverages record is created:
      | id             | {KEY_LIST_OF_COVERAGE_ID[1]}                 |
      | area           | AREA 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | hubId          | {hub-id}                                     |
      | primaryDriver  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}          |
      | fallbackDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id}          |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is not created:
      | area          | AREA {gradle-current-date-yyyyMMddHHmmsss}          |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is not created:
      | area          | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}        |
      | variationName | AREAVARIATION {gradle-current-date-yyyyMMddHHmmsss} |
    And DB Operator verifies that route_qa_gl/sr_area_variations record is created:
      | area          | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}          |
      | variationName | AREAVARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |

  @DeleteDriver @DeleteCoverage
  Scenario: Operator Edit Area for Coverage on Station Route Keyword - Duplicate Area Variation with Exist Area
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
    And API Operator create new coverage:
      | hubId            | {hub-id}                                          |
      | area             | AREA 2 {gradle-current-date-yyyyMMddHHmmsss}      |
      | areaVariations   | VARIATION 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | KEYWORD 2 {gradle-current-date-yyyyMMddHHmmsss}   |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}               |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}               |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route-keyword"
    And Operator selects "{hub-name}" hub on Station Route Keyword page
    And Operator open coverage settings on Station Route Keyword page:
      | area | AREA 2 {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator edit area on Station Route Keyword page:
      | areaVariations | AREA {gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that error react notification displayed:
      | top    | Status 500: Unknown                                                                                                                                                                                                         |
      | bottom | ^.*Error Message: More than one existing area found by variation names \[areaNames: AREA {gradle-current-date-yyyyMMddHHmmsss}, duplicatedVariationNames: AREA {gradle-current-date-yyyyMMddHHmmsss}\]. Please adju\.\.\..* |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op