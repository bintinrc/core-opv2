@OperatorV2 @Core @Routing  @CreateRouteGroups @ReservationFilters
Feature: Create Route Groups - Reservation Filters

  https://studio.cucumber.io/projects/208144/test-plan/folders/2142861

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Filter Pickup Size Create Route Groups - Reservation Filters - Pickup Size = <pickupSize>
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/6906069
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "global_shipper_id":{shipper-v4-id}, "pickup_service_level":"Standard", "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_approx_volume": "<pickupSize>", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
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
      | id                                       | type        | shipper                                 | address                                                                  | startDateTime                                                   | endDateTime                                                      | pickupSize   |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | Reservation | {KEY_LIST_OF_CREATED_ADDRESSES[1].name} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineShortAddressWithSpaceDelimiter} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedLatestDatetime} | <pickupSize> |
    Examples:
      | pickupSize           |
      | Full-Van Load        |
      | Half-Van Load        |
      | Larger than Van Load |
      | Less than 10 Parcels |
      | Less than 3 Parcels  |
      | Trolley Required     |

  @HighPriority
  Scenario: Operator Filter Reservation Status on Create Route Groups - Reservation Status = Cancel - Reservation Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/6908319
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "global_shipper_id":{shipper-v4-id}, "pickup_service_level":"Standard", "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator cancel reservation for id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
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
      | id                                       | type        | shipper                                 | address                                                                  | status | startDateTime                                                   | endDateTime                                                      |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | Reservation | {KEY_LIST_OF_CREATED_ADDRESSES[1].name} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineShortAddressWithSpaceDelimiter} | CANCEL | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedLatestDatetime} |

  @DeleteRoutes @HighPriority
  Scenario: Operator Filter Reservation Status on Create Route Groups - Reservation Status = Fail - Reservation Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/6908317
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "global_shipper_id":{shipper-v4-id}, "pickup_service_level":"Standard", "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                           |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                             |
      | routes          | KEY_DRIVER_ROUTES                                                            |
      | jobType         | RESERVATION                                                                  |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","action": "FAIL"}] |
      | jobAction       | FAIL                                                                         |
      | jobMode         | PICK_UP                                                                      |
      | failureReasonId | 112                                                                          |
      | globalShipperId | {shipper-v4-id}                                                              |
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
      | id                                       | type        | shipper                                 | address                                                                  | status | startDateTime                                                   | endDateTime                                                      |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | Reservation | {KEY_LIST_OF_CREATED_ADDRESSES[1].name} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineShortAddressWithSpaceDelimiter} | FAIL   | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedLatestDatetime} |

  @DeleteOrArchiveRoute @HighPriority
  Scenario: Operator Filter Reservation Status on Create Route Groups - Reservation Status = Success - Reservation Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/6908313
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "global_shipper_id":{shipper-v4-id}, "pickup_service_level":"Standard", "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                               |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                 |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                |
      | jobType         | RESERVATION                                                                      |
      | jobAction       | SUCCESS                                                                          |
      | jobMode         | PICK_UP                                                                          |
      | globalShipperId | {shipper-v4-id}                                                                  |
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
      | id                                       | type        | shipper                                 | address                                                                  | status  | startDateTime                                                   | endDateTime                                                      |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | Reservation | {KEY_LIST_OF_CREATED_ADDRESSES[1].name} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineShortAddressWithSpaceDelimiter} | SUCCESS | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedLatestDatetime} |

  @HighPriority
  Scenario: Operator Filter Reservation Status on Create Route Groups - Reservation Status = Pending - Reservation Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/6908299
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "global_shipper_id":{shipper-v4-id}, "pickup_service_level":"Standard", "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
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
      | id                                       | type        | shipper                                 | address                                                                  | status  | startDateTime                                                   | endDateTime                                                      |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | Reservation | {KEY_LIST_OF_CREATED_ADDRESSES[1].name} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineShortAddressWithSpaceDelimiter} | PENDING | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedLatestDatetime} |

  @HighPriority
  Scenario Outline: Operator Filter Reservation Type on Create Route Groups - Reservation Filters - <Note>
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142861/scenarios/5214758
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "global_shipper_id":{shipper-v4-id}, "pickup_service_level":"<pickup_service_level>", "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
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
      | id                                       | type        | shipper                                 | address                                                                  | status  |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | Reservation | {KEY_LIST_OF_CREATED_ADDRESSES[1].name} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineShortAddressWithSpaceDelimiter} | PENDING |

    Examples:
      | Note                                 | rsvn_type         | pickup_service_level |
      | Reservation Type : Normal            | Normal            | Standard             |
      | Reservation Type : Premium Scheduled | Premium Scheduled | Premium              |