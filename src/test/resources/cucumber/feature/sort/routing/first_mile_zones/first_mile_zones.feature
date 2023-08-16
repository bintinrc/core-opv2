@Sort @Routing @FirstMileZones
Feature: Fist Mile Zones

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @DeleteCreatedFirstMileZoneCommonV2
  Scenario: Create FM Zone
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone using "{hub-name}" hub
    When Operator refresh page
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_FIRST_MILE_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_FIRST_MILE_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_FIRST_MILE_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_FIRST_MILE_ZONE.description} |

  Scenario: Delete FM Zone
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone using "{hub-name}" hub
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_FIRST_MILE_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_FIRST_MILE_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_FIRST_MILE_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_FIRST_MILE_ZONE.description} |
    When Operator refresh page
    And Operator delete first mile zone with "{KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}" short name
    Then Operator verify first mile zone with "{KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}" short name is deleted successfully

  @DeleteCreatedFirstMileZoneCommonV2
  Scenario: Update Existing FM Zone Details
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone using "{hub-name}" hub
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_FIRST_MILE_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_FIRST_MILE_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_FIRST_MILE_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_FIRST_MILE_ZONE.description} |
    When Operator refresh page
    And Operator update the first mile Zone
      | shortName   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_FIRST_MILE_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_FIRST_MILE_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_FIRST_MILE_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_FIRST_MILE_ZONE.description} |
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_SORT_EDITED_FIRST_MILE_ZONE.shortName}   |
      | name        | {KEY_SORT_EDITED_FIRST_MILE_ZONE.name}        |
      | hubName     | {KEY_SORT_EDITED_FIRST_MILE_ZONE.hubName}     |
      | latitude    | {KEY_SORT_EDITED_FIRST_MILE_ZONE.latitude}    |
      | longitude   | {KEY_SORT_EDITED_FIRST_MILE_ZONE.longitude}   |
      | description | {KEY_SORT_EDITED_FIRST_MILE_ZONE.description} |

  @DeleteCreatedFirstMileZoneCommonV2
  Scenario: FM Zones - Operator View All Zones & Check All Zone Filters
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone using "{hub-name}" hub
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_FIRST_MILE_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_FIRST_MILE_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_FIRST_MILE_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_FIRST_MILE_ZONE.description} |
    When Operator refresh page
    Then Operator check all filters on Fist Mile Zones page work fine
      | shortName   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_FIRST_MILE_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_FIRST_MILE_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_FIRST_MILE_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_FIRST_MILE_ZONE.description} |

  Scenario: FM Zones - Operator should not be able to Add Zones with Empty Field
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone with empty field in one of the mandatory field
    Then Operator verifies Submit Button in First Mile Zone add dialog is Disabled

  @DeleteCreatedFirstMileZoneCommonV2
  Scenario: FM Zones - Operator should not be able to edit Zones with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Routing -> First Mile Zones
    When Operator creates first mile zone using "{hub-name}" hub
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_FIRST_MILE_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_FIRST_MILE_ZONE.hubName}     |
      | latitude    | {KEY_SORT_CREATED_FIRST_MILE_ZONE.latitude}    |
      | longitude   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.longitude}   |
      | description | {KEY_SORT_CREATED_FIRST_MILE_ZONE.description} |
    When Operator refresh page
    When Operator update "{KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}" first mile zone with empty field in one of the mandatory field
    Then Operator verifies Submit Button in First Mile Zone edit dialog is Disabled

  @DeleteCreatedFirstMileZoneCommonV2
  Scenario: Set Coordinates Polygon of First Mile Zone
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu "Routing" -> "First Mile Zones"
    When Operator creates first mile zone using "{hub-name}" hub
    And Operator click View Selected Polygons for First Mile Zones name "{KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}"
    And Operator click Zones in First Mile Zones drawing page
    And Operator click Create Polygon in First Mile Zones drawing page
    And Operator click Set Coordinates in First Mile Zones drawing page
      | latitude  | {zone-latitude-3}  |
      | longitude | {zone-longitude-3} |
    When Operator refresh page
    Then Operator verifies first mile zone details on First Mile Zones page:
      | shortName   | {KEY_SORT_CREATED_FIRST_MILE_ZONE.shortName}   |
      | name        | {KEY_SORT_CREATED_FIRST_MILE_ZONE.name}        |
      | hubName     | {KEY_SORT_CREATED_FIRST_MILE_ZONE.hubName}     |
      | latitude    | {zone-latitude-3}                              |
      | longitude   | {zone-longitude-3}                             |
      | description | {KEY_SORT_CREATED_FIRST_MILE_ZONE.description} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
