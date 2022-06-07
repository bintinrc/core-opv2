@Sort @Routing @ZonesPolygon @cwf @run
Feature: Zones Polygon

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk Edit Polygons - Single Zone - Multi Polygon
    Given Operator go to menu Routing -> Zones
    And Operator refresh page v1
    And Zones page is loaded
    When Operator clicks Bulk Edit Polygons button

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op