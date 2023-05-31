@Sort @Routing @ZonesPart2
Feature: Zones

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedZone
  Scenario: Operator View All Zones & Check All Zone Filters Work Fine
    Given Operator go to menu Utilities -> QRCode Printing
    And API Sort - Operator create Addressing Zone with details:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    When Operator go to menu "Routing" -> "Last Mile and RTS Zones"
    Then Operator check all filters on Zones page work fine
      | shortName   | {KEY_SORT_CREATED_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_ZONE.description} |

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
    And API Sort - Operator create Addressing Zone with details:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    When Operator go to menu "Routing" -> "Last Mile and RTS Zones"
    And Operator update the new Zone
      | shortName   | {KEY_SORT_CREATED_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_ZONE.description} |
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
    And Operator find "{KEY_SORT_CREATED_ZONE.name}" zone on Zones page
    And Operator download Zone CSV file
    Then Operator verify Zone CSV file is downloaded successfully
      | shortName   | {KEY_SORT_CREATED_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_ZONE.hubName}     |

  Scenario: Set Coordinates Polygon of Normal Zone
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu "Routing" -> "Last Mile and RTS Zones"
    When Operator refresh page
    And Operator click View Selected Polygons for zone id "{zone-id-4}"
    And Operator click Zones in zone drawing page
    And Operator click Set Coordinates in zone drawing page
      | latitude  | {zone-latitude-3}  |
      | longitude | {zone-longitude-3} |
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu "Routing" -> "Last Mile and RTS Zones"
    When Operator refresh page
    And Operator find "{zone-name-4}" zone on Zones page
    Then Operator verifies zone details on Zones page:
      | shortName | {zone-short-name-4} |
      | name      | {zone-name-4}       |
      | hubName   | {sbm-hub}           |
      | latitude  | {zone-latitude-3}   |
      | longitude | {zone-longitude-3}  |
      | type      | STANDARD            |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
