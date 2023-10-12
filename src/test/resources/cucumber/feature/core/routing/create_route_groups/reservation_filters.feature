@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroups @ReservationFilters @CRG4
Feature: Create Route Groups - Reservation Filters

  https://studio.cucumber.io/projects/208144/test-plan/folders/2142861

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Filter Pickup Size Create Route Groups - Reservation Filters - Pickup Size = <pickupSize>
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/6906069
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_service_level":"Standard", "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume": "<pickupSize>", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Groups page
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | pickUpSize | <pickupSize> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Reservation records on Create Route Groups page using data below:
      | id                           | type        | shipper                    | address                                                     | startDateTime                                       | endDateTime                                          | pickupSize   |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} | <pickupSize> |
    Examples:
      | pickupSize           |
      | Full-Van Load        |
      | Half-Van Load        |
      | Larger than Van Load |
      | Less than 10 Parcels |
      | Less than 3 Parcels  |
      | Trolley Required     |

  Scenario: Operator Filter Reservation Status on Create Route Groups - Reservation Status = Cancel - Reservation Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/6908319
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And Update status reservation to Cancelled
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Groups page
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | reservationStatus | CANCEL |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Reservation records on Create Route Groups page using data below:
      | id                           | type        | shipper                    | address                                                     | status | startDateTime                                       | endDateTime                                          |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | CANCEL | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Reservation Status on Create Route Groups - Reservation Status = Fail - Reservation Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/6908317
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Groups page
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | reservationStatus | FAIL |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Reservation records on Create Route Groups page using data below:
      | id                           | type        | shipper                    | address                                                     | status | startDateTime                                       | endDateTime                                          |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | FAIL   | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Reservation Status on Create Route Groups - Reservation Status = Success - Reservation Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/6908313
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Groups page
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | reservationStatus | SUCCESS |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Reservation records on Create Route Groups page using data below:
      | id                           | type        | shipper                    | address                                                     | status  | startDateTime                                       | endDateTime                                          |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | SUCCESS | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} |

  Scenario: Operator Filter Reservation Status on Create Route Groups - Reservation Status = Pending - Reservation Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/6908299
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_service_level":"Standard", "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Groups page
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | reservationStatus | PENDING |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Reservation records on Create Route Groups page using data below:
      | id                           | type        | shipper                    | address                                                     | status  | startDateTime                                       | endDateTime                                          |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | PENDING | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} |

  Scenario Outline: Operator Filter Reservation Type on Create Route Groups - Reservation Filters - <Note>
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/5214758
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_service_level":"<pickup_service_level>", "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Hide Transactions" on Transaction Filters section on Create Route Groups page
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Groups page
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | reservationType   | <rsvn_type> |
      | reservationStatus | PENDING     |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Reservation records on Create Route Groups page using data below:
      | id                           | type        | shipper                    | address                                                     | status  |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | PENDING |

    Examples:
      | Note                                 | rsvn_type         | pickup_service_level |
      | Reservation Type : Normal            | Normal            | Standard             |
      | Reservation Type : Premium Scheduled | Premium Scheduled | Premium              |