@Sort @Routing @ZonesPart1
Feature: Zones

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedZoneCommonV2
  Scenario: Create Zone - RTS Type (uid:6e65d068-6884-4e72-8bf4-277bc94bb5ee)
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    When Operator creates "RTS" zone using "{hub-name}" hub
    Then Operator verifies that the newly created "RTS" zone's details are right
      | name | {KEY_SORT_CREATED_ZONE.name} |

  @DeleteCreatedZoneCommonV2
  Scenario: Create Zone - Normal Type (uid:0d5e36c9-9e9c-4547-9339-04bbf3e7501c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    When Operator creates "Normal" zone using "{hub-name}" hub
    Then Operator verifies that success react notification displayed:
      | top | Zone created successfully |
    Then Operator verifies zone details on Zones page:
      | shortName   | {KEY_SORT_CREATED_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_ZONE.description} |
      | type        | STANDARD                            |
    Then Operator verifies that the newly created "Normal" zone's details are right
      | name | {KEY_SORT_CREATED_ZONE.name} |

  @DeleteCreatedZoneCommonV2
  Scenario: Create Zone - With Negative Lat Long
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    When Operator creates "Negative" zone using "{hub-name}" hub
    Then Operator verifies that success react notification displayed:
      | top | Zone created successfully |
    Then Operator verifies zone details on Zones page:
      | shortName   | {KEY_SORT_CREATED_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_ZONE.description} |
      | type        | STANDARD                            |
    Then Operator verifies that the newly created "Normal" zone's details are right
      | name | {KEY_SORT_CREATED_ZONE.name} |

  @DeleteCreatedZoneCommonV2
  Scenario: Update Zone - Normal Type to RTS Type (uid:d60632a4-27d5-4f98-8d20-caf835a00474)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    When Operator creates "Normal" zone using "{hub-name}" hub
    Then Operator verifies that the newly created "Normal" zone's details are right
      | name | {KEY_SORT_CREATED_ZONE.name} |
    When Operator changes the newly created Zone to be "RTS" zone
      | shortName   | {KEY_SORT_CREATED_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_ZONE.description} |
    Then Operator verifies that the newly created "RTS" zone's details are right
      | name | {KEY_SORT_CREATED_ZONE.name} |

  @DeleteCreatedZoneCommonV2
  Scenario: Update Zone -  RTS Type to Normal Type (uid:44d1e3f5-fe53-4a8d-8354-09da276b9099)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    When Operator creates "RTS" zone using "{hub-name}" hub
    Then Operator verifies that the newly created "RTS" zone's details are right
      | name | {KEY_SORT_CREATED_ZONE.name} |
    When Operator changes the newly created Zone to be "Normal" zone
      | shortName   | {KEY_SORT_CREATED_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_ZONE.description} |
    Then Operator verifies that the newly created "Normal" zone's details are right
      | name | {KEY_SORT_CREATED_ZONE.name} |

  @DeleteCreatedZoneCommonV2
  Scenario: Delete Zone (uid:fa98df0c-2681-4c86-961b-de5a9ee19bdd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Sort - Operator create Addressing Zone with details:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator delete the new Zone
      | name | {KEY_SORT_CREATED_ZONE.name} |
    And Operator verifies that success react notification displayed:
      | top | Zone Deleted Successfully |
    And Operator refresh page
    Then Operator verify the new Zone is deleted successfully
      | name | {KEY_SORT_CREATED_ZONE.name} |

  Scenario: Set Coordinates Polygon of RTS Zone
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu "Routing" -> "Last Mile and RTS Zones"
    When Operator refresh page
    And Operator click View Selected Polygons for zone id "{zone-id-5}"
    And Operator click RTS Zones in zone drawing page
    And Operator click Set Coordinates in zone drawing page
      | latitude  | {zone-latitude-3}  |
      | longitude | {zone-longitude-3} |
    And Operator find "{zone-name-5}" zone on Zones page
    Then Operator verifies zone details on Zones page:
      | shortName | {zone-short-name-5} |
      | name      | {zone-name-5}       |
      | hubName   | {sbm-hub}           |
      | latitude  | {zone-latitude-3}   |
      | longitude | {zone-longitude-3}  |
      | type      | RTS                 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
