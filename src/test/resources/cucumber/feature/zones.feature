@Zones @selenium
Feature: Zones

  @LaunchBrowser @Zones#01 @Zones#02 @Zones#03
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @Zones#01
  Scenario: Operator create, update and delete Zone (uid:54bc8b8b-ceea-4a5e-b29d-2745c60272cd)
    Given Operator go to menu "Routing" -> "Zones"
    When Operator create new Zone using Hub "30JKB"
    Then Operator verify the new Zone is created successfully
    When Operator refresh page
    When Operator update the new Zone
    Then Operator verify the new Zone is updated successfully
    When Operator refresh page
    When Operator delete the new Zone
    Then Operator verify the new Zone is deleted successfully

  @Zones#02
  Scenario: Operator check all filters on Zones page work fine (uid:379847a0-e092-46d8-8d7a-6318132a6ff4)
    Given Operator go to menu "Routing" -> "Zones"
    When Operator create new Zone using Hub "30JKB"
    Then Operator verify the new Zone is created successfully
    And Operator check all filters on Zones page work fine
    When Operator refresh page
    When Operator delete the new Zone
    Then Operator verify the new Zone is deleted successfully

  @Zones#03
  Scenario: Operator download and verify Zone CSV file (uid:61ef9207-8298-444f-a6f3-e18e4020d2fe)
    Given Operator go to menu "Routing" -> "Zones"
    When Operator create new Zone using Hub "30JKB"
    Then Operator verify the new Zone is created successfully
    When Operator download Zone CSV file
    Then Operator verify Zone CSV file downloaded successfully
    When Operator refresh page
    When Operator delete the new Zone
    Then Operator verify the new Zone is deleted successfully

  @KillBrowser @Zones#01 @Zones#02 @Zones#03
  Scenario: Kill Browser
