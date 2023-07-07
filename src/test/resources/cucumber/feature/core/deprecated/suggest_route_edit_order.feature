#@OperatorV2 @Core @EditOrder @SuggestRoute @EditOrder2 @RoutingModules @SuggestRouteEditOrder @Deprecated
Feature: Edit Order - Suggest Route

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute
  Scenario: Operator Suggest Route on Edit Order Page - Pickup, Suggested Route Found (uid:236f2423-0404-4db1-a4aa-79ef4ed3655f)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION_1"
    And API Shipper create V4 order using data below:
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION_2"
    And DB Operator set "{zone-id-3}" routing_zone_id for waypoints:
      | {KEY_TRANSACTION_1.waypointId} |
      | {KEY_TRANSACTION_2.waypointId} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    And Operator click Pickup -> Add To Route on Edit Order page
    And Operator suggest route of "{KEY_CREATED_ROUTE_TAG.name}" tag from the Route Finder on Edit Order Page
    Then Operator verify Route value is "{KEY_CREATED_ROUTE_ID}" in Add To Route dialog on Edit Order Page

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute
  Scenario: Operator Suggest Route on Edit Order Page - Delivery, No Suggested Route Found (uid:4fc900dd-1ce2-4362-801c-63c2053ac0d1)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    And Operator click Delivery -> Add To Route on Edit Order page
    And Operator suggest route of "{KEY_CREATED_ROUTE_TAG.name}" tag from the Route Finder on Edit Order Page
    Then Operator verifies that error toast displayed:
      | top    | Error trying to suggest route            |
      | bottom | No waypoints to suggest after filtering! |
    And Operator verify Route value is "" in Add To Route dialog on Edit Order Page

  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute
  Scenario: Operator Suggest Route on Edit Order Page - Pickup, No Suggested Route Found (uid:c3b9d6c1-c600-4d0d-aa24-c06476e2e32b)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-current-date-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-current-date-yyyy-MM-dd}T16:00:00+00:00" } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    And Operator click Pickup -> Add To Route on Edit Order page
    And Operator suggest route of "{KEY_CREATED_ROUTE_TAG.name}" tag from the Route Finder on Edit Order Page
    Then Operator verifies that error toast displayed:
      | top    | Error trying to suggest route            |
      | bottom | No waypoints to suggest after filtering! |
    And Operator verify Route value is "" in Add To Route dialog on Edit Order Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
