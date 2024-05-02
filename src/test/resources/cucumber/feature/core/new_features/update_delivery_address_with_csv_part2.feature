@OperatorV2 @Core @NewFeatures @UpdateDeliveryAddressWithCSV @UpdateDeliveryAddressWithCSVPart2
Feature: Update Delivery Address with CSV

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario Outline: Bulk Update Order Delivery Address with CSV - With Technical Issues and Valid Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                            | toName  | toEmail | toPhoneNumber | toAddressAddress1 | toAddressAddress2 | toAddressPostcode | toAddressCity | toAddressCountry | toAddressState | toAddressDistrict |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | <value> | <value> | <value>       | <value>           | <value>           | <value>           | <value>       | <value>          | <value>        | <value>           |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |         |         |               |                   |                   |                   |               |                  |                |                   |
    And Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator closes the modal for unsuccessful update
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator verify orders info after address update:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    Examples:
      | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | [sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample] |

  @MediumPriority
  Scenario: Bulk Update Order Delivery Address with CSV - Invalid Lat Long Format & Empty Compulsory Fields
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                            | toAddressLatitude | toAddressLongitude | toPhoneNumber | toAddressAddress2 |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | empty             | 1.2860-17          | empty         | empty             |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                            | status                                                                                                                                                |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Require to fill in to.phone_number, to.address.address2, Invalid entry '1.2860-17' for to.address.longitude, Invalid entry '' for to.address.latitude |

  @MediumPriority
  Scenario Outline: Bulk Update Order Delivery Address with CSV - Fail to Update Lat Long - <Note>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator waits for 5 seconds
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                            | toAddressLatitude | toAddressLongitude |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | <lat>             | <long>             |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                            | status   |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | <status> |
    Examples:
      | Note                | lat          | long          | status                                                                                                       |
      | Lat Long Has String | 1.317219a344 | 103.925993?32 | Invalid entry '103.925993?32' for to.address.longitude, Invalid entry '1.317219a344' for to.address.latitude |
      | Lat Long Has Dash   | -            | -             | Invalid entry '-' for to.address.longitude, Invalid entry '-' for to.address.latitude                        |
      | Lat Is Empty        | empty        | 103.886438    | Invalid entry '' for to.address.latitude                                                                     |
      | Long Is Empty       | 1.369953     | empty         | Invalid entry '' for to.address.longitude                                                                    |

  @MediumPriority
  Scenario: Bulk Update Order Delivery Address with CSV - Lat Long is Empty
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                            | toAddressLatitude | toAddressLongitude |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | empty             | empty              |
    Then Operator verify updated addresses on Update Delivery Address with CSV page
    When Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator verify addresses were updated successfully on Update Delivery Address with CSV page
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And Operator verify created orders info after address update

  @ArchiveRouteCommonV2 @routing-refactor @HighPriority
  Scenario: Bulk Update Order Delivery Address with CSV - Routed Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery addresses of given orders on Update Delivery Address with CSV page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify updated addresses on Update Delivery Address with CSV page
    When Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator verify addresses were updated successfully on Update Delivery Address with CSV page
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And Operator verify created orders info after address update
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE CONTACT INFORMATION |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | seqNo    | not null                                                   |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | status   | Routed                                                     |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Bulk Update Order Delivery Address with CSV - RTS Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                              |
      | rtsRequest | { "reason": "Return to sender: Nobody at address", "timewindow_id":1, "date":"{date: 1 days next, yyyy-MM-dd}"} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery addresses of given orders on Update Delivery Address with CSV page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify updated addresses on Update Delivery Address with CSV page
    When Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator verify addresses were updated successfully on Update Delivery Address with CSV page
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And Operator verify created orders info after address update
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order V2 page
    And DB Core - verify orders record:
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "RTS", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verifies order details on Edit Order V2 page:
      | zone | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |
