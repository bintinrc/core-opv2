@OperatorV2 @OperatorV2Part1 @RouteInbound @Saas
Feature: Route Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario Outline: Operator get route details by Route ID/Tracking ID/Driver (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}     |
      | fetchBy      | <fetchBy>      |
      | fetchByValue | <fetchByValue> |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 0                      |
      | wpFailed    | 0                      |
      | wpCompleted | 1                      |
      | wpTotal     | 1                      |
    Examples:
      | Note                 | hiptest-uid                              | fetchBy              | fetchByValue           |
      | FETCH_BY_ROUTE_ID    | uid:78b7f331-22b8-4ba4-926b-48fee23ca396 | FETCH_BY_ROUTE_ID    | GET_FROM_CREATED_ROUTE |
      | FETCH_BY_TRACKING_ID | uid:1254810b-984b-41e0-826d-de3a0a70efec | FETCH_BY_TRACKING_ID | GET_FROM_CREATED_ROUTE |
      | FETCH_BY_DRIVER      | uid:d8922f44-3b18-4243-84ce-fd2f13adb663 | FETCH_BY_DRIVER      | {ninja-driver-name}    |

  @DeleteOrArchiveRoute
  Scenario: View waypoint performance of Pending Waypoints on Route Inbound page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |

    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route

    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Fleet -> Route Cash Inbound
    And Operator create new COD on Route Cash Inbound page
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 4                      |
      | wpPartial   | 0                      |
      | wpFailed    | 0                      |
      | wpCompleted | 0                      |
      | wpTotal     | 4                      |

    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    When Operator click 'Go Back' button on Route Inbound page

    When Operator open Pending Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Pending Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 3     |
    When Operator click 'View orders or reservations' button for shipper #1 in Pending Waypoints dialog
    Then Operator verify Reservations table in Pending Waypoints dialog using data below:
      | reservationId                  | location                   | readyToLatestTime              | approxVolume                   | status  | receivedParcels |
      | GET_FROM_CREATED_RESERVATION_1 | GET_FROM_CREATED_ADDRESS_1 | GET_FROM_CREATED_RESERVATION_1 | GET_FROM_CREATED_RESERVATION_1 | Pending | 0               |

    Then Operator verify Orders table in Pending Waypoints dialog using data below:
      | trackingId               | stampId | location                 | type              | status  | cmiCount | routeInboundStatus |
      | GET_FROM_CREATED_ORDER_1 |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Pending | 0        |                    |
      | GET_FROM_CREATED_ORDER_2 |         | GET_FROM_CREATED_ORDER_2 | Delivery (Return) | Pending | 0        |                    |
      | GET_FROM_CREATED_ORDER_3 |         | GET_FROM_CREATED_ORDER_3 | Delivery (Normal) | Pending | 0        | Inbounded          |

  @DeleteOrArchiveRoute
  Scenario: View waypoint performance of Success Waypoints on Route Inbound page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |

    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Fleet -> Route Cash Inbound
    And Operator create new COD on Route Cash Inbound page
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver deliver all created parcels successfully

    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 0                      |
      | wpFailed    | 0                      |
      | wpCompleted | 3                      |
      | wpTotal     | 3                      |

    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    When Operator click 'Go Back' button on Route Inbound page

    When Operator open Completed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Pending Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 3     |
    When Operator click 'View orders or reservations' button for shipper #1 in Pending Waypoints dialog
    Then Operator verify Orders table in Pending Waypoints dialog using data below:
      | trackingId               | stampId | location                 | type              | status  | cmiCount | routeInboundStatus |
      | GET_FROM_CREATED_ORDER_1 |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Success | 0        |                    |
      | GET_FROM_CREATED_ORDER_2 |         | GET_FROM_CREATED_ORDER_2 | Delivery (Return) | Success | 0        |                    |
      | GET_FROM_CREATED_ORDER_3 |         | GET_FROM_CREATED_ORDER_3 | Delivery (Normal) | Success | 0        | Inbounded          |

    @DeleteOrArchiveRoute
  Scenario: View waypoint performance of Failed Waypoints on Route Inbound page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |

    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Fleet -> Route Cash Inbound
    And Operator create new COD on Route Cash Inbound page
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of multiple parcels

    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 0                      |
      | wpFailed    | 3                      |
      | wpCompleted | 0                      |
      | wpTotal     | 3                      |

    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    When Operator click 'Go Back' button on Route Inbound page

    When Operator open Failed Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 3     |
    When Operator click 'View orders or reservations' button for shipper #1 in Pending Waypoints dialog
    Then Operator verify Orders table in Pending Waypoints dialog using data below:
      | trackingId               | stampId | location                 | type              | status | cmiCount | routeInboundStatus |
      | GET_FROM_CREATED_ORDER_1 |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Failed | 0        |                    |
      | GET_FROM_CREATED_ORDER_2 |         | GET_FROM_CREATED_ORDER_2 | Delivery (Return) | Failed | 0        |                    |
      | GET_FROM_CREATED_ORDER_3 |         | GET_FROM_CREATED_ORDER_3 | Delivery (Normal) | Failed | 0        | Inbounded          |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
