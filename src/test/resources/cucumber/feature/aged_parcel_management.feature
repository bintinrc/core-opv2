@OperatorV2 @AgedParcelManagement
Feature: Aged Parcel Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario Outline: Operator find aged parcel on Aged Parcels list (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Then API Operator verify order info after Global Inbound
    When Operator refresh page
    And Operator go to menu Shipper Support -> Aged Parcel Management
    And operator load selection on page Aged Parcel Management
    Then Operator verify the aged parcel order is listed on Aged Parcels list
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:8a1ccb26-2942-414e-b95c-9af308fce884 | Normal    |
      | C2C    | uid:161bd183-ed16-4a6a-96dc-b436ac03b68a | C2C       |
      | Return | uid:06ff2483-15ab-4943-8935-ce18e11d78c8 | Return    |

  Scenario Outline: Operator download and verify CSV file of aged parcel on Aged Parcels list (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Then API Operator verify order info after Global Inbound
    When Operator refresh page
    And Operator go to menu Shipper Support -> Aged Parcel Management
    And operator load selection on page Aged Parcel Management
    And Operator download CSV file of aged parcel on Aged Parcels list
    Then Operator verify CSV file of aged parcel on Aged Parcels list downloaded successfully
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:e373ff7a-82a6-4aa8-af5c-d2f6f33ffe4f | Normal    |
      | C2C    | uid:99caafe0-64c9-4193-9612-735ed3a7603f | C2C       |
      | Return | uid:2d953665-c7e7-4227-87ff-c7be43bb8516 | Return    |

  @ArchiveRoute
  Scenario Outline: Operator reschedule failed delivery aged parcel on next day (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    When Operator refresh page
    And Operator go to menu Shipper Support -> Aged Parcel Management
    And operator load selection on page Aged Parcel Management
    And Operator reschedule aged parcel on next day
    Then API Operator verify order info after failed delivery aged parcel global inbounded and rescheduled on next day
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:c0874ed2-c089-4791-97a5-6e2b72b93a1d | Normal    |
      | C2C    | uid:0170c563-0bfe-492a-8e9c-2879da22be55 | C2C       |
      | Return | uid:b546d1ef-7af0-4c00-934e-68674b3e1e57 | Return    |

  @ArchiveRoute
  Scenario Outline: Operator reschedule failed delivery aged parcel on specific date (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    When Operator refresh page
    And Operator go to menu Shipper Support -> Aged Parcel Management
    And operator load selection on page Aged Parcel Management
    And Operator reschedule aged parcel on next 2 days
    Then API Operator verify order info after failed delivery aged parcel global inbounded and rescheduled on next 2 days
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:b8163a26-46bc-433f-94e0-f938d043535e | Normal    |
      | C2C    | uid:df45c596-1609-4590-b968-1eb1d695a8bd | C2C       |
      | Return | uid:2153eced-bb07-4a98-b9f4-29afcef6470b | Return    |

  @ArchiveRoute
  Scenario Outline: Operator RTS failed delivery aged parcel on next day (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    When Operator refresh page
    And Operator go to menu Shipper Support -> Aged Parcel Management
    And operator load selection on page Aged Parcel Management
    And Operator RTS aged parcel on next day
    Then API Operator verify order info after failed delivery aged parcel global inbounded and RTS-ed on next day
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:a7137a42-3380-4e62-86bb-df034ff60915 | Normal    |
      | C2C    | uid:9183dda1-d0c3-4577-b3ef-4c495a8b3fe7 | C2C       |
      | Return | uid:4a50a1d5-30cb-4eb1-b4d2-b34af8feb4a2 | Return    |

  @ArchiveRoute
  Scenario Outline: Operator RTS selected failed delivery aged parcel on next day (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    When Operator refresh page
    And Operator go to menu Shipper Support -> Aged Parcel Management
    And operator load selection on page Aged Parcel Management
    And Operator RTS aged parcel on next day
    Then API Operator verify order info after failed delivery aged parcel global inbounded and RTS-ed on next day
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:701c1c6c-c095-4055-a387-0fe38c38b0bb | Normal    |
      | C2C    | uid:fc207502-1b6d-472a-8a6b-0b6e32c9372b | C2C       |
      | Return | uid:e32ab4e8-b443-44b5-8dca-4bd92fb7fecf | Return    |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
