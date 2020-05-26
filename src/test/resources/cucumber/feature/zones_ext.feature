@OperatorV2 @Routing @OperatorV2Part1 @ZonesExt @Saas
Feature: Zones Ext

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator view multiple selected Polygon (uid:b2341f2c-a5af-45f7-839c-a820c0cc6c34)
    Given Operator go to menu Routing -> Zones
    When Operator click View Selected Polygons for zone "{zone-name}"
    And Operator remove zone "{zone-name-2}" if it is added on View Selected Polygons page
    And Operator add new "{zone-name-2}" zone on View Selected Polygons page
    Then Operator verify zone "{zone-name-2}" is selected on View Selected Polygons page
    Then Operator verify count of selected zones is 2 on View Selected Polygons page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
