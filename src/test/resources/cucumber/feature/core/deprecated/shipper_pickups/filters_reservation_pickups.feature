#@OperatorV2 @Core @ShipperPickups @ShipperPickups2 @FilterReservation @Deprecated
Feature: Shipper Pickups - Filter Reservation Pickup

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Filters Reservation by Reservation Type - Normal Reservation (uid:f622a44e-809f-442b-9461-574b180ebd44)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | type        | Normal                           |
    Then Operator verify reservation details on Shipper Pickups page:
      | id           | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | approxVolume | Less than 10 Parcels                     |
      | shipperName  | ^{shipper-v4-name}.*                     |
      | comments     | {KEY_CREATED_RESERVATION.comments}       |

  @happy-path
  Scenario: Operator Find Created Reservation by Shipper Name (uid:4d2d2a71-33e0-4f6c-846e-9cca10ef4c2b)
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
    Then Operator verify reservation details on Shipper Pickups page:
      | id          | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | shipperName | ^{shipper-v4-name}.*                     |
      | shipperId   | {shipper-v4-legacy-id}                   |

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Reservation by Hub Name
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id}    |
      | generateAddress | ZONE {zone-name-3} |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate | {gradle-current-date-yyyy-MM-dd} |
      | toDate   | {gradle-next-1-day-yyyy-MM-dd}   |
      | hub      | {hub-name-3}                     |
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | routeId                | driverName          |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |

  #    TODO enabled once first mile zone is available in shipper pickup page
  #  @DeleteOrArchiveRoute
  #  Scenario: Operator Filters Reservation by Zone Name
  #    Given Operator go to menu Utilities -> QRCode Printing
  #    And API Operator create new shipper address V2 using data below:
  #      | shipperId       | {shipper-v4-id}    |
  #      | generateAddress | ZONE {zone-name-3} |
  #    And API Operator create V2 reservation using data below:
  #      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
  #    And DB Operator set "{zone-id-3}" routing_zone_id for waypoints:
  #      | {KEY_WAYPOINT_ID} |
  #    When Operator go to menu Pick Ups -> Shipper Pickups
  #    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
  #      | fromDate | {gradle-current-date-yyyy-MM-dd} |
  #      | toDate   | {gradle-next-1-day-yyyy-MM-dd}   |
  #      | zone     | {zone-full-name-3}               |
  #    Then Operator verify reservation details on Shipper Pickups page:
  #      | id          | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}            |
  #      | shipperName | ^{shipper-v4-name} - {shipper-v4-contact} \(\+\d+\) |
  #      | routeId     | null                                                |
  #      | driverName  | null                                                |

  Scenario: Operator Filters Reservation by Waypoint Status - PENDING (uid:f9641b05-1512-48f9-961d-b627e044c5a5)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | PENDING                          |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Reservation by Waypoint Status - ROUTED (uid:fec438e6-fc0a-4c0f-acd5-e49f27f6a285)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | ROUTED                           |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Reservation by Waypoint Status - SUCCESS (uid:a400c076-ada2-4e14-aabe-e9f888608373)
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
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}    |
      | approxVolume | Less than 10 Parcels |
    And Operator verifies reservation is finished using data below:
      | backgroundColor | #90ee90 |
      | status          | SUCCESS |

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Reservation by Waypoint Status - FAIL (uid:8e4d27a1-4d7b-4def-bd7b-2f758cb2deb4)
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
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {filter-shipper-name}            |
      | status      | FAIL                             |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}    |
      | approxVolume | Less than 10 Parcels |
    And Operator verifies reservation is finished using data below:
      | backgroundColor | #ffc0cb |
      | status          | FAIL    |

  Scenario: Operator Filters Reservation by Reservation Type - Premium Scheduled Reservation (uid:6693f2c8-ee4a-4592-8147-6dee8f4cebe5)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}","pickup_service_level":"Premium" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | type        | Premium Scheduled                |
      | shipperName | {filter-shipper-name}            |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-name}                  |
      | approxVolume | Less than 10 Parcels               |
      | comments     | {KEY_CREATED_RESERVATION.comments} |

  @happy-path
  Scenario: Operator Filters Created Reservation by Master Shipper (uid:8977782b-6756-410b-86e7-c947d200eda9)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    And API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type": "Marketplace","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": true,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}} |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate          | {gradle-current-date-yyyy-MM-dd} |
      | toDate            | {gradle-next-1-day-yyyy-MM-dd}   |
      | masterShipperName | {shipper-v4-marketplace-name}    |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v4-marketplace-short-name} (ABC Shop) |
      | approxVolume | Less than 3 Parcels                            |
      | comments     | Please be careful with the v-day flowers.      |

  Scenario: Operator Search Single Reservation by Reservation Id on Shipper Pickup Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator enter reservation ids on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verifies that there is "1 reservation IDs entered" shown under the search field on Shipper Pickups page
    When Operator clicks Search by Reservation IDs on Shipper Pickups page
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | shipperId              | shipperName                                                                              | pickupAddress                                                 | routeId | driverName | priorityLevel                                       | readyBy                                                        | latestBy                                                        | reservationType | reservationStatus | reservationCreatedTime | serviceTime | approxVolume                                       | failureReason | comments                                       |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {shipper-v4-legacy-id} | {shipper-v4-name} - {shipper-v4-contact} ({KEY_LIST_OF_CREATED_RESERVATIONS[1].contact}) | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].priorityLevel} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedLatestDatetime} | REGULAR         | PENDING           | not null               | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | -             | {KEY_LIST_OF_CREATED_RESERVATIONS[1].comments} |

  Scenario: Operator Search Multiple Less Than 30 Reservations by Reservation Ids on Shipper Pickup Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator enter reservation ids on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} |
    Then Operator verifies that there is "2 reservation IDs entered" shown under the search field on Shipper Pickups page
    When Operator clicks Search by Reservation IDs on Shipper Pickups page
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | shipperId              | shipperName                                                                              | pickupAddress                                                 | routeId | driverName | priorityLevel                                       | readyBy                                                        | latestBy                                                        | reservationType | reservationStatus | reservationCreatedTime | serviceTime | approxVolume                                       | failureReason | comments                                       |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {shipper-v4-legacy-id} | {shipper-v4-name} - {shipper-v4-contact} ({KEY_LIST_OF_CREATED_RESERVATIONS[1].contact}) | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].priorityLevel} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedLatestDatetime} | REGULAR         | PENDING           | not null               | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | -             | {KEY_LIST_OF_CREATED_RESERVATIONS[1].comments} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[2].id} | {shipper-v4-legacy-id} | {shipper-v4-name} - {shipper-v4-contact} ({KEY_LIST_OF_CREATED_RESERVATIONS[2].contact}) | {KEY_LIST_OF_CREATED_ADDRESSES[2].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[2].priorityLevel} | {KEY_LIST_OF_CREATED_RESERVATIONS[2].toDisplayedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[2].toDisplayedLatestDatetime} | REGULAR         | PENDING           | not null               | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[2].approxVolume} | -             | {KEY_LIST_OF_CREATED_RESERVATIONS[2].comments} |

  Scenario: Operator Search Multiple More Than 30 Reservations by Reservation Ids on Shipper Pickup Page
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator enters 31 reservation ids on Shipper Pickups page
    Then Operator verifies that there is "31 reservation IDs entered" shown under the search field on Shipper Pickups page
    When Operator clicks Search by Reservation IDs on Shipper Pickups page
    Then Operator verifies that error toast displayed:
      | top | We cannot process more than 30 reservations |

  Scenario: Operator Search Duplicate Reservation by Reservation Id on Shipper Pickup Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator enter reservation ids on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
    Then Operator verifies that there is "2 reservation IDs entered 1 duplicate" shown under the search field on Shipper Pickups page
    When Operator clicks Search by Reservation IDs on Shipper Pickups page
    Then Operator verify exactly reservations details on Shipper Pickups page:
      | id                                       | shipperId              | shipperName                                                                              | pickupAddress                                                 | routeId | driverName | priorityLevel                                       | readyBy                                                        | latestBy                                                        | reservationType | reservationStatus | reservationCreatedTime | serviceTime | approxVolume                                       | failureReason | comments                                       |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | {shipper-v4-legacy-id} | {shipper-v4-name} - {shipper-v4-contact} ({KEY_LIST_OF_CREATED_RESERVATIONS[1].contact}) | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithPostcode} | null    | null       | {KEY_LIST_OF_CREATED_RESERVATIONS[1].priorityLevel} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].toDisplayedLatestDatetime} | REGULAR         | PENDING           | not null               | null        | {KEY_LIST_OF_CREATED_RESERVATIONS[1].approxVolume} | -             | {KEY_LIST_OF_CREATED_RESERVATIONS[1].comments} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
