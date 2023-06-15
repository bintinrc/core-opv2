Feature: Edit order deprecated
#
#  @DeleteOrArchiveRoute @DeleteRouteTags @SuggestRoute
#  Scenario: Operator Suggest Route on Edit Order Page - Delivery, Suggested Route Found (uid:9df8ffd8-1adb-4752-9769-14d3d03393ff)
#    Given Operator go to menu Utilities -> QRCode Printing
#    And API Shipper create V4 order using data below:
#      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
#      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id-3} } |
#    And API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-current-date-yyyy-MM-dd} 00:00:00", "dateTime": "{gradle-current-date-yyyy-MM-dd}T00:00:00+00:00" } |
#    And API Operator create new route tag:
#      | name        | GENERATED                          |
#      | description | tag for automated testing purposes |
#    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    And API Shipper create V4 order using data below:
#      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | generateTo     | {KEY_CREATED_ORDER.getToAddress}                                                                                                                                                                                                                                                                                                 |
#      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id-3} } |
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
#    And Operator click Delivery -> Add To Route on Edit Order page
#    And Operator suggest route of "{KEY_CREATED_ROUTE_TAG.name}" tag from the Route Finder on Edit Order Page
#    Then Operator verify Route value is "{KEY_CREATED_ROUTE_ID}" in Add To Route dialog on Edit Order Page
