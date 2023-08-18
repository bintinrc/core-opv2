@Sort @Routing @ZonesPolygonPart2
Feature: Zones Polygon

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk Edit Polygons - Invalid KML Structure
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    And Zones page is loaded
    When Operator clicks Bulk Edit Polygons button
    Then Operator make sure Bulk Edit Polygons dialog shows up
    When Operator upload a KML file "invalid-structure.kml"
    Then Operator make sure dialog shows error: "Zone IDs with invalid latlong"
    And Operator make sure error on Zone is : "Error parsing the KML"

  Scenario: Bulk Edit Polygons - Unfinished Polygon
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    And Zones page is loaded
    When Operator clicks Bulk Edit Polygons button
    Then Operator make sure Bulk Edit Polygons dialog shows up
    When Operator upload a KML file "unfinished-poly.kml"
    Then Operator make sure dialog shows error: "Zone IDs with invalid latlong"

  Scenario: Bulk Edit Polygons - Zone Does Not Exist
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    And Zones page is loaded
    When Operator clicks Bulk Edit Polygons button
    Then Operator make sure Bulk Edit Polygons dialog shows up
    When Operator upload a KML file "invalid-zone.kml"
    Then Operator make sure dialog shows error: "Zone IDs with invalid latlong"

  Scenario: Bulk Edit Polygons - Duplicate Zone ID
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    And Zones page is loaded
    When Operator clicks Bulk Edit Polygons button
    Then Operator make sure Bulk Edit Polygons dialog shows up
    When Operator upload a KML file "duplicate-zones.kml"
    Then Operator make sure dialog shows error: "Duplicated Zone IDs"

  Scenario: Bulk Edit Polygons - Multi Polygon Zone with Empty Coordinates
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    And Zones page is loaded
    When Operator clicks Bulk Edit Polygons button
    Then Operator make sure Bulk Edit Polygons dialog shows up
    When Operator upload a KML file "zone-multi-poly-with-empty-polygon.kml"
    Then Operator make sure dialog shows error: "Zone IDs with invalid latlong"
    And Operator make sure error on Zone is : "Each polygon must have at least 4 points declared"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op