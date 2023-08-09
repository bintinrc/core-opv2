@StationManagement @StationRouteMonitoringPart2
Feature: Route Monitoring V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @ArchiveRouteCommonV2 @SystemIdNotSg @default-my
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups Parcels - Order Has PRIOR Tag
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","from":{"name":"TEST-STATION","phone_number":"+6591434259","email":"station@ninjavan.co","address":{"address1":"28woodlands","address2":"Test","country":"MY","postcode":"75810"}},"to":{"name":"TEST-SITI-CUSTOMER","phone_number":"+65914341111","email":"nadia.dwijaatamaja@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"MY","postcode":"75810","latitude":"1.46378","longitude":"103.801811"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{gradle-current-date-yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-prior-id}               |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | jobMode         | PICK_UP                                                                                                                |
      | failureReasonId | 2673                                                                                                                   |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | jobMode         | PICK_UP                                                                                                                |
      | failureReasonId | 2673                                                                                                                   |
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 2
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 2 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    When Operator Filters the records in the "Invalid Failed Pickups" by applying the following filters:
      | Tracking ID                                | Customer Name                            | Order Tags | Address                                                                                                                                                                            |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | PRIOR      | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry} |
    Then Operator verify value in the "Invalid Failed Pickups" table for the Tags column value is equal to "PRIOR"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].fromName}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in table "Invalid Failed Pickups"
    Examples:
      | HubId      | HubName      | Country  |
      | {hub-id-2} | {hub-name-2} | Malaysia |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @CloseNewWindows @SystemIdNotSg @default-my
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Pickups Parcels - Order with NO Tags
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","from":{"name":"TEST-STATION","phone_number":"+6591434259","email":"station@ninjavan.co","address":{"address1":"28woodlands","address2":"Test","country":"MY","postcode":"75810"}},"to":{"name":"TEST-SITI-CUSTOMER","phone_number":"+65914341111","email":"nadia.dwijaatamaja@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"MY","postcode":"75810","latitude":"1.46378","longitude":"103.801811"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{gradle-current-date-yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | jobMode         | PICK_UP                                                                                                                |
      | failureReasonId | 2673                                                                                                                   |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | jobMode         | PICK_UP                                                                                                                |
      | failureReasonId | 2673                                                                                                                   |
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 2
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 2 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    When Operator Filters the records in the "Invalid Failed Pickups" by applying the following filters:
      | Tracking ID                                | Customer Name                                     | Address                                     |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]} | {KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]} |
    Then Operator verify value in the "Invalid Failed Pickups" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]}"
    Then Operator verify value in the "Invalid Failed Pickups" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]}"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in table "Invalid Failed Pickups"

    Examples:
      | HubId       | HubName       | Country  |
      | {hub-id-21} | {hub-name-21} | Malaysia |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels on NON-PRIOR Waypoints
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    When Operator clicks on the "PENDING_PRIORITY_PARCELS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | PENDING_PRIORITY_DELIVERIES | 0 |
      | PENDING_PRIORITY_PICKUPS    | 0 |
    Then Operator verifies pop up modal is showing No Results Found
      | PENDING_PRIORITY_DELIVERIES | YES |
      | PENDING_PRIORITY_PICKUPS    | YES |

    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Delivery
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"TEST-STATION","phone_number":"+6591434259","email":"station@ninjavan.co","address":{"address1":"28woodlands","address2":"Test","country":"SG","postcode":"758103"}},"to":{"name":"TEST-SITI-CUSTOMER","phone_number":"+65914341111","email":"nadia.dwijaatamaja@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"SG","postcode":"758103","latitude":"1.46378","longitude":"103.801811"}},"parcel_job":{"is_pickup_required":false,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{gradle-current-date-yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-prior-id}               |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 2
    When Operator clicks on the "PENDING_PRIORITY_PARCELS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | PENDING_PRIORITY_DELIVERIES | 2 |
      | PENDING_PRIORITY_PICKUPS    | 0 |
    When Operator Filters the records in the "Pending Priority Deliveries" by applying the following filters:
      | Tracking ID                                | Customer Name                          | Order Tags | Address                                                                                                                                                                    |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} | PRIOR      | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].toCountry} |
    Then Operator verify value in the "Pending Priority Deliveries" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].toName}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the Tags column value is equal to "PRIOR"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in table "Pending Priority Deliveries"

    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","from":{"name":"TEST-STATION","phone_number":"+6591434259","email":"station@ninjavan.co","address":{"address1":"28woodlands","address2":"Test","country":"SG","postcode":"758103"}},"to":{"name":"TEST-SITI-CUSTOMER","phone_number":"+65914341111","email":"nadia.dwijaatamaja@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"SG","postcode":"758103","latitude":"1.46378","longitude":"103.801811"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{gradle-current-date-yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-prior-id}               |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 2
    When Operator clicks on the "PENDING_PRIORITY_PARCELS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | PENDING_PRIORITY_DELIVERIES | 0 |
      | PENDING_PRIORITY_PICKUPS    | 2 |
    When Operator Filters the records in the "Pending Priority Pickup" by applying the following filters:
      | Tracking ID                                | Customer Name                            | Order Tags | Address                                                                                                                                                                            |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | PRIOR      | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry} |
    Then Operator verify value in the "Pending Priority Pickup" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator verify value in the "Pending Priority Pickup" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].fromName}"
    Then Operator verify value in the "Pending Priority Pickup" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}"
    Then Operator verify value in the "Pending Priority Pickup" table for the Tags column value is equal to "PRIOR"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in table "Pending Priority Pickup"

    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @CloseNewWindows
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup & Delivery Under the Same Route
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","from":{"name":"TEST-STATION","phone_number":"+6591434259","email":"station@ninjavan.co","address":{"address1":"28woodlands","address2":"Test","country":"SG","postcode":"758103"}},"to":{"name":"TEST-SITI-CUSTOMER","phone_number":"+65914341111","email":"nadia.dwijaatamaja@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"SG","postcode":"758103","latitude":"1.46378","longitude":"103.801811"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{gradle-current-date-yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","from":{"name":"TEST-STATION","phone_number":"+6591434259","email":"station@ninjavan.co","address":{"address1":"28woodlands","address2":"Test","country":"SG","postcode":"758103"}},"to":{"name":"TEST-SITI-CUSTOMER","phone_number":"+65914341111","email":"nadia.dwijaatamaja@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"SG","postcode":"758103","latitude":"1.46378","longitude":"103.801811"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{gradle-current-date-yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 2
    When Operator clicks on the "PENDING_PRIORITY_PARCELS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | PENDING_PRIORITY_DELIVERIES | 1 |
      | PENDING_PRIORITY_PICKUPS    | 1 |
    When Operator Filters the records in the "Pending Priority Pickup" by applying the following filters:
      | Tracking ID                                | Customer Name                            | Order Tags | Address                                                                                                                                                                            |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | PRIOR      | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry} |
    Then Operator verify value in the "Pending Priority Pickup" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator verify value in the "Pending Priority Pickup" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].fromName}"
    Then Operator verify value in the "Pending Priority Pickup" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}"
    Then Operator verify value in the "Pending Priority Pickup" table for the Tags column value is equal to "PRIOR"
    When Operator Filters the records in the "Pending Priority Deliveries" by applying the following filters:
      | Tracking ID                                | Customer Name                          | Order Tags | Address                                                                                                                                                                    |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} | PRIOR      | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].toCountry} |
    Then Operator verify value in the "Pending Priority Deliveries" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].toName}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}"
    Then Operator verify value in the "Pending Priority Deliveries" table for the Tags column value is equal to "PRIOR"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in table "Pending Priority Deliveries"


    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @CloseNewWindows @SystemIdNotSg @default-my
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Deliveries Parcels - Order Has PRIOR Tag
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"TEST-STATION","phone_number":"+6591434259","email":"station@ninjavan.co","address":{"address1":"28woodlands","address2":"Test","country":"MY","postcode":"75810"}},"to":{"name":"TEST-SITI-CUSTOMER","phone_number":"+65914341111","email":"nadia.dwijaatamaja@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"MY","postcode":"75810"},"parcel_job":{"is_pickup_required":false,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{gradle-current-date-yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | {order-tag-prior-id}               |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | orderTag | {order-tag-prior-id}               |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | <HubId>                                                                                                                                                                                                                                            |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 2682                                                                                                                   |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 2682                                                                                                                   |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 2
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 2 |
      | INVALID_FAILED_PICKUPS      | 0 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    When Operator Filters the records in the "Invalid Failed Deliveries" by applying the following filters:
      | Tracking ID                                | Customer Name                          | Order Tags | Address                                                                                                                                                                    |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDERS[1].toName} | PRIOR      | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].toCountry} |
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].toName}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the Tags column value is equal to "PRIOR"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in table "Invalid Failed Deliveries"

    Examples:
      | HubId      | HubName      |
      | {hub-id-2} | {hub-name-2} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @CloseNewWindows @SystemIdNotSg @default-my
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Deliveries Parcels - Order with NO Tags
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
      | Failure Reason          | I didn't attempt the delivery - Ninja Point Waypoint |
      | Failure Reason Detail 1 | Cannot Make It (CMI) - Ninja Point Waypoint          |
    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}"
      | Failure Reason          | I didn't attempt the delivery - Ninja Point Waypoint |
      | Failure Reason Detail 1 | Cannot Make It (CMI) - Ninja Point Waypoint          |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 2
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 2 |
      | INVALID_FAILED_PICKUPS      | 0 |
      | INVALID_FAILED_RESERVATIONS | 0 |
    When Operator Filters the records in the "Invalid Failed Deliveries" by applying the following filters:
      | Tracking ID                                | Customer Name                                   | Address                                   |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[1]} | {KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[1]} |
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[1]}"
    Then Operator verify value in the "Invalid Failed Deliveries" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[1]}"
    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in table "Invalid Failed Deliveries"

    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |

#  @ForceSuccessOrder @ArchiveRouteCommonV2 @CloseNewWindows @SystemIdNotSg @default-my
#  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed Waypoints - Pickup, Delivery & Reservation Under the Same Route
#    Given Operator loads Operator portal home page
#    Given API Core - Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    And API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
#      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"PP" } |
#    When API Order - Shipper create multiple V4 orders using data below:
#      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
#      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    And API Operator create new shipper address V2 using data below:
#      | shipperId       | {shipper-v4-id} |
#      | generateAddress | RANDOM          |
#    And API Operator create V2 reservation using data below:
#      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
#    And API Operator add reservation pick-up to the route
#    And API Driver collect all his routes
#    And API Driver get pickup/delivery waypoints of created orders
#    And API Operator Van Inbound multiple parcels
#    And API Operator start the route
#    When Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
#      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
#      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
#      | shipperName | {shipper-v4-legacy-id}           |
#      | status      | ROUTED                           |
#    And Operator fails reservation with failure Reason for the ReservationID "{KEY_CREATED_RESERVATION_ID}"
#      | Failure Reason          | I didn't attempt the pick up - Normal |
#      | Failure Reason Detail 1 | Cannot Make It (CMI) - Normal         |
#    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
#    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
#      | Failure Reason          | I didn't attempt the pick up - Normal |
#      | Failure Reason Detail 1 | Cannot Make It (CMI) - Normal         |
#    And Operator fail waypoint from Route Manifest page with following details in the row "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}"
#      | Failure Reason          | I didn't attempt the delivery - Ninja Point Waypoint |
#      | Failure Reason Detail 1 | Cannot Make It (CMI) - Ninja Point Waypoint          |
#    When Operator loads Operator portal Station Route Monitoring page
#    And Operator selects hub "<HubName>" and click load selection
#    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
#    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
#    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 3
#    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
#    Then Operator verifies pop up modal is showing correct total parcels
#      | INVALID_FAILED_DELIVERIES   | 1 |
#      | INVALID_FAILED_PICKUPS      | 1 |
#      | INVALID_FAILED_RESERVATIONS | 1 |
#    When Operator Filters the records in the "Invalid Failed Pickups" by applying the following filters:
#      | Tracking ID                                | Customer Name                                     | Address                                     |
#      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]} | {KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]} |
#    Then Operator verify value in the "Invalid Failed Pickups" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
#    Then Operator verify value in the "Invalid Failed Pickups" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_FROM_NAME[1]}"
#    Then Operator verify value in the "Invalid Failed Pickups" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_FROM_ADDRESS[1]}"
#    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in table "Invalid Failed Pickups"
#    When Operator Filters the records in the "Invalid Failed Deliveries" by applying the following filters:
#      | Tracking ID                                | Customer Name                                   | Address                                   |
#      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | {KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[2]} | {KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[2]} |
#    Then Operator verify value in the "Invalid Failed Deliveries" table for the "TRACKING_ID" column value is equal to "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}"
#    Then Operator verify value in the "Invalid Failed Deliveries" table for the "CUSTOMER_NAME" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_CUSTOMER_TO_NAME[2]}"
#    Then Operator verify value in the "Invalid Failed Deliveries" table for the "ADDRESS" column value is equal to "{KEY_LIST_OF_CREATED_ORDER_TO_ADDRESS[2]}"
#    And Operator verifies that Edit Order page is opened on clicking tracking id "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}" in table "Invalid Failed Deliveries"
#    When Operator Filters the records in the "Invalid Failed Reservations" by applying the following filters:
#      | Reservation ID               | Pickup Name        |
#      | {KEY_CREATED_RESERVATION_ID} | {KEY_SHIPPER_NAME} |
#    And Operator selects the timeslot "3pm - 6pm" in the table
#    Then Operator verify value in the "Invalid Failed Reservations" table for the "RESERVATION_ID" column value is equal to "{KEY_CREATED_RESERVATION_ID}"
#    Then Operator verify value in the "Invalid Failed Reservations" table for the "PICKUP_NAME" column value is equal to "{KEY_SHIPPER_NAME}"
#    Then Operator verify value in the "Invalid Failed Reservations" table for the "TIME_SLOT" column value is equal to "3pm - 6pm"
#    And Operator verifies that Shipper Pickup page is opened on clicking Reservation ID "{KEY_CREATED_RESERVATION_ID}" table "Invalid Failed Reservations"
#
#
#
#    Examples:
#      | HubId       | HubName       |
#      | {hub-id-21} | {hub-name-21} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Reservation
    Given Operator loads Operator portal home page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Single Transaction
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |


  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Multiple Transactions
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[3]}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 3

    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline:Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Delivery Transactions
    Given Operator loads Operator portal home page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "Station","phone_number": "+6595557073 ","email": "Station@ninjatest.co", "address": {"address1": "Orchard Road central","address2":"Test","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    Given API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 2
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Pickup Transactions
    Given Operator loads Operator portal home page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "Station","phone_number": "+6595557073 ","email": "Station@ninjatest.co", "address": {"address1": "Orchard Road central","address2": "Test","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    Given API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 2
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Operator Filter Route Monitoring Data After Merge Pending Multiple Waypoints - Delivery & Pickup Transactions
    Given Operator loads Operator portal home page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"TEST-STATION","phone_number":"+6591434259","email":"station@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"SG","postcode":"758103","latitude":"1.46378","longitude":"103.801811"}},"to":{"name":"TEST-SITI-CUSTOMER","phone_number":"+65914341111","email":"nadia.dwijaatamaja@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"SG","postcode":"758103","latitude":"1.46378","longitude":"103.801811"}},"parcel_job":{"is_pickup_required":false,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{gradle-current-date-yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"TEST-STATION","phone_number":"+6591434259","email":"station@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"SG","postcode":"758103","latitude":"1.46378","longitude":"103.801811"}},"to":{"name":"TEST-SITI-CUSTOMER","phone_number":"+65914341111","email":"nadia.dwijaatamaja@ninjavan.co","address":{"address1":"Yishun","address2":"Test","country":"SG","postcode":"758103","latitude":"1.46378","longitude":"103.801811"}},"parcel_job":{"is_pickup_required":false,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{gradle-current-date-yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[3]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[4]}"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[4].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    Given API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 4
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 2
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 2

    Examples:
      | HubId       | HubName       |
      | {hub-id-21} | {hub-name-21} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op