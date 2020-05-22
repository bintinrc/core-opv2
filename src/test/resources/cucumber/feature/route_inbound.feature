@OperatorV2 @OperatorV2Part1 @RouteInbound @Saas
Feature: Route Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario Outline: Operator get route details by <Title> (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
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
      | Title       | hiptest-uid                              | fetchBy              | fetchByValue                    |
      | Route ID    | uid:78b7f331-22b8-4ba4-926b-48fee23ca396 | FETCH_BY_ROUTE_ID    | {KEY_CREATED_ROUTE_ID}          |
      | Tracking ID | uid:1254810b-984b-41e0-826d-de3a0a70efec | FETCH_BY_TRACKING_ID | {KEY_CREATED_ORDER_TRACKING_ID} |
      | Driver      | uid:d8922f44-3b18-4243-84ce-fd2f13adb663 | FETCH_BY_DRIVER      | {ninja-driver-name}             |

  @DeleteOrArchiveRoute
  Scenario: View waypoint performance of Pending Waypoints on Route Inbound page (uid:10f08a94-963c-4964-8c01-759f23f53767)
    Given API Operator create new route using data below:
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
      | reservationId                            | location                   | readyToLatestTime              | approxVolume                   | status  | receivedParcels |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} | GET_FROM_CREATED_ADDRESS_1 | GET_FROM_CREATED_RESERVATION_1 | GET_FROM_CREATED_RESERVATION_1 | Pending | 0               |
    Then Operator verify Orders table in Pending Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Pending | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Return) | Pending | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |         | GET_FROM_CREATED_ORDER_3 | Delivery (Normal) | Pending | 0        | Inbounded          |

  @DeleteOrArchiveRoute
  Scenario: View waypoint performance of Success Waypoints on Route Inbound page (uid:6b926cc8-3dfc-4db4-8e76-21cc10f345bd)
    Given API Operator create new route using data below:
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
    When Operator click 'View orders or reservations' button for shipper #1 in Success Waypoints dialog
    Then Operator verify Orders table in Success Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Return) | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |         | GET_FROM_CREATED_ORDER_3 | Delivery (Normal) | Success | 0        | Inbounded          |

  @DeleteOrArchiveRoute
  Scenario: View waypoint performance of Failed Waypoints on Route Inbound page (uid:90c4045e-f5d3-4a2c-960e-da2fbb27cd0c)
    Given API Operator create new route using data below:
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
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Waypoints dialog
    Then Operator verify Orders table in Failed Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Failed | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Return) | Failed | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |         | GET_FROM_CREATED_ORDER_3 | Delivery (Normal) | Failed | 0        | Inbounded          |

  @DeleteOrArchiveRoute
  Scenario: Add comment to a Route Inbound Session (uid:f1eb1191-6dca-44ea-9d4b-6b32b7c60d46)
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator add route inbound comment "Test route inbound comment {gradle-current-date-yyyyMMddHHmmsss}"  on Route Inbound page
    Then Operator verify route inbound comment on Route Inbound page

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Route ID - Route with Waypoints (uid:cc88d3fd-9aee-4bf6-9247-1f3570dd4402)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |

#    Add  waypoints to success
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

#    Add waypoints to fail
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
    And Operator create new COD on Route Cash Inbound page
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

# Add pedding waypoints
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

    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver successfully deliver created parcels with numbers: 1, 2, 3
    And API Driver failed the delivery of parcels with numbers: 4, 5, 6

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
      | wpFailed    | 3                      |
      | wpCompleted | 3                      |
      | wpTotal     | 10                     |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Route ID - Route with no Waypoints (uid:fdca8b0e-9459-45a5-9cd1-8973050e7805)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 400 Bad Request        |
      | errorCode    | 103009                 |
      | errorMessage | route has no waypoints |

  Scenario: Get Route Details by Route ID - Route doesn't Exist (uid:c7566cd1-67c3-417f-ae14-18c13b8ab49b)
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}        |
      | fetchBy      | FETCH_BY_ROUTE_ID |
      | fetchByValue | 123456            |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 404 Not Found    |
      | errorCode    | 103019           |
      | errorMessage | Route not found! |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Route ID - Route not assigned to a Driver (uid:65573e80-9bc7-4809-8c8a-6c96e162564f)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id} } |
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 400 Bad Request                   |
      | errorCode    | 103088                            |
      | errorMessage | Route is not assigned to a driver |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order's Transactions are Routed: more than 1 route_id (uid:2e53e235-7fd1-442e-a793-dfadbe3fda2d)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
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
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
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

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order's Transactions are Routed: only 1 route_id (uid:f0428997-f486-4c53-b3a4-bd6873639112)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
      | routeId      | GET_FROM_CREATED_ROUTE[1]     |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE[1] |
      | driverName  | {ninja-driver-name}       |
      | hubName     | {hub-name}                |
      | routeDate   | GET_FROM_CREATED_ROUTE    |
      | wpPending   | 1                         |
      | wpPartial   | 0                         |
      | wpFailed    | 0                         |
      | wpCompleted | 0                         |
      | wpTotal     | 1                         |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
      | routeId      | GET_FROM_CREATED_ROUTE[2]     |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE[2] |
      | driverName  | {ninja-driver-name}       |
      | hubName     | {hub-name}                |
      | routeDate   | GET_FROM_CREATED_ROUTE    |
      | wpPending   | 0                         |
      | wpPartial   | 0                         |
      | wpFailed    | 0                         |
      | wpCompleted | 1                         |
      | wpTotal     | 1                         |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order is not Routed (uid:cc849489-5198-4ca3-944c-9ff9c6c15b42)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 400 Bad Request            |
      | errorCode    | 103096                     |
      | errorMessage | Order is not on any route! |

  @DeleteOrArchiveRoute
  Scenario: Get Route Details by Tracking ID - Order not Found (uid:30ba0005-9576-418a-93fd-b3bc8d2b538e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}           |
      | fetchBy      | FETCH_BY_TRACKING_ID |
      | fetchByValue | SOMEWRONGTRACKINGID  |
    Then Operator verify error message displayed on Route Inbound:
      | status       | 404 Not Found    |
      | errorCode    | 103014           |
      | errorMessage | Order not found! |

  @DeleteOrArchiveRoute @DeleteDriver
  Scenario: Get Route Details by Driver Name - Number of route_id = 1 (uid:0c45f5b3-a104-43c3-a6ef-0f25fa84b6bb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_ID} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                     |
      | fetchBy      | FETCH_BY_DRIVER                |
      | fetchByValue | {KEY_CREATED_DRIVER.firstName} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID}                                      |
      | driverName  | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} |
      | hubName     | {hub-name}                                                  |
      | routeDate   | GET_FROM_CREATED_ROUTE                                      |
      | wpPending   | 1                                                           |
      | wpPartial   | 0                                                           |
      | wpFailed    | 0                                                           |
      | wpCompleted | 0                                                           |
      | wpTotal     | 1                                                           |

  @DeleteOrArchiveRoute @DeleteDriver
  Scenario: Get Route Details by Driver Name - Number of route_id > 1 (uid:7ace9070-f9b8-44b7-90db-20c2aad6337a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":false,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"driver.{{TIMESTAMP}}@ninjavan.co"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":null}} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_ID} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_ID} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                        |
      | fetchBy      | FETCH_BY_DRIVER                   |
      | fetchByValue | {KEY_CREATED_DRIVER.firstName}    |
      | routeId      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]}                           |
      | driverName  | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} |
      | hubName     | {hub-name}                                                  |
      | routeDate   | GET_FROM_CREATED_ROUTE                                      |
      | wpPending   | 1                                                           |
      | wpPartial   | 0                                                           |
      | wpFailed    | 0                                                           |
      | wpCompleted | 0                                                           |
      | wpTotal     | 1                                                           |

  @DeleteOrArchiveRoute
  Scenario Outline: Inbound Cash for COD - <Title> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cashOnDelivery>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID} |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 0                      |
      | wpFailed    | 0                      |
      | wpCompleted | 1                      |
      | wpTotal     | 1                      |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    Then Operator verify 'Money to collect' value is "<cashOnDelivery>" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    Then Operator verify 'Expected Total' value is "<cashOnDelivery>" on Money Collection dialog
    And Operator verify 'Outstanding amount' value is "<cashOnDelivery>" on Money Collection dialog
    When Operator submit following values on Money Collection dialog:
      | cashCollected   | <cashCollected>   |
      | creditCollected | <creditCollected> |
      | receiptId       | <receiptId>       |
    Then Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator verify 'Outstanding amount' value is "Fully Collected" on Money Collection dialog

    Examples:
      | Title                            | hiptest-uid                              | cashCollected | creditCollected | receiptId | cashOnDelivery |
      | Inbound Cash Only                | uid:9d0eb52e-af06-4830-a8e1-29aa6dba90d1 | 23.57         |                 |           | 23.57          |
      | Inbound Credit Only              | uid:2b89461e-3003-4119-bedb-b7451d49fa03 |               | 23.57           | 123       | 23.57          |
      | Inbound Split Into Cash & Credit | uid:2a50cd43-5008-420c-b81e-34e547ecbdf5 | 10.0          | 13.57           | 123       | 23.57          |

  @DeleteOrArchiveRoute
  Scenario Outline: Inbound Cash for COP - <Title> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{"is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update parcel COP to <cashOnPickup>
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID} |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 0                      |
      | wpFailed    | 0                      |
      | wpCompleted | 1                      |
      | wpTotal     | 1                      |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    Then Operator verify 'Money to collect' value is "<cashOnPickup>" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    Then Operator verify 'Expected Total' value is "<cashOnPickup>" on Money Collection dialog
    And Operator verify 'Outstanding amount' value is "<cashOnPickup>" on Money Collection dialog
    When Operator submit following values on Money Collection dialog:
      | cashCollected   | <cashCollected>   |
      | creditCollected | <creditCollected> |
      | receiptId       | <receiptId>       |
    Then Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator verify 'Outstanding amount' value is "Fully Collected" on Money Collection dialog

    Examples:
      | Title                            | hiptest-uid                              | cashCollected | creditCollected | receiptId | cashOnPickup |
      | Inbound Cash Only                | uid:46768d15-a726-45e1-bd72-4c0b1d9921f3 | 23.57         |                 |           | 23.57        |
      | Inbound Credit Only              | uid:4ac68703-abe7-4789-9eff-f5d384858597 |               | 23.57           | 123       | 23.57        |
      | Inbound Split Into Cash & Credit | uid:817bc91a-9e94-4e0b-aeb8-08dbcec5e57f | 10.0          | 13.57           | 123       | 23.57        |

  @DeleteOrArchiveRoute
  Scenario: View Waypoint Performance: Total Waypoints (uid:ed908d4c-034c-461f-86a0-547769564581)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |

