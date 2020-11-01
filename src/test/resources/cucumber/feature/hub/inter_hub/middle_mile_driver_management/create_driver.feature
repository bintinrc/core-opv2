@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @CreateDriver
Feature: Middle Mile Driver Management - Create Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @hub @category-hub
  Scenario: Create Driver - SG (uid:0252d293-a253-4cf4-854e-d626e1df9a61)
    Given Operator change the country to "Singapore"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    And Operator create new Middle Mile Driver with details:
      | name   | hub           | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | COUNTRY_BASED | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @hub @category-hub
  Scenario: Create Driver - ID (uid:e1e844f4-5af1-4238-b3a4-fe4c744ad43d)
    Given Operator change the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    And Operator create new Middle Mile Driver with details:
      | name   | hub           | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | COUNTRY_BASED | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @hub @category-hub
  Scenario: Create Driver - TH (uid:6f24e1a6-75bd-41b4-913b-5563c477752c)
    Given Operator change the country to "Thailand"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    And Operator create new Middle Mile Driver with details:
      | name   | hub           | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | COUNTRY_BASED | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @hub @category-hub
  Scenario: Create Driver - MY (uid:5bfb5eea-4c70-4116-b5a6-892b1b6fe946)
    Given Operator change the country to "Malaysia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    And Operator create new Middle Mile Driver with details:
      | name   | hub           | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | COUNTRY_BASED | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @hub @category-hub
  Scenario: Create Driver - VN (uid:d618bb76-9b58-48e5-a44d-9e5660125919)
    Given Operator change the country to "Vietnam"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    And Operator create new Middle Mile Driver with details:
      | name   | hub           | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | COUNTRY_BASED | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @hub @category-hub
  Scenario: Create Driver - PH (uid:a71701f7-654d-476f-a412-c4302fcc3adb)
    Given Operator change the country to "Philippines"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    And Operator create new Middle Mile Driver with details:
      | name   | hub           | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | COUNTRY_BASED | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op