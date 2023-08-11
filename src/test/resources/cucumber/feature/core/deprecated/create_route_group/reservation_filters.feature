@OperatorV2 @Core @Routing @RoutingJob2 @CreateRouteGroups
Feature: Create Route Groups - Reservation Filters

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Filter Reservation Type on Create Route Group - Reservation Filters - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_service_level":"<pickup_service_level>", "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                 |
      | Shipper       | {filter-shipper-name} |
    And Operator choose "Hide Transactions" on Transaction Filters section on Create Route Group page
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group page
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | reservationType   | <rsvn_type> |
      | reservationStatus | Pending     |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Reservation records on Create Route Group page using data below:
      | id                           | type        | shipper                    | address                                                     | status  |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | PENDING |

    Examples:
      | Note                                 | hiptest-uid                              | rsvn_type         | pickup_service_level |
      | Reservation Type : Normal            | uid:77ac93be-96a4-4019-a584-bf32c5831000 | Normal            | Standard             |
      | Reservation Type : Premium Scheduled | uid:bea12c7f-ce7d-45dd-8c0c-79497f89c9b5 | Premium Scheduled | Premium              |

  Scenario: Operator Filter Reservation Status on Create Route Group - Reservation Status = Pending - Reservation Filters (uid:ee03cd80-6d01-4a82-93a7-d6b3eaeb88f5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_service_level":"Standard", "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                 |
      | Shipper       | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group page
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | reservationStatus | Pending |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Reservation records on Create Route Group page using data below:
      | id                           | type        | shipper                    | address                                                     | status  | startDateTime                                       | endDateTime                                          |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | PENDING | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Reservation Status on Create Route Group - Reservation Status = Success - Reservation Filters (uid:34b7b9f2-3668-493e-bd57-be5100fc2afc)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator start the route with following data:
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
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                 |
      | Shipper       | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group page
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | reservationStatus | Success |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Reservation records on Create Route Group page using data below:
      | id                           | type        | shipper                    | address                                                     | status  | startDateTime                                       | endDateTime                                          |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | SUCCESS | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} |

  Scenario: Operator Filter Reservation Status on Create Route Group - Reservation Status = Cancel - Reservation Filters (uid:22004205-3670-432a-9978-24ad8208355d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And Update status reservation to Cancelled
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                 |
      | Shipper       | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group page
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | reservationStatus | Cancel |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Reservation records on Create Route Group page using data below:
      | id                           | type        | shipper                    | address                                                     | status | startDateTime                                       | endDateTime                                          |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | CANCEL | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Reservation Status on Create Route Group - Reservation Status = Fail - Reservation Filters (uid:460a7768-733a-4293-b6e0-55ae57315247)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator start the route with following data:
      | routeId  | {KEY_CREATED_ROUTE_ID}                                                                                                                |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                 |
      | Shipper       | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group page
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | reservationStatus | Fail |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Reservation records on Create Route Group page using data below:
      | id                           | type        | shipper                    | address                                                     | status | startDateTime                                       | endDateTime                                          |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | FAIL   | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} |

  Scenario Outline: Operator Filter Pickup Size Create Route Group - Reservation Filters - Pickup Size = <pickupSize> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_service_level":"Standard", "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume": "<pickupSize>", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                 |
      | Shipper       | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group page
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | pickUpSize | <pickupSize> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Reservation records on Create Route Group page using data below:
      | id                           | type        | shipper                    | address                                                     | startDateTime                                       | endDateTime                                          | pickupSize   |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} | <pickupSize> |
    Examples:
      | pickupSize           | hiptest-uid                              |
      | Full-Van Load        | uid:11a6d913-d732-4a61-b7c6-4fc24a293d87 |
      | Half-Van Load        | uid:935c2b68-b31d-4583-838c-c1ee0587558f |
      | Larger than Van Load | uid:5020e1fd-e4ee-4709-97ae-0d1b13ecc48b |
      | Less than 10 Parcels | uid:8af3a126-8065-4532-bfaf-a1941e9eedc1 |
      | Less than 3 Parcels  | uid:c67e3f41-6050-4538-8ba8-6c99a1bae151 |
      | Trolley Required     | uid:8b653bac-c2b0-43c9-bb29-844abc48c546 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
