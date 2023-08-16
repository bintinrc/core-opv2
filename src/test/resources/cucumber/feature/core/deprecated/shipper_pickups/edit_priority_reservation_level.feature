#@OperatorV2 @Core @ShipperPickups @ShipperPickups1 @Deprecated
Feature: Shipper Pickups - Edit Priority Reservation Level

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Edits Priority Level on Bulk Action - Single Reservation (uid:4c10632f-b48e-4e09-a67f-f4763f6942d6)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And Operator set the Priority Level of the created reservation to "2" from Apply Action
    When Operator refresh page
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verify reservation details on Shipper Pickups page:
      | id            | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | priorityLevel | 2                                        |
    And DB Operator verify reservation priority level
      | priorityLevel | 2 |

  @happy-path
  Scenario: Operator Edits Priority Level on Bulk Action - Multiple Reservations (uid:8b24231a-34a4-493a-8a97-45b100e6888f)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    And Operator set the Priority Level of the created reservations to "2" from Apply Action
    When Operator refresh page
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | priorityLevel |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | 2             |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} | 2             |

  Scenario: Operator Edits Priority Level on Bulk Action - Multiple Reservations, Set to All Priority Level (uid:e994a33e-d5e8-4176-91b2-c7636f4ae1f6)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    And Operator set the Priority Level of the created reservations to "2" from Apply Action using "Set To All" option
    Then Operator verify the new reservations are listed on table in Shipper Pickups page using data below:
      | priorityLevel | 2 |

  @DeleteOrArchiveRoute
  Scenario: Operator Edit Single Reservation Priority Level in Shipper Pickup Page (uid:5830302f-c452-49c4-bc59-28bb130e20ae)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And Operator set the Priority Level of the created reservation to "3" from Apply Action
    When Operator refresh page
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verify reservation details on Shipper Pickups page:
      | id            | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | priorityLevel | 3                                        |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
