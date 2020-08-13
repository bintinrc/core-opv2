@OperatorV2Deprecated @OperatorV2Part2Deprecated
Feature: Aged Parcel Management

    #DEPRECATED

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator should be able to filter by Shipper/Aged Days on Aged Parcel Management page (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Then API Operator verify order info after Global Inbound
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Aged Parcel Management
    When Operator apply filter parameters and load selection on Aged Parcel Management
      | shipperName | <shipperName> |
      | agedDays    | <agedDays>    |
    Then Operator verify the aged parcel order is listed on Aged Parcels list with following parameters
      | shipperName      | <shipperName>      |
      | daysSinceInbound | <daysSinceInbound> |
    Examples:
      | Note                | hiptest-uid                              | shipperName       | agedDays | daysSinceInbound |
      | Filter by Shipper   | uid:810d03ee-8015-4ee3-b61f-2c15e8405c0a | {shipper-v4-name} | -1       | Today            |
      | Filter by Aged Days | uid:4c357b48-fabf-49de-8da0-4c63f0284e67 | {shipper-v4-name} | -1       | Today            |

  Scenario Outline: Operator find aged parcel on Aged Parcels list (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Then API Operator verify order info after Global Inbound
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Aged Parcel Management
    When Operator load selection on page Aged Parcel Management
    Then Operator verify the aged parcel order is listed on Aged Parcels list
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:8a1ccb26-2942-414e-b95c-9af308fce884 | Normal    | false            |
      | Return | uid:06ff2483-15ab-4943-8935-ce18e11d78c8 | Return    | true             |
#      | C2C    | uid:161bd183-ed16-4a6a-96dc-b436ac03b68a | C2C       | true             |

  Scenario Outline: Operator download and verify CSV file of aged parcel on Aged Parcels list (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Then API Operator verify order info after Global Inbound
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Aged Parcel Management
    When Operator load selection on page Aged Parcel Management
    When Operator download CSV file of aged parcel on Aged Parcels list
    Then Operator verify CSV file of aged parcel on Aged Parcels list downloaded successfully
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:e373ff7a-82a6-4aa8-af5c-d2f6f33ffe4f | Normal    | false            |
      | Return | uid:2d953665-c7e7-4227-87ff-c7be43bb8516 | Return    | true             |
#      | C2C    | uid:99caafe0-64c9-4193-9612-735ed3a7603f | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator reschedule failed delivery aged parcel on next day (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Driver failed the delivery of the created parcel
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Shipper Support -> Aged Parcel Management
    When Operator load selection on page Aged Parcel Management
    When Operator reschedule aged parcel on next day
    Then API Operator verify order info after failed delivery aged parcel global inbounded and rescheduled on next day
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:c0874ed2-c089-4791-97a5-6e2b72b93a1d | Normal    | false            |
      | Return | uid:b546d1ef-7af0-4c00-934e-68674b3e1e57 | Return    | true             |
#      | C2C    | uid:0170c563-0bfe-492a-8e9c-2879da22be55 | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator reschedule multiple failed delivery aged parcels on specific date (<hiptest-uid>)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of multiple parcels
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Shipper Support -> Aged Parcel Management
    And Operator load selection on page Aged Parcel Management
    And Operator reschedule multiple aged parcels on next 2 days
    Then API Operator verify multiple orders info after failed delivery aged parcel global inbounded and rescheduled on next 2 days
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:962cab19-b57c-46cf-b252-d2c6588d9e89 | Normal    | false            |
      | Return | uid:858b3b5f-7b58-4351-860a-6371aed39668 | Return    | true             |
#      | C2C    | uid:0c8c967e-fa45-4e05-810b-1cb4d650660d | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator reschedule failed delivery aged parcel on specific date (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Driver failed the delivery of the created parcel
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Aged Parcel Management
    When Operator load selection on page Aged Parcel Management
    When Operator reschedule aged parcel on next 2 days
    Then API Operator verify order info after failed delivery aged parcel global inbounded and rescheduled on next 2 days
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:b8163a26-46bc-433f-94e0-f938d043535e | Normal    | false            |
      | Return | uid:2153eced-bb07-4a98-b9f4-29afcef6470b | Return    | true             |
#      | C2C    | uid:df45c596-1609-4590-b968-1eb1d695a8bd | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator RTS failed delivery aged parcel on next day (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Driver failed the delivery of the created parcel
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Aged Parcel Management
    When Operator load selection on page Aged Parcel Management
    When Operator RTS aged parcel on next day
    Then API Operator verify order info after failed delivery aged parcel global inbounded and RTS-ed on next day
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:a7137a42-3380-4e62-86bb-df034ff60915 | Normal    | false            |
      | Return | uid:4a50a1d5-30cb-4eb1-b4d2-b34af8feb4a2 | Return    | true             |
#      | C2C    | uid:9183dda1-d0c3-4577-b3ef-4c495a8b3fe7 | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator RTS selected failed delivery aged parcel on next day (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Driver failed the delivery of the created parcel
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Aged Parcel Management
    When Operator load selection on page Aged Parcel Management
    When Operator RTS selected aged parcel on next day
    Then API Operator verify order info after failed delivery aged parcel global inbounded and RTS-ed on next day
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:701c1c6c-c095-4055-a387-0fe38c38b0bb | Normal    | false            |
      | Return | uid:e32ab4e8-b443-44b5-8dca-4bd92fb7fecf | Return    | true             |
#      | C2C    | uid:fc207502-1b6d-472a-8a6b-0b6e32c9372b | C2C       | true             |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator RTS multiple failed delivery aged parcels on specific date (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver failed the delivery of multiple parcels
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Aged Parcel Management
    When Operator load selection on page Aged Parcel Management
    When Operator RTS multiple aged parcels on next 2 days
    Then API Operator verify multiple orders info after failed delivery aged parcel global inbounded and RTS-ed on next day
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:ebe56256-8c4b-48cc-b379-289aebbbbe31 | Normal    | false            |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op