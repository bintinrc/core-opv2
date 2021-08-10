@Sort @Routing @Zones
Feature: Zones

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedZone
  Scenario: Create Zone - RTS Type (uid:6e65d068-6884-4e72-8bf4-277bc94bb5ee)
    Given Operator go to menu Routing -> Zones
    When Operator creates "RTS" zone using "{hub-name}" hub
    Then Operator verifies that the newly created "RTS" zone's details are right

  @DeleteCreatedZone
  Scenario: Create Zone - Normal Type (uid:0d5e36c9-9e9c-4547-9339-04bbf3e7501c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Zones
    When Operator creates "Normal" zone using "{hub-name}" hub
    Then Operator verifies that the newly created "Normal" zone's details are right

  @DeleteCreatedZone
  Scenario: Update Zone - Normal Type to RTS Type (uid:d60632a4-27d5-4f98-8d20-caf835a00474)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Zones
    When Operator creates "Normal" zone using "{hub-name}" hub
    Then Operator verifies that the newly created "Normal" zone's details are right
    When Operator changes the newly created Zone to be "RTS" zone
    Then Operator verifies that the newly created "RTS" zone's details are right

  @DeleteCreatedZone
  Scenario: Update Zone -  RTS Type to Normal Type (uid:44d1e3f5-fe53-4a8d-8354-09da276b9099)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Zones
    When Operator creates "RTS" zone using "{hub-name}" hub
    Then Operator verifies that the newly created "RTS" zone's details are right
    When Operator changes the newly created Zone to be "Normal" zone
    Then Operator verifies that the newly created "Normal" zone's details are right

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
