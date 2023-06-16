Feature: Cancel Order Deprecated
#  @DeleteOrArchiveRoute @DeleteRouteTags @Deprecated
#  Scenario: Operator Add Parcel to Route Using Tag Filter on All Orders Page (uid:a5f2f56b-2484-4401-bb65-f713c85e6017)
#    And API Shipper create V4 order using data below:
#      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
#      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id-3} } |
#    And API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
#    And API Operator create new route tag:
#      | name        | GENERATED                          |
#      | description | tag for automated testing purposes |
#    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    And API Shipper create V4 order using data below:
#      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
#      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Shipper create V4 order using data below:
#      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
#      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id-3} } |
#    When Operator go to menu Order -> All Orders
#    And Operator find orders by uploading CSV on All Orders page:
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
#    When Operator add multiple orders to route on All Orders page:
#      | trackingIds | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]},{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
#      | tag         | {KEY_CREATED_ROUTE_TAG.name}                                                          |
#    Then Operator verifies that info toast displayed:
#      | top    | 2 order(s) updated |
#      | bottom | add to route       |
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
#    Then Operator verify order event on Edit order page using data below:
#      | name    | ADD TO ROUTE           |
#      | routeId | {KEY_CREATED_ROUTE_ID} |
#    And Operator verify Delivery transaction on Edit order page using data below:
#      | status  | PENDING                |
#      | routeId | {KEY_CREATED_ROUTE_ID} |
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[3]}"
#    Then Operator verify order event on Edit order page using data below:
#      | name    | ADD TO ROUTE           |
#      | routeId | {KEY_CREATED_ROUTE_ID} |
#    And Operator verify Delivery transaction on Edit order page using data below:
#      | status  | PENDING                |
#      | routeId | {KEY_CREATED_ROUTE_ID} |

#
#  @DeleteOrArchiveRoute @DeleteRouteTags @BulkSuggestRoute
#  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Delivery, Suggested Route Found for All Waypoints (uid:b9215b2a-4ef6-4076-a3f1-6fabeec16c9c)
#    Given Operator go to menu Utilities -> QRCode Printing
#    And API Shipper create V4 order using data below:
#      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
#      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id-3} } |
#    And API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
#    And API Operator create new route tag:
#      | name        | GENERATED                          |
#      | description | tag for automated testing purposes |
#    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    And API Shipper create multiple V4 orders using data below:
#      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                |
#      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
#      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound multiple parcels using data below:
#      | globalInboundRequest | { "hubId":{hub-id-3} } |
#    When Operator go to menu Order -> All Orders
#    And Operator find orders by uploading CSV on All Orders page:
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
#    When Operator suggest routes on Add Selected to Route form using Set To All:
#      | tag | {KEY_CREATED_ROUTE_TAG.name} |
#    Then Operator verify Route Id values on Add Selected to Route form:
#      | trackingId                                 | routeId                |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_CREATED_ROUTE_ID} |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | {KEY_CREATED_ROUTE_ID} |
#
#
#  @DeleteOrArchiveRoute @DeleteRouteTags @BulkSuggestRoute
#  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Delivery, Suggested Route Found for Partial Waypoint (uid:0319ce57-7d5d-4d0f-b02e-9cb682e070e0)
#    Given Operator go to menu Utilities -> QRCode Printing
#    #Create Order and add to route
#    And API Shipper create V4 order using data below:
#      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
#      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id-3} } |
#    And API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
#    And API Operator create new route tag:
#      | name        | GENERATED                          |
#      | description | tag for automated testing purposes |
#    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    #Create Order with same address
#    And API Shipper create V4 order using data below:
#      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
#      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id-3} } |
#    #Create Order with different address
#    And API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id-3} } |
#    #Create another route tag
#    And API Operator create new route tag:
#      | name        | GENERATED                          |
#      | description | tag for automated testing purposes |
#    When Operator go to menu Order -> All Orders
#    And Operator find orders by uploading CSV on All Orders page:
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
#    When Operator suggest routes on Add Selected to Route form:
#      | trackingId                                 | type     | tag                                      |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Delivery | {KEY_LIST_OF_CREATED_ROUTE_TAGS[1].name} |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Delivery | {KEY_LIST_OF_CREATED_ROUTE_TAGS[2].name} |
#    Then Operator verify Route Id values on Add Selected to Route form:
#      | trackingId                                 | routeId                |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_CREATED_ROUTE_ID} |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |                        |