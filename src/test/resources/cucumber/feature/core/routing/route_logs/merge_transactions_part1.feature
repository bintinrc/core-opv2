@OperatorV2 @Core @Routing @RouteLogs @MergeTransactions @MergeTransactionsPart1
Feature: Route Logs - Merge Transactions

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @happy-path @HighPriority
  Scenario: Operator Merge Transactions of Multiple Routes from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 4                                                                                                                                                                                                                                                                                                                                            |
      | generateFrom        | INDEX-0                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | INDEX-1                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
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

  @ArchiveRouteCommonV2 @HighPriority
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Pickup Transactions - Same address, Email & Phone Number
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>",    "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 routes merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then API Core - Operator verifies "Pickup" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
#    merged waypoint is routed
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
#    orphaned waypoint is unrouted
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId  | null                                                       |
      | seqNo    | null                                                       |
      | status   | Pending                                                    |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Pickup           | PP   | Return       | from      | generateTo      | binti@test.co | binti@test.co | +6595557073    | +6595557073    | true               |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Delivery Transactions - Same address, Email & Phone Number
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>",    "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
#    merged waypoint is routed
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
#    orphaned waypoint is unrouted
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId  | null                                                       |
      | seqNo    | null                                                       |
      | status   | Pending                                                    |

    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co | +6595557073    | +6595557073    | false              |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Pickup Transaction - Same Address & Email But Different Phone Number
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>",    "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then API Core - Operator verifies "Pickup" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
#    merged waypoint is routed
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
#    orphaned waypoint is unrouted
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId  | null                                                       |
      | seqNo    | null                                                       |
      | status   | Pending                                                    |

    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Pickup           | PP   | Return       | from      | generateTo      | binti@test.co | binti@test.co | +6595557073    | +6595557074    | true               |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Delivery Transaction - Same Address & Email But Different Phone Number
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>",    "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
#    merged waypoint is routed
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
#    orphaned waypoint is unrouted
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId  | null                                                       |
      | seqNo    | null                                                       |
      | status   | Pending                                                    |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co | +6595557073    | +6595557074    | false              |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Pickup Transaction - Same Address & Phone Number But Different Email
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>",    "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | <generateAddress>   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then API Core - Operator verifies "Pickup" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
#    merged waypoint is routed
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
#    orphaned waypoint is unrouted
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId} |
      | routeId  | null                                                       |
      | seqNo    | null                                                       |
      | status   | Pending                                                    |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2         | phone_number_1 | phone_number_2 | is_pickup_required |
      | Pickup           | PP   | Return       | from      | generateTo      | binti@test.co | another@test.co | +6595557073    | +6595557073    | true               |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Delivery Transaction - Same Address & Phone Number But Different Email
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
#    merged waypoint is routed
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo    | not null                                                   |
      | status   | Routed                                                     |
#    orphaned waypoint is unrouted
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routeId  | null                                                       |
      | seqNo    | null                                                       |
      | status   | Pending                                                    |
    Examples:
      | type | email_1       | email_2         | phone_number_1 |
      | DD   | binti@test.co | another@test.co | +6595557073    |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Merge Multiple Transactions of Single Route - Pickup and Delivery Transactions - Same address, Email & Phone Number
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "PICKUP" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[4].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then API Core - Operator verifies "Pickup" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Then API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[4].id} |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Merge Multiple Transactions of Multiple Route - Delivery Transactions - Same address, Email & Phone Number
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[2].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[4].id} |
    Given Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}, {KEY_LIST_OF_CREATED_ROUTES[2].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 2 Routes Merged                                            |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id}, {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    Then API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[4].id} |
