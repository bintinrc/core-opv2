@OperatorV2 @OperatorV2Part2 @CreateRouteGroups @Saas
Feature: Transactions

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add transaction to Route Group (uid:b6848852-12e6-4cba-bf7c-8444538596c1)
    #Notes: Shipper create sameday parcel with OC V2
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    When Operator create new 'Route Group' on 'Route Groups Management' using data below:
      | generateName | true       |
      | hubName      | {hub-name} |
    When Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    Then Operator verify new 'Route Group' on 'Route Groups Management' created successfully
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator wait until 'Create Route Group' page is loaded
    When Operator V2 add created Transaction to Route Group
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    Then Operator V2 clean up 'Route Groups'

  @DeleteOrArchiveRoute
  Scenario: Operator Filter RTS Transaction (uid:52a86349-8c4c-4ae7-ab22-eea3af31ebff)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator get order details
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator wait until 'Create Route Group' page is loaded
    Given Operator removes all General Filters except following: "Creation Time"
    Given Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    Given Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | RTS | Show |
    Given Operator choose "Hide Reservations" on Reservation Filters section on Create Route Group page
    Given Operator click Load Selection on Create Route Group page
    Then Operator verify PICKUP Transaction/Reservation record on Create Route Group page using data below:
      | id            | GET_FROM_CREATED_ORDER                  |
      | orderId       | GET_FROM_CREATED_ORDER                  |
      | trackingId    | GET_FROM_CREATED_ORDER                  |
      | type          | PICKUP Transaction                      |
      | shipper       | GET_FROM_CREATED_ORDER                  |
      | address       | GET_FROM_CREATED_ORDER                  |
      | status        | Arrived at Sorting Hub                  |
      | startDateTime | {gradle-next-1-day-yyyy-MM-dd} 12:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 15:00:00 |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Routed Transaction (uid:ab4c851f-876e-4cdc-8315-90ab4fa0cdc8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator get order details
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Routed"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
      | Routed        | Show  |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator choose "Hide Reservations" on Reservation Filters section on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    Then Operator verify PICKUP Transaction/Reservation record on Create Route Group page using data below:
      | id            | GET_FROM_CREATED_ORDER                  |
      | orderId       | GET_FROM_CREATED_ORDER                  |
      | trackingId    | GET_FROM_CREATED_ORDER                  |
      | type          | PICKUP Transaction                      |
      | shipper       | GET_FROM_CREATED_ORDER                  |
      | address       | GET_FROM_CREATED_ORDER                  |
      | status        | Pending Pickup                          |
      | startDateTime | {gradle-next-1-day-yyyy-MM-dd} 12:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 15:00:00 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
