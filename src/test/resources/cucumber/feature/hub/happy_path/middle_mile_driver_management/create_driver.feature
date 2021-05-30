@OperatorV2 @HappyPath @Hub @InterHub @MiddleMileDrivers @CreateDriver
Feature: Middle Mile Driver Management - Create Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Create Driver - SG (uid:e3373dc3-1505-476b-9d5c-45091c0f356c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    And Operator create new Middle Mile Driver with details:
      | name   | hub                     | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | {mm-driver-hub-name-sg} | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    Then Operator verifies that the new Middle Mile Driver has been created
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "name" and verifies the created username

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op