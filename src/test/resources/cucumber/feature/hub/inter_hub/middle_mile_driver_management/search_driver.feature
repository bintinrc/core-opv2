@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @SearchDriver
Feature: Middle Mile Driver Management - Search Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Load All Drivers (uid:fc8158aa-ed1c-4c94-866a-bb4ced22ab35)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API MM - Operator gets all Middle Mile Drivers
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page on "https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?showall=true"

  @DeleteDriver
  Scenario: Load Driver by Filter - Hub (uid:c629d70f-53d3-4327-805f-e988e6b1e25c)
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator gets all Middle Mile Drivers with Hub Id "{hub-id}"
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?hubIds={hub-id} |
      | Hub | {hub-name}                                                    |

  @DeleteDriver
  Scenario: Load Driver by Filter - Employment Status Active (uid:9d52e56e-6edf-437b-ac09-5e9ef38cf683)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API MM - Operator gets all Middle Mile Drivers
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
    And API MM - Operator gets all Middle Mile Drivers
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=inactive |
      | Employment Status | Inactive                                                                             |

  @DeleteDriver
  Scenario: Load Driver by Filter - License Status Active (uid:dd6df1fc-da8a-49b8-9abd-6ad4d87622ad)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API MM - Operator gets all Middle Mile Drivers
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
    And API MM - Operator gets all Middle Mile Drivers
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
    And API MM - Operator gets all Middle Mile Drivers
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
    And API MM - Operator gets all Middle Mile Drivers
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&licenseStatus=active |
      | Employment Status | Active                                                                                                  |
      | License Status    | Active                                                                                                  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op