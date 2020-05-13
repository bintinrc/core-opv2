@MiddleMileDrivers @MiddleMile @CWF
Feature: Shipment Inbound Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: OP load all drivers (uid:b1200b6c-b3ee-4d60-9a8e-df5ec1367840)
    Given API Driver gets all the driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Given API Driver get all middle mile driver
    When Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator verifies that the data shown has the same value

  Scenario: OP load driver use filter - Hub (uid:3ba0e0a8-6111-433d-962a-5c21f8e90e7c)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Given Operator get info of hub details id "{hub-id}"
    Given API Driver get all middle mile driver using hub filter with value "{hub-id}"
    When Operator selects the hub on the Middle Mile Drivers Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator verifies that the data shown has the same value

  @DeleteMiddleMileDriver
  Scenario: OP load driver use filter - Employment status active (uid:ce1af41e-847d-4a87-9ac9-a0a0ae3ae492)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
   Then Operator verifies that the new Middle Mile Driver has been created
   When Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
   And Operator clicks on Load Driver Button on the Middle Mile Driver Page
   Then Operator searches by "name" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP load driver use filter - Employment status inactive (uid:1952db73-7e36-4ad2-ad50-6383c604a7c9)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    When Operator selects the "Employment Status" with the value of "Inactive" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches and verifies the created username is not exist

  @DeleteMiddleMileDriver
  Scenario: OP load driver use filter - License status active (uid:fbdf36a2-33ff-4254-99d1-802657b975ff)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    When Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP load driver use filter - License status inactive (uid:e9127d39-a7bc-4fdd-bf4a-b7fd02e79292)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    When Operator selects the "License Status" with the value of "Inactive" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches and verifies the created username is not exist

  @DeleteMiddleMileDriver
  Scenario: OP load driver use filter - Employment status inactive and License status inactive (uid:3cd465fc-bbd6-49b6-9316-bb1c1a9516c9)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    When Operator selects the "Employment Status" with the value of "Inactive" on Middle Mile Driver Page
    When Operator selects the "License Status" with the value of "Inactive" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches and verifies the created username is not exist

  @DeleteMiddleMileDriver
  Scenario: OP load driver use filter - Hub, Employment status inactive, and License status inactive (uid:31dfe662-4d88-447b-8ae2-cf3066710062)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Given Operator get info of hub details id "{hub-id}"
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    When Operator selects the hub on the Middle Mile Drivers Page
    When Operator selects the "Employment Status" with the value of "Inactive" on Middle Mile Driver Page
    When Operator selects the "License Status" with the value of "Inactive" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator verifies that the data shown has the same value

  @DeleteMiddleMileDriver
  Scenario: OP search driver on search field - Name (uid:fe897814-06c8-451b-a38b-601e2be36074)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP search driver on search field - Id (uid:8a55a605-2166-4649-b790-f0a9bf9ca82f)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    When DB Operator gets the id of the created middle mile driver
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "id" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP search driver on search field - Username (uid:23fec188-a573-488c-99da-f4e126a3cab9)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "username" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP search driver on search field - Hub (uid:b09231ec-ad02-4664-917e-ebc71d70cd48)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "hub" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP search driver on search field - Employment type (uid:fbcc329f-50d4-4e5e-a092-33d22d8005d3)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "employment type" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP search driver on search field - Employment Status (uid:eb4c8e80-5b8e-4e0a-b357-7bc9407055d0)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "employment status" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP search driver on search field - License type (uid:08851b9a-2493-4f3f-9210-e0e858345b66)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "license type" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP search driver on search field - License Status (uid:5c1c74a7-0b87-45cc-93c8-5c581d987e9b)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "license status" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP search driver on search field - Comments (uid:a05ac645-3ab4-4aeb-892a-9f6a9e0b8a07)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "comments" and verifies the created username

  @DeleteMiddleMileDriver
  Scenario: OP view driver (uid:3e2aa7a5-43de-497a-bf54-7f0d408daf4b)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username
    When Operator clicks view button on the middle mile driver page
    Then Operator verifies that the details of the middle mile driver is true

  @DeleteMiddleMileDriver
  Scenario: OP update driver availability - From Yes to No (uid:40ff840d-6bf7-4809-bb0f-2cf496d91a36)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username
    When Operator clicks "No" button on the middle mile driver page
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same

  @DeleteMiddleMileDriver
  Scenario: OP update driver availability - From No to Yes (uid:32548420-9825-4f07-8635-8ce89710a2e2)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username
    When Operator clicks "No" button on the middle mile driver page
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same
    Given API Driver gets all the driver
    When Operator clicks "Yes" button on the middle mile driver page
    Given API Driver gets all the driver
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same

  @DeleteMiddleMileDriver
  Scenario: OP bulk update driver availability - Set all to active (uid:78e379a8-4e79-48df-b865-63a60dc2b38c)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username
    When Operator sets all selected middle mile driver to "Yes"
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same

  @DeleteMiddleMileDriver
  Scenario: OP bulk update driver availability - Set all to inactive (uid:345765bf-75cd-4011-8d08-72739262eae2)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator create new Middle Mile Driver with details:
      | name   | hub        | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {hub-name} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username
    When Operator sets all selected middle mile driver to "Yes"
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same
    Given API Driver gets all the driver
    When Operator sets all selected middle mile driver to "No"
    Given API Driver gets all the driver
    And Operator DB gets that the driver availability value
    Then Operator verifies that the driver availability's value is the same

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
