@Sort @Routing @ZonesPart1
Feature: Zones

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedZone
  Scenario: Create Zone - RTS Type (uid:6e65d068-6884-4e72-8bf4-277bc94bb5ee)
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    When Operator creates "RTS" zone using "{hub-name}" hub
    Then Operator verifies that the newly created "RTS" zone's details are right

  @DeleteCreatedZone
  Scenario: Create Zone - Normal Type (uid:0d5e36c9-9e9c-4547-9339-04bbf3e7501c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    When Operator creates "Normal" zone using "{hub-name}" hub
    Then Operator verifies that success react notification displayed:
      | top | Zone created successfully |
    Then Operator verifies zone details on Zones page:
      | shortName   | {KEY_CREATED_ZONE.shortName}   |
      | name        | {KEY_CREATED_ZONE.name}        |
      | hubName     | {KEY_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_CREATED_ZONE.longitude}   |
      | description | {KEY_CREATED_ZONE.description} |
      | type        | STANDARD                       |
    Then Operator verifies that the newly created "Normal" zone's details are right

  @DeleteCreatedZone
  Scenario: Update Zone - Normal Type to RTS Type (uid:d60632a4-27d5-4f98-8d20-caf835a00474)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    When Operator creates "Normal" zone using "{hub-name}" hub
    Then Operator verifies that the newly created "Normal" zone's details are right
    When Operator changes the newly created Zone to be "RTS" zone
    Then Operator verifies that the newly created "RTS" zone's details are right

  @DeleteCreatedZone
  Scenario: Update Zone -  RTS Type to Normal Type (uid:44d1e3f5-fe53-4a8d-8354-09da276b9099)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    When Operator creates "RTS" zone using "{hub-name}" hub
    Then Operator verifies that the newly created "RTS" zone's details are right
    When Operator changes the newly created Zone to be "Normal" zone
    Then Operator verifies that the newly created "Normal" zone's details are right

  @DeleteCreatedZone
  Scenario: Delete Zone (uid:fa98df0c-2681-4c86-961b-de5a9ee19bdd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Sort - Operator create Addressing Zone with details:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator delete the new Zone
    And Operator verifies that success react notification displayed:
      | top | Zone Deleted Successfully |
    And Operator refresh page
    Then Operator verify the new Zone is deleted successfully

  @DeleteCreatedZone
  Scenario: Operator View All Zones & Check All Zone Filters Work Fine
    Given Operator go to menu Utilities -> QRCode Printing
    And API Sort - Operator create Addressing Zone with details:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    When Operator go to menu "Routing" -> "Last Mile and RTS Zones"
    Then Operator check all filters on Zones page work fine

  Scenario: Find and View Polygon of Normal Zone
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator click View Selected Polygons for zone id "{zone-id}"
    And Operator remove all selected zones on View Selected Polygons page
    And Operator add new "{zone-name-2}" zone on View Selected Polygons page
    Then Operator verify zone "{zone-name-2}" is selected on View Selected Polygons page
    And Operator verify count of selected zones is 1 on View Selected Polygons page

  @DeleteCreatedZone
  Scenario: Update Existing Zone Details
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create zone using data below:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    When Operator go to menu "Routing" -> "Last Mile and RTS Zones"
    And Operator update the new Zone
    Then Operator verifies zone details on Zones page:
      | shortName   | {KEY_EDITED_ZONE.shortName}   |
      | name        | {KEY_EDITED_ZONE.name}        |
      | hubName     | {KEY_EDITED_ZONE.hubName}     |
      | latitude    | {KEY_EDITED_ZONE.latitude}    |
      | longitude   | {KEY_EDITED_ZONE.longitude}   |
      | description | {KEY_EDITED_ZONE.description} |
      | type        | STANDARD                      |

  @DeleteCreatedZone
  Scenario: Operator Download and Verify Zone CSV File
    Given Operator go to menu Utilities -> QRCode Printing
    And API Sort - Operator create Addressing Zone with details:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    When Operator go to menu "Routing" -> "Last Mile and RTS Zones"
    And Operator find "{KEY_CREATED_ZONE.name}" zone on Zones page
    And Operator download Zone CSV file
    Then Operator verify Zone CSV file is downloaded successfully

  @DeleteCreatedZone
  Scenario: Set Coordinates Polygon of Normal Zone
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu "Routing" -> "Last Mile and RTS Zones"
    And API Sort - Operator create Addressing Zone with details:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    And Operator click View Selected Polygons for zone id "{KEY_CREATED_ZONE.id}"
    And Operator click Zones in zone drawing page
    And Operator click Create Polygon in zone drawing page
    And Operator click Set Coordinates in zone drawing page
      | latitude  | {zone-latitude-3}  |
      | longitude | {zone-longitude-3} |
    And Operator find "{KEY_CREATED_ZONE.name}" zone on Zones page
    Then Operator verifies zone details on Zones page:
      | shortName | {KEY_CREATED_ZONE.shortName} |
      | name      | {KEY_CREATED_ZONE.name}      |
      | hubName   | {KEY_CREATED_ZONE.hubName}   |
      | latitude  | {zone-latitude-3}            |
      | longitude | {zone-longitude-3}           |
      | type      | STANDARD                     |

  @DeleteCreatedZone
  Scenario: Set Coordinates Polygon of RTS Zone
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu "Routing" -> "Last Mile and RTS Zones"
    When Operator creates "RTS" zone using "{hub-name}" hub
    And Operator click View Selected Polygons for zone short name "{KEY_CREATED_ZONE.shortName}"
    And Operator click RTS Zones in zone drawing page
    And Operator click Create Polygon in zone drawing page
    And Operator click Set Coordinates in zone drawing page
      | latitude  | {zone-latitude-3}  |
      | longitude | {zone-longitude-3} |
    And Operator find "{KEY_CREATED_ZONE.name}" zone on Zones page
    Then Operator verifies zone details on Zones page:
      | shortName | {KEY_CREATED_ZONE.shortName} |
      | name      | {KEY_CREATED_ZONE.name}      |
      | hubName   | {KEY_CREATED_ZONE.hubName}   |
      | latitude  | {zone-latitude-3}            |
      | longitude | {zone-longitude-3}           |
      | type      | RTS                          |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
