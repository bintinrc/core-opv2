@Sort @Routing @FirstMileZonesPolygon
Feature: Fist Mile Zones

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk Edit Polygons - First Mile Zone Does Not Exist
    Given Operator go to menu Routing -> First Mile Zones
    And Operator refresh page v1
    When Operator clicks Bulk Edit Polygons button in First Mile Zones Page
    And Operator upload a KML file "invalid-zone.kml" in First Mile Zones
    Then Operator verifies that error react notification displayed in First Mile Zones Page:
      | top | Unknown Error                     |
      | bot | {error-first-mile-zone-not-found} |

  Scenario: Bulk Edit Polygons - Duplicate First Mile Zone ID
    Given Operator go to menu Routing -> First Mile Zones
    And Operator refresh page v1
    When Operator clicks Bulk Edit Polygons button in First Mile Zones Page
    And Operator upload a KML file "duplicate-first-mile-zones.kml" in First Mile Zones
    Then Operator verifies that error react notification displayed in First Mile Zones Page:
      | top | Unknown Error                     |
      | bot | {error-first-mile-zone-duplicate} |

  Scenario: Bulk Edit Polygons - Single First Mile Zones - Multi Polygon
    Given Operator go to menu Routing -> First Mile Zones
    And Operator refresh page v1
    When Operator clicks Bulk Edit Polygons button in First Mile Zones Page
    And Operator upload a KML file "first-mile-zone-single-multi-poly.kml" in First Mile Zones
    And Operator clicks save button in first mile zone drawing page
    And Operator click View Selected Polygons for First Mile Zones name "{first-mile-zone-name}"
    Then Make sure First Mile Zone updated with correct vertex count "{first-mile-zone-single-multi-poly-vertex}"
    When API Sort - Operator Get Polygon of First Mile Zones by Id "{first-mile-zone-id}"
    Then Operator verifies first mile zone polygon details:
      | expected               | actual                                   |
      | {first-mile-zone-name} | {KEY_SORT_ZONE_POLYGONS_AS_JSON.name}    |
      | {single-multi-polygon} | {KEY_SORT_ZONE_POLYGONS_AS_JSON.polygon} |

  Scenario: Bulk Edit Polygons - Single First Mile Zones - Simple Polygon
    Given Operator go to menu Routing -> First Mile Zones
    And Operator refresh page v1
    When Operator clicks Bulk Edit Polygons button in First Mile Zones Page
    And Operator upload a KML file "first-mile-zone-single-simple-poly.kml" in First Mile Zones
    And Operator clicks save button in first mile zone drawing page
    And Operator click View Selected Polygons for First Mile Zones name "{first-mile-zone-name}"
    Then Make sure First Mile Zone updated with correct vertex count "{first-mile-zone-single-simple-poly-vertex}"
    When API Sort - Operator Get Polygon of First Mile Zones by Id "{first-mile-zone-id}"
    Then Operator verifies first mile zone polygon details:
      | expected               | actual                                   |
      | {first-mile-zone-name} | {KEY_SORT_ZONE_POLYGONS_AS_JSON.name}    |
      | {single-multi-polygon} | {KEY_SORT_ZONE_POLYGONS_AS_JSON.polygon} |

  Scenario: Bulk Edit Polygons - Multiple First Mile Zone - Mix Polygon (Simple and Multi)
    Given Operator go to menu Routing -> First Mile Zones
    And Operator refresh page v1
    When Operator clicks Bulk Edit Polygons button in First Mile Zones Page
    And Operator upload a KML file "first-mile-zone-many-mix-poly.kml" in First Mile Zones
    And Operator clicks save button in first mile zone drawing page
    And Operator click View Selected Polygons for First Mile Zones name "{first-mile-zone-name}"
    Then Make sure First Mile Zone updated with correct vertex count "{first-mile-zone-many-mix-poly-vertex-1}"
    When Operator go to menu "Routing" -> "First Mile Zones"
    And Operator click View Selected Polygons for First Mile Zones name "{first-mile-zone-name-2}"
    Then Make sure First Mile Zone updated with correct vertex count "{first-mile-zone-many-mix-poly-vertex-2}"
    When Operator go to menu "Routing" -> "First Mile Zones"
    And Operator click View Selected Polygons for First Mile Zones name "{first-mile-zone-name-3}"
    Then Make sure First Mile Zone updated with correct vertex count "{first-mile-zone-many-mix-poly-vertex-3}"
    When API Sort - Operator Get Polygon of First Mile Zones by Id "{first-mile-zone-id}"
    Then Operator verifies first mile zone polygon details:
      | expected               | actual                                   |
      | {first-mile-zone-name} | {KEY_SORT_ZONE_POLYGONS_AS_JSON.name}    |
      | {many-mix-polygon-1}   | {KEY_SORT_ZONE_POLYGONS_AS_JSON.polygon} |
    When API Sort - Operator Get Polygon of First Mile Zones by Id "{first-mile-zone-id-2}"
    Then Operator verifies first mile zone polygon details:
      | expected                 | actual                                   |
      | {first-mile-zone-name-2} | {KEY_SORT_ZONE_POLYGONS_AS_JSON.name}    |
      | {many-mix-polygon-2}     | {KEY_SORT_ZONE_POLYGONS_AS_JSON.polygon} |
    When API Sort - Operator Get Polygon of First Mile Zones by Id "{first-mile-zone-id-3}"
    Then Operator verifies first mile zone polygon details:
      | expected                 | actual                                   |
      | {first-mile-zone-name-3} | {KEY_SORT_ZONE_POLYGONS_AS_JSON.name}    |
      | {many-mix-polygon-3}     | {KEY_SORT_ZONE_POLYGONS_AS_JSON.polygon} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op