#    Add  order to success
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

#    Add  reservation to success
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add reservation pick-up to the route
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

#    Add waypoints to fail
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

#     Add pending reservation
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route

#     Add pending order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[2]}        |
    And API Driver successfully deliver created parcels with numbers: 1
    And API Driver failed the delivery of parcels with numbers: 3

    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | GET_FROM_CREATED_ROUTE |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 3                      |
      | wpPartial   | 0                      |
      | wpFailed    | 1                      |
      | wpCompleted | 2                      |
      | wpTotal     | 6                      |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    When Operator click 'Go Back' button on Route Inbound page
    When Operator open Total Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Total Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 5     |
    When Operator click 'View orders or reservations' button for shipper #1 in Total Waypoints dialog
    Then Operator verify Reservations table in Total Waypoints dialog using data below:
      | reservationId                            | location                   | readyToLatestTime              | approxVolume                   | status  | receivedParcels |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} | GET_FROM_CREATED_ADDRESS_1 | GET_FROM_CREATED_RESERVATION_1 | GET_FROM_CREATED_RESERVATION_1 | Success | 1               |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} | GET_FROM_CREATED_ADDRESS_2 | GET_FROM_CREATED_RESERVATION_2 | GET_FROM_CREATED_RESERVATION_2 | Pending | 0               |
    Then Operator verify Orders table in Total Waypoints dialog using data below:
      | trackingId                                 | stampId | location                   | type                  | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1   | Delivery (Normal)     | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ADDRESS_1 | Pick Up (Reservation) | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2   | Delivery (Normal)     | Pending | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |         | GET_FROM_CREATED_ORDER_3   | Delivery (Normal)     | Failed  | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} |         | GET_FROM_CREATED_ORDER_4   | Delivery (Return)     | Pending | 0        | Inbounded          |

  @DeleteOrArchiveRoute
  Scenario: View Waypoint Performance: Partial Waypoints (uid:9ddd11c2-86e0-4354-85a0-b18ddd3bba96)
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator merge route transactions
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator get route details of created route
    And API Operator get order details from route details
    And API Driver deliver partial created parcels successfully
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID} |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 1                      |
      | wpFailed    | 0                      |
      | wpCompleted | 0                      |
      | wpTotal     | 1                      |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    And Operator click 'Go Back' button on Route Inbound page
    And Operator open Partial Waypoints Info dialog on Route Inbound page
    Then Operator verify Shippers Info in Partial Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 1       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in Partial Waypoints dialog
    Then Operator verify Orders table in Partial Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Failed  | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Normal) | Success | 0        | Inbounded          |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Route Inbound Expected Scans : Pending Deliveries (uid:c7d343b4-7a1f-4351-b77f-40c451a74d51)
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator merge route transactions
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                | {KEY_CREATED_ROUTE_ID} |
      | driverName             | {ninja-driver-name}    |
      | hubName                | {hub-name}             |
      | routeDate              | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans   | 0                      |
      | parcelProcessedTotal   | 2                      |
      | pendingDeliveriesScans | 0                      |
      | pendingDeliveriesTotal | 2                      |
    When Operator open Pending Deliveries dialog on Route Inbound page
    Then Operator verify Shippers Info in Pending Deliveries Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in Pending Deliveries Waypoints dialog
    Then Operator verify Orders table in Pending Deliveries Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Pending | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Normal) | Pending | 0        |                    |
    When Operator close Pending Deliveries dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans   | 1 |
      | parcelProcessedTotal   | 2 |
      | pendingDeliveriesScans | 1 |
      | pendingDeliveriesTotal | 2 |
    When Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Route Inbound Expected Scans : Failed Deliveries (Invalid) (uid:f393ff4e-d4d7-4b06-a6de-1680a490267a)
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator merge route transactions
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                      | {KEY_CREATED_ROUTE_ID} |
      | driverName                   | {ninja-driver-name}    |
      | hubName                      | {hub-name}             |
      | routeDate                    | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans         | 0                      |
      | parcelProcessedTotal         | 2                      |
      | failedDeliveriesInvalidScans | 0                      |
      | failedDeliveriesInvalidTotal | 1                      |
    When Operator open Failed Deliveries Invalid dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Deliveries Invalid Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 1     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Deliveries Invalid Waypoints dialog
    Then Operator verify Orders table in Failed Deliveries Invalid Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Normal) | Failed | 1        |                    |
    When Operator close Failed Deliveries Invalid dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans         | 1 |
      | parcelProcessedTotal         | 2 |
      | failedDeliveriesInvalidScans | 1 |
      | failedDeliveriesInvalidTotal | 1 |
    When Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Route Inbound Expected Scans : Failed Deliveries (Valid) (uid:8da8d074-703f-42e9-b77f-67223f6daf62)
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator merge route transactions
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of multiple parcels
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                    | {KEY_CREATED_ROUTE_ID} |
      | driverName                 | {ninja-driver-name}    |
      | hubName                    | {hub-name}             |
      | routeDate                  | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans       | 0                      |
      | parcelProcessedTotal       | 2                      |
      | failedDeliveriesValidScans | 0                      |
      | failedDeliveriesValidTotal | 2                      |
    When Operator open Failed Deliveries Valid dialog on Route Inbound page
    Then Operator verify Shippers Info in Failed Deliveries Valid Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in Failed Deliveries Valid Waypoints dialog
    Then Operator verify Orders table in Failed Deliveries Valid Waypoints dialog using data below:
      | trackingId                                 | stampId | location                 | type              | status | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | GET_FROM_CREATED_ORDER_1 | Delivery (Normal) | Failed | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | GET_FROM_CREATED_ORDER_2 | Delivery (Normal) | Failed | 0        |                    |
    When Operator close Failed Deliveries Valid dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans       | 1 |
      | parcelProcessedTotal       | 2 |
      | failedDeliveriesValidScans | 1 |
      | failedDeliveriesValidTotal | 2 |
    When Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Route Inbound Expected Scans : Return Pickups (uid:a21f57a1-1e45-443f-8e52-bda393e00cc7)
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When API Shipper create V4 order using data below:
      | generateFrom   | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo     | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator merge route transactions
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver pickup the created parcel successfully
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId               | {KEY_CREATED_ROUTE_ID} |
      | driverName            | {ninja-driver-name}    |
      | hubName               | {hub-name}             |
      | routeDate             | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans  | 0                      |
      | parcelProcessedTotal  | 2                      |
      | c2cReturnPickupsScans | 0                      |
      | c2cReturnPickupsTotal | 2                      |
    When Operator open C2C / Return Pickups dialog on Route Inbound page
    Then Operator verify Shippers Info in C2C / Return Pickups Waypoints dialog using data below:
      | shipperName       | scanned | total |
      | {shipper-v4-name} | 0       | 2     |
    When Operator click 'View orders or reservations' button for shipper #1 in C2C / Return Pickups Waypoints dialog
    Then Operator verify Orders table in C2C / Return Pickups Waypoints dialog using data below:
      | trackingId                                 | stampId | location             | type             | status  | cmiCount | routeInboundStatus |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         | CREATED_ORDER_FROM_1 | Pick Up (Return) | Success | 0        |                    |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         | CREATED_ORDER_FROM_2 | Pick Up (Return) | Success | 0        |                    |
    When Operator close C2C / Return Pickups dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans  | 1 |
      | parcelProcessedTotal  | 2 |
      | c2cReturnPickupsScans | 1 |
      | c2cReturnPickupsTotal | 2 |
    When Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Route Inbound Expected Scans : Reservation Pickups (uid:bb9d03b5-1341-41a0-870e-94923e86d282)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add reservation pick-up to the route
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | routeId                 | {KEY_CREATED_ROUTE_ID} |
      | driverName              | {ninja-driver-name}    |
      | hubName                 | {hub-name}             |
      | routeDate               | GET_FROM_CREATED_ROUTE |
      | parcelProcessedScans    | 0                      |
      | parcelProcessedTotal    | 2                      |
      | reservationPickupsScans | 0                      |
      | reservationPickupsTotal | 1                      |
    When Operator open Reservation Pickups dialog on Route Inbound page
    And Operator close Reservation Pickups dialog on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Then Operator verify the Route Inbound Details is correct using data below:
      | parcelProcessedScans    | 1 |
      | parcelProcessedTotal    | 2 |
      | reservationPickupsScans | 1 |
      | reservationPickupsTotal | 1 |
    When Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ROUTE INBOUND SCAN     |
      | routeId | {KEY_CREATED_ROUTE_ID} |
      | hubName | {hub-name}             |

  @DeleteOrArchiveRoute
  Scenario: View Cash Collection (uid:9523ff75-91b0-40df-938f-4b6023155012)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver deliver the created parcel successfully
    Given Operator go to menu Fleet -> Route Cash Inbound
    When Operator create new COD on Route Cash Inbound page
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}             |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | {KEY_CREATED_ROUTE_ID} |
    And Operator open Money Collection history dialog on Route Inbound page
    Then Operator verify Money Collection history record using data below:
      | processedAmount | {KEY_ROUTE_CASH_INBOUND_COD.amountCollected} |
      | processedType   | Cash                                         |
      | receiptNo       | {KEY_ROUTE_CASH_INBOUND_COD.receiptNumber}   |
    And Operator verify Money Collection Collected Order record using data below:
      | processedCodAmount    | {KEY_COD_GOODS_AMOUNT}                     |
      | processedCodCollected | {KEY_COD_GOODS_AMOUNT}                     |
      | trackingId            | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | customType            | Delivery (Normal)                          |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
