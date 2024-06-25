@OperatorV2 @Core @Routing @RouteLogs @MergeTransactions @MergeTransactions @TH @current
Feature: Route Logs - Merge Transactions - TH - Cannot Merge

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Route Logs - Operator Merge Transactions of Multiple Routes - Pickup Transactions - Tagged with Same DP - Cannot Merge
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                           |
      | generateFrom        | INDEX-4                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | INDEX-5                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                           |
      | generateFrom        | INDEX-6                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | INDEX-7                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    # Tag orders to DP 1
    When API DP - DP user authenticate with username "{dp-1-id-lodge-in-dp-username}" password "{dp-1-id-lodge-in-dp-password}" and dp id "{dp-1-id}"
    Then API DP - DP lodge in order:
      | lodgeInRequest | {"dp_id":{dp-1-id},"reservations":[{"shipper_id":{shipper-v4-id},"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"}]} |
    Then API DP - DP lodge in order:
      | lodgeInRequest | {"dp_id":{dp-1-id},"reservations":[{"shipper_id":{shipper-v4-id},"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}"}]} |
    Then API DP - DP lodge in order:
      | lodgeInRequest | {"dp_id":{dp-1-id},"reservations":[{"shipper_id":{shipper-v4-id},"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}"}]} |
    Then API DP - DP lodge in order:
      | lodgeInRequest | {"dp_id":{dp-1-id},"reservations":[{"shipper_id":{shipper-v4-id},"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}"}]} |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[2].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[4].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}, {KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 2 Routes Merged                                            |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id}, {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    #  Verify transaction is not merged
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |

  @ArchiveRouteCommonV2 @MediumPriority @wip
  Scenario: Route Logs - Operator Merge Transactions of Multiple Routes from Route Logs Page - Delivery Transactions - Tagged with Same DP - Cannot Merge
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 4                                                                                                                                                                                                                                                                                                                                           |
      | generateFrom        | INDEX-4                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | INDEX-5                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    # Tag orders to different DP
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{dp-1-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[2].id},"dp_id":{dp-1-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[3].id},"dp_id":{dp-2-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[4].id},"dp_id":{dp-2-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[2].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[4].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}, {KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 2 Routes Merged                                            |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id}, {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    #  Verify transaction is not merged
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Route Logs - Operator Merge Multiple Transactions of Single Route - Pickup Transaction - Different Phone Number - Cannot Merge
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>", "address": {"address1": "Orchard Road central","address2": "","country": "TH","postcode": "10100","latitude": 1.3248209,"longitude": 103.6983167}},"to": { "name": "binti v4.1", "phone_number": "+6595557073", "email": "aaa@mail.com", "address": { "address1": "Orchard Road central", "address2": "", "country": "TH", "postcode": "10100", "latitude": 1.3248209, "longitude": 103.6983167 } },"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_1>", "address": {"address1": "Orchard Road central","address2": "","country": "TH","postcode": "10100","latitude": 1.3248209,"longitude": 103.6983167}},"to": { "name": "binti v4.1", "phone_number": "+6595557073", "email": "aaa@mail.com", "address": { "address1": "Orchard Road central", "address2": "", "country": "TH", "postcode": "10100", "latitude": 1.3248209, "longitude": 103.6983167 } },"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id},  "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |

    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Pickup           | PP   | Return       | from      | generateTo      | binti@test.co | binti@test.co | +6622134567    | +6622134561    | true               |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Route Logs - Operator Merge Multiple Transactions of Single Route - Delivery Transaction - Different Phone Number - Cannot Merge
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "TH","postcode": "10260","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "TH","postcode": "10260","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id},  "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co | +6622134567    | +6622134561    | false              |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Route Logs - Operator Merge Multiple Transactions of Single Route - Pickup Transaction - Different Address, Approximate Coordinate - Cannot Merge
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>", "address": {"address1": "<address_1>","address2": "","country": "TH","postcode": "10100","latitude": 1.3248202,"longitude": 103.6983160}},"to": { "name": "binti v4.1", "phone_number": "+6595557073", "email": "aaa@mail.com", "address": { "address1": "Orchard Road central", "address2": "", "country": "TH", "postcode": "10100", "latitude": 1.3248209, "longitude": 103.6983167 } },"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>", "address": {"address1": "<address_2>","address2": "","country": "TH","postcode": "10100","latitude": 1.3248202,"longitude": 103.6983160}},"to": { "name": "binti v4.1", "phone_number": "+6595557073", "email": "aaa@mail.com", "address": { "address1": "Orchard Road central", "address2": "", "country": "TH", "postcode": "10100", "latitude": 1.3248209, "longitude": 103.6983167 } },"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id},  "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |

    Examples:
      | transaction_type | type | service_type | direction | address_1    | address_2     | email_1       | email_2           | phone_number_1 | phone_number_2 | is_pickup_required |
      | Pickup           | PP   | Return       | from      | Khaosan Road | Ningling Road | binti@test.co | binti1234@test.co | +6622134567    | +66221345671   | true               |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Route Logs - Operator Merge Multiple Transactions of Single Route - Delivery Transaction - Different Address, Approximate Coordinate - Cannot Merge
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "<address_1>","address2": "","country": "TH","postcode": "10100","latitude": 1.3248200,"longitude": 103.6983160}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "<address_2>","address2": "","country": "TH","postcode": "10100","latitude": 1.3248200,"longitude": 103.6983160}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id},  "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2           | address_1    | address_2      | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti1234@test.co | Khaosan Road | Ningshang Road | +6622134567    | +6622134561    | false              |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Route Logs - Operator Merge Multiple Transactions of Single Route - Pickup Transaction - Different Address, Approximate Coordinate, Different Email - Cannot Merge
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>", "address": {"address1": "<address_1>","address2": "","country": "TH","postcode": "10100","latitude": 1.3248202,"longitude": 103.6983160}},"to": { "name": "binti v4.1", "phone_number": "+6595557073", "email": "aaa@mail.com", "address": { "address1": "Orchard Road central", "address2": "", "country": "TH", "postcode": "10100", "latitude": 1.3248209, "longitude": 103.6983167 } },"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_2>", "address": {"address1": "<address_2>","address2": "","country": "TH","postcode": "10100","latitude": 1.3248202,"longitude": 103.6983160}},"to": { "name": "binti v4.1", "phone_number": "+6595557073", "email": "aaa@mail.com", "address": { "address1": "Orchard Road central", "address2": "", "country": "TH", "postcode": "10100", "latitude": 1.3248209, "longitude": 103.6983167 } },"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id},  "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |

    Examples:
      | transaction_type | type | service_type | direction | address_1    | address_2     | email_1       | email_2           | phone_number_1 | phone_number_2 | is_pickup_required |
      | Pickup           | PP   | Return       | from      | Khaosan Road | Ningling Road | binti@test.co | binti1234@test.co | +6622134567    | +66221345671   | true               |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Route Logs - Operator Merge Multiple Transactions of Single Route - Delivery Transaction - Different Address, Approximate Coordinate, Different Email - Cannot Merge
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "<address_1>","address2": "","country": "TH","postcode": "10260","latitude": 1.3248200,"longitude": 103.6983160}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_2>","address": {"address1": "<address_2>","address2": "","country": "TH","postcode": "10260","latitude": 1.3248200,"longitude": 103.6983160}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id},  "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2           | address_1    | address_2      | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti1234@test.co | Khaosan Road | Ningshang Road | +6622134567    | +6622134561    | false              |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Route Logs - Operator Merge Multiple Transactions of Single Route - Pickup Transaction - Different Address, Approximate Coordinate, Different Phone Number - Cannot Merge
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>", "address": {"address1": "<address_1>","address2": "","country": "TH","postcode": "10100","latitude": 1.3248202,"longitude": 103.6983160}},"to": { "name": "binti v4.1", "phone_number": "+6595557073", "email": "aaa@mail.com", "address": { "address1": "Orchard Road central", "address2": "", "country": "TH", "postcode": "10100", "latitude": 1.3248209, "longitude": 103.6983167 } },"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_1>", "address": {"address1": "<address_2>","address2": "","country": "TH","postcode": "10100","latitude": 1.3248202,"longitude": 103.6983160}},"to": { "name": "binti v4.1", "phone_number": "+6595557073", "email": "aaa@mail.com", "address": { "address1": "Orchard Road central", "address2": "", "country": "TH", "postcode": "10100", "latitude": 1.3248209, "longitude": 103.6983167 } },"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id},  "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |

    Examples:
      | transaction_type | type | service_type | direction | address_1    | address_2     | email_1       | email_2           | phone_number_1 | phone_number_2 | is_pickup_required |
      | Pickup           | PP   | Return       | from      | Khaosan Road | Ningling Road | binti@test.co | binti1234@test.co | +6622134567    | +6622134561    | true               |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Route Logs - Operator Merge Multiple Transactions of Single Route - Delivery Transaction - Different Address, Approximate Coordinate, Different Phone Number - Cannot Merge
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "<address_1>","address2": "","country": "TH","postcode": "10260","latitude": 1.3248200,"longitude": 103.6983160}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "<address_2>","address2": "","country": "TH","postcode": "10260","latitude": 1.3248200,"longitude": 103.6983160}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id},  "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2           | address_1    | address_2      | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti1234@test.co | Khaosan Road | Ningshang Road | +6622134567    | +6622134561    | false              |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Route Logs - Operator Merge Multiple Transactions of Single Route - Pickup Transaction - Different Delivery Verification Mode - Cannot Merge
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>", "address": {"address1": "Orchard Road central","address2": "","country": "TH","postcode": "10100","latitude": 1.3248209,"longitude": 103.6983167}},"to": { "name": "binti v4.1", "phone_number": "+6595557073", "email": "aaa@mail.com", "address": { "address1": "Orchard Road central", "address2": "", "country": "TH", "postcode": "10100", "latitude": 1.3248209, "longitude": 103.6983167 } },"parcel_job":{ "allow_doorstep_dropoff": false, "enforce_delivery_verification": true, "delivery_verification_mode": "IDENTIFICATION", "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>", "address": {"address1": "Orchard Road central","address2": "","country": "TH","postcode": "10100","latitude": 1.3248209,"longitude": 103.6983167}},"to": { "name": "binti v4.1", "phone_number": "+6595557073", "email": "aaa@mail.com", "address": { "address1": "Orchard Road central", "address2": "", "country": "TH", "postcode": "10100", "latitude": 1.3248209, "longitude": 103.6983167 } },"parcel_job":{ "allow_doorstep_dropoff": false, "enforce_delivery_verification": true, "delivery_verification_mode": "OTP", "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id},  "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |

    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Pickup           | PP   | Return       | from      | generateTo      | binti@test.co | binti@test.co | +6622134567    | +6622134561    | true               |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Route Logs - Operator Merge Multiple Transactions of Single Route - Delivery Transaction - Different Delivery Verification Mode - Cannot Merge
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard", "parcel_job":{ "allow_doorstep_dropoff": false, "enforce_delivery_verification": true, "delivery_verification_mode": "IDENTIFICATION", "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard", "parcel_job":{ "allow_doorstep_dropoff": false, "enforce_delivery_verification": true, "delivery_verification_mode": "OTP", "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id},  "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    # Verify waypoints not merged
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co | +6622134567    | +6622134561    | false              |
