@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @CreateDriver
Feature: Middle Mile Driver Management - Create Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteMiddleMileDriver
  Scenario: Create Driver - SG (uid:0252d293-a253-4cf4-854e-d626e1df9a61)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    And Operator create new Middle Mile Driver with details:
      | name   | hub                     | contactNumber          | licenseNumber | employmentType            | username |
      | RANDOM | {mm-driver-hub-name-sg} | {default-phone-number} | RANDOM        | {default-employment-type} | RANDOM   |
    Then Operator verifies Middle Mile Driver with username "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    And Operator searches the "name" of "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]" and verifies the value is correct

#  @DeleteMiddleMileDriver
#  Scenario: Create Driver - ID (uid:e1e844f4-5af1-4238-b3a4-fe4c744ad43d)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator change the country to "Indonesia"
#    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
#    When Operator refresh Middle Mile Driver Page
#    And Operator verifies middle mile driver management page is loaded
#    And Operator create new Middle Mile Driver with details:
#      | name   | hub                     | contactNumber             | licenseNumber | employmentType            | username |
#      | RANDOM | {mm-driver-hub-name-id} | {default-phone-number-id} | RANDOM        | {default-employment-type} | RANDOM   |
#    Then Operator verifies Middle Mile Driver with username "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" has been created
#    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
#    Then Operator searches by "name" and verifies the created username
#
#  @DeleteMiddleMileDriver
#  Scenario: Create Driver - TH (uid:6f24e1a6-75bd-41b4-913b-5563c477752c)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator change the country to "Thailand"
#    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
#    When Operator refresh Middle Mile Driver Page
#    And Operator verifies middle mile driver management page is loaded
#    And Operator create new Middle Mile Driver with details:
#      | name   | hub                     | contactNumber             | licenseNumber | employmentType            | username |
#      | RANDOM | {mm-driver-hub-name-th} | {default-phone-number-th} | RANDOM        | {default-employment-type} | RANDOM   |
#    Then Operator verifies Middle Mile Driver with username "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" has been created
#    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
#    Then Operator searches by "name" and verifies the created username
#
#  @DeleteMiddleMileDriver
#  Scenario: Create Driver - MY (uid:5bfb5eea-4c70-4116-b5a6-892b1b6fe946)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator change the country to "Malaysia"
#    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
#    When Operator refresh Middle Mile Driver Page
#    And Operator verifies middle mile driver management page is loaded
#    And Operator create new Middle Mile Driver with details:
#      | name   | hub                     | contactNumber             | licenseNumber | employmentType            | username |
#      | RANDOM | {mm-driver-hub-name-my} | {default-phone-number-my} | RANDOM        | {default-employment-type} | RANDOM   |
#    Then Operator verifies Middle Mile Driver with username "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" has been created
#    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
#    Then Operator searches by "name" and verifies the created username
#
#  @DeleteMiddleMileDriver
#  Scenario: Create Driver - VN (uid:d618bb76-9b58-48e5-a44d-9e5660125919)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator change the country to "Vietnam"
#    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
#    When Operator refresh Middle Mile Driver Page
#    And Operator verifies middle mile driver management page is loaded
#    And Operator create new Middle Mile Driver with details:
#      | name   | hub                     | contactNumber             | licenseNumber | employmentType            | username |
#      | RANDOM | {mm-driver-hub-name-vn} | {default-phone-number-vn} | RANDOM        | {default-employment-type} | RANDOM   |
#    Then Operator verifies Middle Mile Driver with username "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" has been created
#    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
#    Then Operator searches by "name" and verifies the created username
#
#  @DeleteMiddleMileDriver
#  Scenario: Create Driver - PH (uid:a71701f7-654d-476f-a412-c4302fcc3adb)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator change the country to "Philippines"
#    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
#    When Operator refresh Middle Mile Driver Page
#    And Operator verifies middle mile driver management page is loaded
#    And Operator create new Middle Mile Driver with details:
#      | name   | hub                     | contactNumber             | licenseNumber | employmentType            | username |
#      | RANDOM | {mm-driver-hub-name-ph} | {default-phone-number-ph} | RANDOM        | {default-employment-type} | RANDOM   |
#    Then Operator verifies Middle Mile Driver with username "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" has been created
#    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
#    Then Operator searches by "name" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: Create Driver with existing Driver's username (uid:5cb46c58-8e7c-45c2-ae3a-50c40cdbc72f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Given API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    And Operator create new Middle Mile Driver with details:
      | name   | hub                     | contactNumber          | licenseNumber | employmentType            | username                                                 |
      | RANDOM | {mm-driver-hub-name-sg} | {default-phone-number} | RANDOM        | {default-employment-type} | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} |
    Then Operator verifies "Username already registered" error notification is shown on Middle Mile Drivers Page
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    And Operator selects "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].hubName}" for the hub on the Middle Mile Drivers page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches and verifies driver with username "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].displayName}" is not exist

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op