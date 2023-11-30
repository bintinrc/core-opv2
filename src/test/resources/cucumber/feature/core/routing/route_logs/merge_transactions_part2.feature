@OperatorV2 @Core @Routing @RouteLogs @MergeTransactions @MergeTransactionsPart2
Feature: Route Logs - Merge Transactions

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @MediumPriority
  Scenario Outline: Operator Disallow Merge Multiple Transactions of Single Route - Delivery Transactions  - Empty & Non-Empty Delivery OTP
    Given API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"allow_doorstep_dropoff":false,"enforce_delivery_verification":true,"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"<type>" } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | routeDateTo   | {gradle-next-1-day-dd/MM/yyyy}   |
      | hubName       | {hub-name}                       |
    And API Operator get order details
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    When Operator merge transactions of created routes
    And API Operator get order details
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator verifies <transaction_type> transactions of following orders have different waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co | +6595557073    | +6595557073    | false              |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario Outline: Operator Disallow Merge Multiple Transactions of Single Route - Delivery Transactions - Different Order Verification Method
    Given API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":"bnc168"}},"parcel_job":{"allow_doorstep_dropoff":false,"enforce_delivery_verification":true,"delivery_verification_mode": "Identification","is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"allow_doorstep_dropoff":false,"enforce_delivery_verification":true,"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"<type>" } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | routeDateTo   | {gradle-next-1-day-dd/MM/yyyy}   |
      | hubName       | {hub-name}                       |
    And API Operator get order details
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    When Operator merge transactions of created routes
    And API Operator get order details
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator verifies <transaction_type> transactions of following orders have different waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co | +6595557073    | +6595557073    | false              |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario Outline: Operator Disallow Merge Multiple Transactions of Single Route - Pickup and Delivery Transactions - Default email - Same Default Email & Different Phone Number
    Given API Shipper create V4 order using data below:
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} | { "type":"PP" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} | { "type":"PP" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} | { "type":"DD" }         |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | routeDateTo   | {gradle-next-1-day-dd/MM/yyyy}   |
      | hubName       | {hub-name}                       |
    And API Operator get order details
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    When Operator merge transactions of created routes
    And API Operator get order details
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 routes merged       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator verifies Pickup transactions of following orders have different waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And API Operator verifies Delivery transactions of following orders have different waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} |
    Examples:
      | email_1             | phone_number_1 | phone_number_2 |
      | support@ninjavan.co | +6595557073    | +6595557072    |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Delivery Transactions - Different DP Delivery
    Given API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator tag "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order to "{dp-id}" DP
    And API Operator tag "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" order to "{alternate-dp-id-1}" DP
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"<type>" } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | routeDateTo   | {gradle-next-1-day-dd/MM/yyyy}   |
      | hubName       | {hub-name}                       |
    And API Operator get order details
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    When Operator merge transactions of created routes
    And API Operator get order details
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator verifies <transaction_type> transactions of following orders have different waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | phone_number_1 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | +6595557073    | false              |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Pickup and Delivery Transactions  - Default email - Same Default Email & Same Phone Number
    Given API Shipper create V4 order using data below:
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} | { "type":"PP" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} | { "type":"PP" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} | { "type":"DD" }         |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | routeDateTo   | {gradle-next-1-day-dd/MM/yyyy}   |
      | hubName       | {hub-name}                       |
    And API Operator get multiple order details by saved Order ID
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    And API Operator gets "Pickup" transaction waypoint ids of created orders
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator get order details
    And API Operator verifies Pickup transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And API Operator verifies Delivery transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} |
    And Operator save the last DELIVERY transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[3]}" order as "KEY_TRANSACTION_AFTER"
    And DB Operator verifies waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Routed                             |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
      | seqNo   | null                               |

    And DB Operator verifies route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
    And API Operator gets orphaned "Delivery" transaction waypoint ids of created orders
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted

    And Operator save the last PICKUP transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order as "KEY_TRANSACTION_AFTER"
    And DB Operator verifies waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Routed                             |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
      | seqNo   | null                               |

    And DB Operator verifies route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
    And API Operator gets orphaned "Pickup" transaction waypoint ids of created orders
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted

    Examples:
      | email_1             | phone_number_1 |
      | support@ninjavan.co | +6595557073    |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Delivery Transactions - Same DP Delivery
    Given API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator tag "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order to "{dp-id}" DP
    And API Operator tag "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" order to "{dp-id}" DP
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"<type>" } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | routeDateTo   | {gradle-next-1-day-dd/MM/yyyy}   |
      | hubName       | {hub-name}                       |
    And API Operator get multiple order details by saved Order ID
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    When Operator merge transactions of created routes
    And API Operator get order details
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator get order details
    And API Operator verifies <transaction_type> transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And Operator save the last DELIVERY transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order as "KEY_TRANSACTION_AFTER"
    And DB Operator verifies waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Routed                             |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
      | seqNo   | null                               |

    And DB Operator verifies route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
    And API Operator gets orphaned "Delivery" transaction waypoint ids of created orders
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted

    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | phone_number_1 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | +6595557073    | false              |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Delivery Transactions - Non-Empty Delivery OTP - Different Delivery OTP
    Given API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"allow_doorstep_dropoff":false,"enforce_delivery_verification":true,"cash_on_delivery": 0,"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"allow_doorstep_dropoff":false,"enforce_delivery_verification":true,"cash_on_delivery": 0,"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"<type>" } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | routeDateTo   | {gradle-next-1-day-dd/MM/yyyy}   |
      | hubName       | {hub-name}                       |
    And API Operator get multiple order details by saved Order ID
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    When Operator merge transactions of created routes
    And API Operator get order details
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator get order details
    And API Operator verifies <transaction_type> transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And Operator save the last DELIVERY transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order as "KEY_TRANSACTION_AFTER"
    And DB Operator verifies waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Routed                             |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
      | seqNo   | null                               |

    And DB Operator verifies route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
    And API Operator gets orphaned "Delivery" transaction waypoint ids of created orders
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted

    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co | +6595557073    | +6595557073    | false              |

  @DeleteOrArchiveRoute @MediumPriority
  Scenario Outline: Operator Merge Multiple Transactions of Single Route - Delivery Transactions - Empty Delivery OTP
    Given API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{"is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"<type>" } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | routeDateTo   | {gradle-next-1-day-dd/MM/yyyy}   |
      | hubName       | {hub-name}                       |
    And API Operator get multiple order details by saved Order ID
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    When Operator merge transactions of created routes
    And API Operator get order details
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 routes merged       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator get order details
    And API Operator verifies <transaction_type> transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And Operator save the last DELIVERY transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order as "KEY_TRANSACTION_AFTER"
    And DB Operator verifies waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Routed                             |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
      | seqNo   | null                               |

    And DB Operator verifies route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
    And API Operator gets orphaned "Delivery" transaction waypoint ids of created orders
    And DB Operator verifies all orphaned route_monitoring_data is hard-deleted

    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co | +6595557073    | +6595557073    | false              |

  @MediumPriority
  Scenario Outline: Operator Partial Merge Multiple Transactions of Single Route - Valid and Invalid Transactions - Partial Different Addresses
    Given API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_1>","email": "<email_1>",    "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | <generateAddress> | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<service_type>","service_level":"Standard","<direction>":{"name": "binti v4.1","phone_number": "<phone_number_2>","email": "<email_2>","address": {"address1": "Toa Payoh North","address2": "TPN","country": "SG","postcode": "511200"}},"parcel_job":{ "is_pickup_required":<is_pickup_required>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"<type>" } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And API Operator get order details
    And API Operator gets "Delivery" transaction waypoint ids of created orders
    When Operator merge transactions of created routes
    And API Operator get order details
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator verifies <transaction_type> transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    And API Operator verifies <transaction_type> transactions of following orders have different waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} |
    Examples:
      | transaction_type | type | service_type | direction | generateAddress | email_1       | email_2       | phone_number_1 | phone_number_2 | is_pickup_required |
      | Delivery         | DD   | Parcel       | to        | generateFrom    | binti@test.co | binti@test.co | +6595557073    | +6595557073    | false              |
