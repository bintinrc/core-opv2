#@OperatorV2 @Core @ShipperPickups @ShipperPickups1 @Deprecated
Feature: Shipper Pickups - Create New Reservation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Creates New Reservation by Duplicating Existing Reservation Details - Multiple Reservations (uid:aea00c1d-f550-4286-ba1a-5ed0f7369d2b)
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
    And Operator duplicates created reservations
    When Operator refresh page
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-next-1-day-yyyy-MM-dd} |
      | toDate      | {gradle-next-2-day-yyyy-MM-dd} |
      | shipperName | {filter-shipper-name}          |
    Then Operator verify reservations details on Shipper Pickups page:
      | shipperId              | shipperName          | pickupAddress                                                 | routeId | driverName | priorityLevel                                       | readyBy  | latestBy | reservationType | reservationStatus | reservationCreatedTime              | serviceTime | approxVolume                                       | failureReason | comments                                       |
      | {shipper-v4-legacy-id} | ^{shipper-v4-name}.* | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].priorityLevel} | not null | not null | REGULAR         | PENDING           | ^{gradle-current-date-yyyy-MM-dd}.* | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | null          | {KEY_LIST_OF_CREATED_RESERVATIONS[1].comments} |
      | {shipper-v4-legacy-id} | ^{shipper-v4-name}.* | {KEY_LIST_OF_CREATED_ADDRESSES[2].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[2].priorityLevel} | not null | not null | REGULAR         | PENDING           | ^{gradle-current-date-yyyy-MM-dd}.* | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[2].approxVolume} | null          | {KEY_LIST_OF_CREATED_RESERVATIONS[2].comments} |

  Scenario: Operator Creates New Reservation by Duplicating Existing Reservation Details - Single Reservation (uid:2138a61e-e56b-4efb-9ced-7dfd92ea07f3)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    And Operator duplicates created reservation
    When Operator refresh page
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-next-1-day-yyyy-MM-dd} |
      | toDate      | {gradle-next-2-day-yyyy-MM-dd} |
      | shipperName | {filter-shipper-name}          |
    Then Operator verify reservation details on Shipper Pickups page:
      | shipperId              | {KEY_CREATED_RESERVATION.legacyShipperId}        |
      | shipperName            | ^{shipper-v4-name}.*                             |
      | pickupAddress          | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode} |
      | routeId                | null                                             |
      | driverName             | null                                             |
      | priorityLevel          | {KEY_CREATED_RESERVATION.priorityLevel}          |
      | readyBy                | not null                                         |
      | latestBy               | not null                                         |
      | reservationType        | REGULAR                                          |
      | reservationStatus      | PENDING                                          |
      | reservationCreatedTime | ^{gradle-current-date-yyyy-MM-dd}.*              |
      | serviceTime            | null                                             |
      | approxVolume           | {KEY_CREATED_RESERVATION.approxVolume}           |
      | failureReason          | null                                             |
      | comments               | {KEY_CREATED_RESERVATION.comments}               |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
