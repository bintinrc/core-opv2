@Sort @Routing @FirstMileZones
Feature: Fist Mile Zones

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedFirstMileZone
  Scenario: Create FM Zone
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone using "{hub-name}" hub
    Then Operator verifies that success react notification displayed:
      | top | Zone created successfully |
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_CREATED_ZONE.shortName}   |
      | name        | {KEY_CREATED_ZONE.name}        |
      | hubName     | {KEY_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_CREATED_ZONE.longitude}   |
      | description | {KEY_CREATED_ZONE.description} |

  Scenario: Delete FM Zone
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone using "{hub-name}" hub
    Then Operator verifies that success react notification displayed:
      | top | Zone created successfully |
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_CREATED_ZONE.shortName}   |
      | name        | {KEY_CREATED_ZONE.name}        |
      | hubName     | {KEY_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_CREATED_ZONE.longitude}   |
      | description | {KEY_CREATED_ZONE.description} |
    When Operator refresh page
    And Operator delete first mile zone
    Then Operator verify first mile zone is deleted successfully

  @DeleteCreatedFirstMileZone
  Scenario: Update Existing FM Zone Details
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone using "{hub-name}" hub
    Then Operator verifies that success react notification displayed:
      | top | Zone created successfully |
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_CREATED_ZONE.shortName}   |
      | name        | {KEY_CREATED_ZONE.name}        |
      | hubName     | {KEY_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_CREATED_ZONE.longitude}   |
      | description | {KEY_CREATED_ZONE.description} |
    When Operator refresh page
    And Operator update the first mile Zone
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_EDITED_ZONE.shortName}   |
      | name        | {KEY_EDITED_ZONE.name}        |
      | hubName     | {KEY_EDITED_ZONE.hubName}     |
      | latitude    | {KEY_EDITED_ZONE.latitude}    |
      | longitude   | {KEY_EDITED_ZONE.longitude}   |
      | description | {KEY_EDITED_ZONE.description} |

  @DeleteCreatedFirstMileZone
  Scenario: FM Zones - Operator View All Zones & Check All Zone Filters
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone using "{hub-name}" hub
    Then Operator verifies that success react notification displayed:
      | top | Zone created successfully |
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_CREATED_ZONE.shortName}   |
      | name        | {KEY_CREATED_ZONE.name}        |
      | hubName     | {KEY_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_CREATED_ZONE.longitude}   |
      | description | {KEY_CREATED_ZONE.description} |
    When Operator refresh page
    Then Operator check all filters on Fist Mile Zones page work fine

  Scenario: FM Zones - Operator should not be able to Add Zones with Empty Field
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone with empty field in one of the mandatory field
    Then Operator verifies Submit Button in First Mile Zone add dialog is Disabled

  @DeleteCreatedFirstMileZone
  Scenario: FM Zones - Operator should not be able to edit Zones with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone using "{hub-name}" hub
    Then Operator verifies that success react notification displayed:
      | top | Zone created successfully |
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_CREATED_ZONE.shortName}   |
      | name        | {KEY_CREATED_ZONE.name}        |
      | hubName     | {KEY_CREATED_ZONE.hubName}     |
      | latitude    | {KEY_CREATED_ZONE.latitude}    |
      | longitude   | {KEY_CREATED_ZONE.longitude}   |
      | description | {KEY_CREATED_ZONE.description} |
    When Operator refresh page
    When Operator update first mile zone with empty field in one of the mandatory field
    Then Operator verifies Submit Button in First Mile Zone edit dialog is Disabled

  @DeleteCreatedFirstMileZone
  Scenario: Set Coordinates Polygon of First Mile Zone
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu "Routing" -> "First Mile Zones"
    When Operator creates first mile zone using "{hub-name}" hub
    And Operator click View Selected Polygons for First Mile Zones name "{KEY_CREATED_ZONE.shortName}"
    And Operator click Zones in First Mile Zones drawing page
    And Operator click Create Polygon in First Mile Zones drawing page
    And Operator click Set Coordinates in First Mile Zones drawing page
      | latitude  | {zone-latitude-3}  |
      | longitude | {zone-longitude-3} |
    When Operator refresh page
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_CREATED_ZONE.shortName}   |
      | name        | {KEY_CREATED_ZONE.name}        |
      | hubName     | {KEY_CREATED_ZONE.hubName}     |
      | latitude    | {zone-latitude-3}              |
      | longitude   | {zone-longitude-3}             |
      | description | {KEY_CREATED_ZONE.description} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
