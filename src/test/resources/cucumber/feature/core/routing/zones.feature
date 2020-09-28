@OperatorV2 @Core @Routing @Zones
Feature: Zones

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedZone
  Scenario: Operator Create New Zone (uid:985217e6-7dd4-4d15-80b6-e97d6f7cf587)
    Given Operator go to menu "Routing" -> "Zones"
    When Operator create new Zone using Hub "{hub-name}"
    Then Operator verify the new Zone is created successfully

  @DeleteCreatedZone
  Scenario: Operator Update Existing Zone (uid:c0c4871b-cddf-4108-a081-92e6da5293c5)
    Given Operator go to menu "Routing" -> "Zones"
    When Operator create new Zone using Hub "{hub-name}"
    Then Operator verify the new Zone is created successfully
    When Operator refresh page
    When Operator update the new Zone
    Then Operator verify the new Zone is updated successfully

  Scenario: Operator Delete Existing Zone (uid:79edb638-e0d0-4e3a-8b2e-4a9c219b0127)
    Given Operator go to menu "Routing" -> "Zones"
    When Operator create new Zone using Hub "{hub-name}"
    Then Operator verify the new Zone is created successfully
    When Operator refresh page
    When Operator delete the new Zone
    Then Operator verify the new Zone is deleted successfully

  @DeleteCreatedZone
  Scenario: Operator View All Zones & Check All Zone Filters Work Fine (uid:47f3e68f-b4c9-4fac-89ca-5eb556e1d370)
    Given Operator go to menu "Routing" -> "Zones"
    When Operator create new Zone using Hub "{hub-name}"
    Then Operator verify the new Zone is created successfully
    And Operator check all filters on Zones page work fine

  @DeleteCreatedZone
  Scenario: Operator Download and Verify Zone CSV File (uid:d744808c-798a-404c-ab4e-b7a79406d79d)
    Given Operator go to menu "Routing" -> "Zones"
    When Operator create new Zone using Hub "{hub-name}"
    Then Operator verify the new Zone is created successfully
    When Operator download Zone CSV file
    Then Operator verify Zone CSV file is downloaded successfully

  Scenario: Operator View Multiple Selected Polygon (uid:caae6aa0-2f25-4908-b5d7-96559c540854)
    Given Operator go to menu Routing -> Zones
    When Operator click View Selected Polygons for zone "{zone-name}"
    And Operator remove zone "{zone-name-2}" if it is added on View Selected Polygons page
    And Operator add new "{zone-name-2}" zone on View Selected Polygons page
    Then Operator verify zone "{zone-name-2}" is selected on View Selected Polygons page
    Then Operator verify count of selected zones is 2 on View Selected Polygons page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
