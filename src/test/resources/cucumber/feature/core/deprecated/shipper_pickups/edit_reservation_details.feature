#@OperatorV2 @Core @ShipperPickups @ShipperPickups1 @Deprecated
Feature: Shipper Pickups - Edit Reservation Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Edits Pending Reservation Address Details (uid:5fb61b34-8fdd-45a6-84a3-b2e5148e0bd4)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And Operator edit reservation address details on Edit Route Details dialog using data below:
      | oldAddress | KEY_LIST_OF_CREATED_ADDRESSES[1] |
      | newAddress | KEY_LIST_OF_CREATED_ADDRESSES[2] |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | address      | KEY_LIST_OF_CREATED_ADDRESSES[2] |
      | shipperName  | {shipper-v4-name}                |
      | approxVolume | Less than 3 Parcels              |
      | comments     | GET_FROM_CREATED_RESERVATION     |
    And DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | address1 | {KEY_LIST_OF_CREATED_ADDRESSES[2].address1}      |
      | country  | {KEY_LIST_OF_CREATED_ADDRESSES[2].country}       |

  @DeleteOrArchiveRoute
  Scenario: Operator Not Allowed to Edit Attempted Reservation Address Details - Success Reservation (uid:80f2356d-5010-4291-9463-fae61a6207a1)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | SUCCESS                          |
    Then Operator verify that "Route Edit" icon is disabled for created reservation on Shipper Pickups page

  @DeleteOrArchiveRoute
  Scenario: Operator Not Allowed to Edit Attempted Reservation Address Details - Fail Reservation (uid:416311c2-e9b0-4b34-a3a3-e00d7152dd2f)
    Given Operator go to menu Utilities -> QRCode Printing
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
    And API Driver fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 9           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verify that "Route Edit" icon is disabled for created reservation on Shipper Pickups page

  Scenario: Operator Edits Premium Scheduled Reservation Time
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_service_type": "Scheduled","pickup_service_level": "Premium","legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | type        | Premium Scheduled                |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And Operator edit reservation address details on Edit Route Details dialog using data below:
      | oldAddress     | KEY_LIST_OF_CREATED_ADDRESSES[1] |
      | newAddress     | KEY_LIST_OF_CREATED_ADDRESSES[2] |
      | readyByHours   | 10                               |
      | readyByMinutes | 30                               |
      | readyByAmPm    | AM                               |
      | lastByHours    | 12                               |
      | lastByMinutes  | 30                               |
      | lastByAmPm     | PM                               |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | address      | KEY_LIST_OF_CREATED_ADDRESSES[2] |
      | shipperName  | {shipper-v4-name}                |
      | approxVolume | Less than 3 Parcels              |
      | comments     | GET_FROM_CREATED_RESERVATION     |
      | readyBy      | 10:30:00                         |
      | latestBy     | 12:30:00                         |
    And DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | address1 | {KEY_LIST_OF_CREATED_ADDRESSES[2].address1}      |
      | country  | {KEY_LIST_OF_CREATED_ADDRESSES[2].country}       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op