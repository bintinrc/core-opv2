@MiddleMileDrivers @MiddleMile
Feature: Shipment Inbound Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: OP load all drivers (uid:b1200b6c-b3ee-4d60-9a8e-df5ec1367840)
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Given API Driver get all middle mile driver
    When Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator verifies that the data shown has the same value

  Scenario: OP load driver use filter - Hub (uid:3ba0e0a8-6111-433d-962a-5c21f8e90e7c)
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    Given Operator get info of hub details id "{hub-id}"
    Given API Driver get all middle mile driver using hub filter with value "{hub-id}"
    When Operator selects the hub on the Middle Mile Drivers Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator verifies that the data shown has the same value

  @DeleteMiddleMileDriver
  Scenario: OP load driver use filter - Employment status active (uid:ce1af41e-847d-4a87-9ac9-a0a0ae3ae492)
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
