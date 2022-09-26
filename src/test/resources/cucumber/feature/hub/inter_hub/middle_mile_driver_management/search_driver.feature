@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @SearchDriver
Feature: Middle Mile Driver Management - Search Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Load All Drivers (uid:fc8158aa-ed1c-4c94-866a-bb4ced22ab35)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page on "https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?showall=true"

  @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Load Driver by Filter - Hub (uid:c629d70f-53d3-4327-805f-e988e6b1e25c)
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{KEY_CREATED_HUB.id},"hub":"{KEY_CREATED_HUB.name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator get info of hub details string id "{KEY_CREATED_HUB.id}"
    Given API Driver get all middle mile driver using hub filter with value "{KEY_CREATED_HUB.id}"
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?hubIds=<id> |
      | Hub | {KEY_HUB_INFO.name}                                                    |

  @DeleteDriver
  Scenario: Load Driver by Filter - Employment Status Active (uid:9d52e56e-6edf-437b-ac09-5e9ef38cf683)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active |
      | Employment Status | Active                                                                             |

  @DeleteDriver
  Scenario: Load Driver by Filter - Employment Status Inactive (uid:723b57eb-3d0b-421b-be8b-681078759a88)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-0-day-yyyy-MM-dd}"}} |
    And API Operator deactivate "employment status" for driver "{KEY_CREATED_DRIVER_ID}"
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=inactive |
      | Employment Status | Inactive                                                                             |

  @DeleteDriver
  Scenario: Load Driver by Filter - License Status Active (uid:dd6df1fc-da8a-49b8-9abd-6ad4d87622ad)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url            | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?licenseStatus=active |
      | License Status | Active                                                                          |

  @DeleteDriver
  Scenario: Load Driver by Filter - License Status Inactive (uid:3be300e1-e557-41f1-8dca-ba77bf01f1e9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-0-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator deactivate "license status" for driver "{KEY_CREATED_DRIVER_ID}"
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url            | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?licenseStatus=inactive |
      | License Status | Inactive                                                                          |

  @DeleteDriver
  Scenario: Load Driver by Filter - Employment Status Inactive and License Status Inactive (uid:f926dc6b-2165-444c-9f30-c0c35fa2c7db)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-0-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-0-day-yyyy-MM-dd}"}} |
    And API Operator deactivate "license status" for driver "{KEY_CREATED_DRIVER_ID}"
    And API Operator deactivate "employment status" for driver "{KEY_CREATED_DRIVER_ID}"
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=inactive&licenseStatus=inactive |
      | Employment Status | Inactive                                                                                                    |
      | License Status    | Inactive                                                                                                    |

  @DeleteDriver
  Scenario: Load Driver by Filter - Employment Status Active and License Status Active(uid:8a8df869-aa86-438d-9ad9-7e0ae0497d1b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&licenseStatus=active |
      | Employment Status | Active                                                                                                  |
      | License Status    | Active                                                                                                  |

  @DeleteDriver
  Scenario: Load Driver by Filter - Employment Status Inactive and License Status Active(uid:74fe1b41-427f-4d03-b263-bf4024b3df50)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-current-date-yyyy-MM-dd}"}} |
    And API Operator deactivate "employment status" for driver "{KEY_CREATED_DRIVER_ID}"
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=inactive&licenseStatus=active |
      | Employment Status | Inactive                                                                                                  |
      | License Status    | Active                                                                                                    |

  @DeleteDriver
  Scenario: Load Driver by Filter - Employment Status Active and License Status Inactive(uid:8fe481c5-13db-4dc6-be5b-9a7c67cc6c93)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-current-date-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator deactivate "license status" for driver "{KEY_CREATED_DRIVER_ID}"
    And API Driver get all middle mile driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&licenseStatus=inactive |
      | Employment Status | Active                                                                                                    |
      | License Status    | Inactive                                                                                                  |

  @DeleteDriver
  Scenario: Load Driver by Filter - Hub, Employment Status Inactive and License Status Inactive (uid:e1d54146-6e85-4b1b-884e-e7f1f9a89070)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator get info of hub details id "{hub-id}"
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-0-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-0-day-yyyy-MM-dd}"}} |
    And API Driver get all middle mile driver using hub filter with value "{hub-id}"
    And API Operator deactivate "license status" for driver "{KEY_CREATED_DRIVER_ID}"
    And API Operator deactivate "employment status" for driver "{KEY_CREATED_DRIVER_ID}"
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=inactive&hubIds=<id>&licenseStatus=inactive |
      | Hub               | {KEY_HUB_INFO.name}                                                                                                     |
      | Employment Status | Inactive                                                                                                                |
      | License Status    | Inactive                                                                                                                |

  @DeleteDriver
  Scenario: Search Driver on Search Field Name (uid:f1863d5a-2151-4430-98e0-228cbfbd9853)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field ID (uid:dcebd212-12c5-42e6-82fb-76e894f36d73)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "id" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field Username (uid:5975fcb7-c611-4aa3-9e01-5af1d3ea036b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "username" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field Hub (uid:e2590d24-9767-4daf-b9e7-148929184731)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "hub" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field Employment Type (uid:29cddc59-7ceb-4ccf-a850-581a6ed69ad3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "employment type" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field Employment Status (uid:edcf5cdb-1fd4-4b5f-9da4-2809758e28ca)
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "employment status" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field License Type (uid:2d12f8e0-a6e2-4738-8c70-f9118823ee78)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "license type" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field License Status (uid:3b4d5a2a-2838-46d0-a522-678ab24917e6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "license status" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field Comment (uid:813a82e7-0ce2-4206-b269-646dc2cc76bd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose {gradle-next-0-day-yyyy-MM-dd}","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator refresh drivers data
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "comments" and verifies the created username

  Scenario Outline: Sort Driver on Name column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "Name" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Name"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on ID column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "ID" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "ID"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on Username column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "Username" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Username"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on Hub column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "Hub" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Hub"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on Employment Type column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "Employment Type" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Employment Type"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on Employment Status column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "Employment Status" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Employment Status"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on License Type column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "License Type" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "License Type"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on License Status column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "License Status" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "License Status"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  @DeleteDriver
  Scenario: Load Driver by Filter - Click back/forward button(uid:8a8df869-aa86-438d-9ad9-7e0ae0497d1b)
#    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    When Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    When Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click on Browser back button
    Then Operator verifies the Employment Status is "Active" and License Status is "Active"
    When Operator click on Browser Forward button
    Then Operator verifies that list of middle mile drivers is shown
    And Operator verifies that the GUI elements are shown on the Middle Mile Driver Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op