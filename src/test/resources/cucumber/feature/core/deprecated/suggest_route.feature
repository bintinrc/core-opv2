#@OperatorV2 @Core @AllOrders @SuggestRouteAllOrders @Deprected
Feature: All Orders - Suggest Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @DeleteRouteTags @BulkSuggestRoute
  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Delivery, No Suggested Route Found (uid:483e367c-927f-4c72-8679-9cc3badf06ec)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator suggest routes on Add Selected to Route form using Set To All:
      | type | Delivery                     |
      | tag  | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verifies that error toast displayed:
      | top    | Error trying to suggest route            |
      | bottom | No waypoints to suggest after filtering! |
    Then Operator verify Route Id values on Add Selected to Route form:
      | trackingId                                 | routeId |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         |

  @DeleteOrArchiveRoute @DeleteRouteTags @BulkSuggestRoute
  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Pickup, Suggested Route Found for All Waypoints (uid:1f7eb099-3337-45dc-a8d5-30e2dd92f954)
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
    And Operator save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order as "KEY_TRANSACTION_1"
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                      |
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" order as "KEY_TRANSACTION_2"
    And Operator save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[3]}" order as "KEY_TRANSACTION_3"
    And DB Operator set "{zone-id-3}" routing_zone_id for waypoints:
      | {KEY_TRANSACTION_1.waypointId} |
      | {KEY_TRANSACTION_2.waypointId} |
      | {KEY_TRANSACTION_3.waypointId} |
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
    When Operator suggest routes on Add Selected to Route form using Set To All:
      | type | Pickup                       |
      | tag  | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verify Route Id values on Add Selected to Route form:
      | trackingId                                 | routeId                |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_CREATED_ROUTE_ID} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | {KEY_CREATED_ROUTE_ID} |

  @DeleteOrArchiveRoute @DeleteRouteTags @BulkSuggestRoute
  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Pickup, Suggested Route Found for Partial Waypoint (uid:fc3ae755-e9e2-4f44-98ab-626c4af6594a)
    Given Operator go to menu Utilities -> QRCode Printing
    #Create Order and add to route
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
    And Operator save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order as "KEY_TRANSACTION_1"
    #Create Order with same address
    And API Shipper create V4 order using data below:
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" order as "KEY_TRANSACTION_2"
    #Create Order with different address
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    #Create another route tag
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And DB Operator set "{zone-id-3}" routing_zone_id for waypoints:
      | {KEY_TRANSACTION_1.waypointId} |
      | {KEY_TRANSACTION_2.waypointId} |
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
    When Operator suggest routes on Add Selected to Route form:
      | trackingId                                 | type   | tag                                      |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Pickup | {KEY_LIST_OF_CREATED_ROUTE_TAGS[1].name} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Pickup | {KEY_LIST_OF_CREATED_ROUTE_TAGS[2].name} |
    Then Operator verify Route Id values on Add Selected to Route form:
      | trackingId                                 | routeId                |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_CREATED_ROUTE_ID} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |                        |

  @DeleteOrArchiveRoute @DeleteRouteTags @BulkSuggestRoute
  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Pickup, No Suggested Route Found (uid:06e5d86f-adf3-4a4f-8fa6-e998185449f9)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                      |
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator suggest routes on Add Selected to Route form using Set To All:
      | type | Pickup                       |
      | tag  | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verifies that error toast displayed:
      | top    | Error trying to suggest route            |
      | bottom | No waypoints to suggest after filtering! |
    Then Operator verify Route Id values on Add Selected to Route form:
      | trackingId                                 | routeId |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         |
