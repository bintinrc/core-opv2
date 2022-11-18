@Sort @Routing @ZonesPolygon
Feature: Zones Polygon

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk Edit Polygons - Single Zone - Multi Polygon
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    When Operator successfully upload a KML file "zone-single-simple-poly.kml"
    Then Operator make sure zones from KML file are listed correctly
      | zones | {polygon-single-simple-zones} |
    When Operator clicks save button in zone drawing page
    Then DB Operator verifies zones polygons are "updated"
    And DB Operator remove polygons from zones

  Scenario: Bulk Edit Polygons - Multiple Zones - Simple Polygon
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    When Operator successfully upload a KML file "zone-many-simple-poly.kml"
    Then Operator make sure zones from KML file are listed correctly
      | zones | {polygon-many-simple-zones} |
    And Operator clicks save button in zone drawing page
    Then DB Operator verifies zones polygons are "updated"
    And DB Operator remove polygons from zones

  Scenario: Bulk Edit Polygons - Single Zone - Multi Polygon
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    When Operator successfully upload a KML file "zone-single-multi-poly.kml"
    Then Operator make sure zones from KML file are listed correctly
      | zones | {polygon-single-multi-zones} |
    And Operator clicks save button in zone drawing page
    Then DB Operator verifies zones polygons are "updated"
    And DB Operator remove polygons from zones

  Scenario: Bulk Edit Polygons - Multiple Zones - Multi Polygon
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    When Operator successfully upload a KML file "zone-many-multi-poly.kml"
    Then Operator make sure zones from KML file are listed correctly
      | zones | {polygon-many-multi-zones} |
    And Operator clicks save button in zone drawing page
    Then DB Operator verifies zones polygons are "updated"
    And DB Operator remove polygons from zones

  Scenario: Bulk Edit Polygons - Multiple Zones - Mix Polygon (Simple and Multi)
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    When Operator successfully upload a KML file "zone-many-mix-poly.kml"
    Then Operator make sure zones from KML file are listed correctly
      | zones | {polygon-many-mix-zones} |
    And Operator clicks save button in zone drawing page
    Then DB Operator verifies zones polygons are "updated"
    And DB Operator remove polygons from zones

  Scenario: Bulk Edit Polygons - Invalid KML Structure
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator refresh page v1
    And Zones page is loaded
    When Operator clicks Bulk Edit Polygons button
    Then Operator make sure Bulk Edit Polygons dialog shows up
    When Operator upload a KML file "invalid-structure.kml"
    Then Operator make sure error popup on zones page shows up: "The kml file has invalid format."

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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op