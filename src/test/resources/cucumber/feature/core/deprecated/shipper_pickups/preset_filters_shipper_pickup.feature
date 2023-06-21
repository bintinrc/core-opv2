#@OperatorV2 @Core @ShipperPickups @ShipperPickups2 @Deprecated
Feature: Shipper Pickups - Preset Filters Shipper Pickup

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteFilterTemplate
  Scenario: Operator Apply Filter Preset on Shipper Pickup Page (uid:e27277c3-d95b-4bf8-a674-3705501cca51)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}               |
      | value.reservationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}               |
      | value.typeIds             | 0                                            |
      | value.waypointStatuses    | Pending,Routed                               |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
    Then Operator verifies selected filters on Shipper Pickups page:
      | reservationDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | reservationDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | reservationTypes    | Normal                         |
      | waypointStatus      | PENDING,ROUTED                 |

    #    TODO DISABLED
#  @DeleteFilterTemplate
#  Scenario: Operator Save A New Preset on Shipper Pickup Page (uid:98a6abc9-a9d8-4e6d-abe0-bfef4a13cf99)
#    Given Operator go to menu Utilities -> QRCode Printing
#    When Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator selects filters on Shipper Pickups page:
#      | reservationDateFrom | {gradle-next-0-day-yyyy-MM-dd}     |
#      | reservationDateTo   | {gradle-next-1-day-yyyy-MM-dd}     |
#      | reservationTypes    | Hyperlocal                         |
#      | waypointStatus      | ROUTED                             |
#      | shipper             | {filter-shipper-name}              |
#      | masterShipper       | {shipper-v4-marketplace-legacy-id} |
#    And Operator selects "Save Current as Preset" preset action on Shipper Pickups page
#    Then Operator verifies Save Preset dialog on Shipper Pickups page contains filters:
#      | Reservation Date: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd} |
#      | Reservation Types: Hyperlocal                                                      |
#      | Waypoint Status: ROUTED                                                            |
#      | Shipper: {shipper-v4-legacy-id}-{shipper-v4-name}                                  |
#      | Master Shipper: {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name}   |
#    And Operator verifies Preset Name field in Save Preset dialog on Shipper Pickups page is required
#    And Operator verifies Cancel button in Save Preset dialog on Shipper Pickups page is enabled
#    And Operator verifies Save button in Save Preset dialog on Shipper Pickups page is disabled
#    When Operator enters "PRESET {gradle-current-date-yyyyMMddHHmmsss}" Preset Name in Save Preset dialog on Shipper Pickups page
#    Then Operator verifies Preset Name field in Save Preset dialog on Shipper Pickups page has green checkmark on it
#    And Operator verifies Save button in Save Preset dialog on Shipper Pickups page is enabled
#    When Operator clicks Save button in Save Preset dialog on Shipper Pickups page
#    Then Operator verifies that success toast displayed:
#      | top                | 1 filter preset created                         |
#      | bottom             | Name: {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME} |
#      | waitUntilInvisible | true                                            |
#    And Operator verifies selected Filter Preset name is "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" on Shipper Pickups page
#    And DB Operator verifies filter preset record:
#      | id        | {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_ID}   |
#      | namespace | shipper-pickups                           |
#      | name      | {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME} |
#    When Operator refresh page
#    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
#    Then Operator verifies selected filters on Shipper Pickups page:
#      | reservationDateFrom | {gradle-next-0-day-yyyy-MM-dd}                                   |
#      | reservationDateTo   | {gradle-next-1-day-yyyy-MM-dd}                                   |
#      | reservationTypes    | Hyperlocal                                                       |
#      | waypointStatus      | ROUTED                                                           |
#      | shipper             | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
#      | masterShipper       | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Save Current As Preset button on Shipper Pickup Page (uid:333771f0-fe1b-4544-94fb-fe7d9f4d625c)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}               |
      | value.reservationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}               |
      | value.typeIds             | 0                                            |
      | value.waypointStatuses    | Pending,Routed                               |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
    And Operator updates filters on Shipper Pickups page:
      | waypointStatus | FAIL, SUCCESS         |
      | zones          | {zone-id}-{zone-name} |
    And Operator selects "Update Preset" preset action on Shipper Pickups page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                         |
      | bottom             | Name: {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                            |
    When Operator refresh page
    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
    Then Operator verifies selected filters on Shipper Pickups page:
      | reservationDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | reservationDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | reservationTypes    | Normal                         |
      | waypointStatus      | FAIL, SUCCESS                  |
      | zones               | {zone-id}-{zone-name}          |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Update Preset button on Shipper Pickup Page (uid:66e0d2dd-da74-471f-aa0b-51bd4cc3fb29)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}               |
      | value.reservationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}               |
      | value.typeIds             | 0                                            |
      | value.waypointStatuses    | Pending,Routed                               |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
    And Operator updates filters on Shipper Pickups page:
      | waypointStatus | FAIL, SUCCESS         |
      | zones          | {zone-id}-{zone-name} |
    And Operator selects "Save Current as Preset" preset action on Shipper Pickups page
    Then Operator verifies Save Preset dialog on Shipper Pickups page contains filters:
      | Reservation Date: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd} |
      | Reservation Types: Normal                                                          |
      | Waypoint Status: FAIL, SUCCESS                                                     |
      | Zones: {zone-id}-{zone-name}                                                       |
    When Operator enters "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Preset Name in Save Preset dialog on Shipper Pickups page
    Then Operator verifies help text "This name is already taken. Do you want to update this preset?" is displayed in Save Preset dialog on Shipper Pickups page
    When Operator clicks Update button in Save Preset dialog on Shipper Pickups page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                         |
      | bottom             | Name: {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                            |
    When Operator refresh page
    And Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" Filter Preset on Shipper Pickups page
    Then Operator verifies selected filters on Shipper Pickups page:
      | reservationDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | reservationDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | reservationTypes    | Normal                         |
      | waypointStatus      | FAIL, SUCCESS                  |
      | zones               | {zone-id}-{zone-name}          |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on Shipper Pickup Page (uid:d04a7955-2339-46e3-909c-454895f7aa3a)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}               |
      | value.reservationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}               |
      | value.typeIds             | 0                                            |
      | value.waypointStatuses    | Pending,Routed                               |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator selects "Delete Preset" preset action on Shipper Pickups page
    Then Operator verifies Cancel button in Delete Preset dialog on Shipper Pickups page is enabled
    And Operator verifies Delete button in Delete Preset dialog on Shipper Pickups page is disabled
    When Operator selects "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}" preset in Delete Preset dialog on Shipper Pickups page
    Then Operator verifies "Preset \"{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME}\" will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on Shipper Pickups page
    When Operator clicks Delete button in Delete Preset dialog on Shipper Pickups page
    Then Operator verifies that warning toast displayed:
      | top    | 1 filter preset deleted                     |
      | bottom | ID: {KEY_SHIPPER_PICKUPS_FILTERS_PRESET_ID} |
    And DB Lighthouse - verify preset_filters id "{KEY_SHIPPER_PICKUPS_FILTERS_PRESET_ID}" record is deleted:

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
