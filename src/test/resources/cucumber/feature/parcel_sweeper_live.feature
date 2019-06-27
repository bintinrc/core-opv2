@OperatorV2 @OperatorV2Part2 @ParcelSweeperLive
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Parcel Sweeper Live - Order Not Found - Invalid Tracking ID (uid:5699c5ca-a546-42c4-b29d-0b25ad512360)
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Parcel Sweeper Live
  When Operator provides data on Parcel Sweeper Live page:
    | hubName    | {hub-name} |
    | trackingId | invalid    |
  Then Operator verifies data on Parcel Sweeper Live page using data below:
    | routeId              | NOT FOUND;NIL |
    | routeId_color        | #f45050       |
    | zoneName             | NIL           |
    | zoneName_color       | #f45050       |
    | destinationHub       | NOT FOUND     |
    | destinationHub_color | #f45050       |

  Scenario: Parcel Sweeper Live - Order Not Found - Pending Pickup (uid:d59c536f-3671-46b8-883c-6785a524a38a)
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Parcel Sweeper Live
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verifies data on Parcel Sweeper Live page using data below:
      | routeId              | NOT FOUND;NIL |
      | routeId_color        | #f45050       |
      | zoneName             | NIL           |
      | zoneName_color       | #f45050       |
      | destinationHub       | NOT FOUND     |
      | destinationHub_color | #f45050       |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED    |
      | hubId      | {hub-id}   |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page

  @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Van En-Route to Pickup (uid:be9ed0d6-276b-4368-bf9a-47dc0a8bec27)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    Then API Operator verify order info after Return PP transaction added to route
    When Operator go to menu Routing -> Parcel Sweeper Live
    And Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verifies data on Parcel Sweeper Live page using data below:
      | routeId              | NOT ROUTED;NIL |
      | routeId_color        | #73deec        |
#      | zoneName             | FROM CREATED ORDER    |
      | zoneName_color       | #f45050        |
      | destinationHub       | CREATED        |
      | destinationHub_color | #73deec        |
    #in TC it should be grey for destinationHub_color
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the last order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van en-route to pickup" on Edit Order page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op