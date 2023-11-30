@OperatorV2 @Core @Order @OrderTagManagement @OrderTagManagementPart2
Feature: Order Tag Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Orders on the Order Tag Management Page by RTS Filter - Show RTS Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                              |
      | rtsRequest | { "reason": "Return to sender: Nobody at address", "timewindow_id":1, "date":"{date: 1 days next, yyyy-MM-dd}"} |
    When Operator go to menu Order -> Order Tag Management
    Then Operator verifies selected value of RTS filter is "Hide" on Order Tag Management page
    When Operator clicks 'Clear All Selection' button on Order Tag Management page
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | rts | Show |
    Then Operator searches and selects orders created on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  Scenario: Search Orders on the Order Tag Management Page by Shipper Filter
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName | {filter-shipper-name} |
    Then Operator searches and selects orders created on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |


  Scenario: Search Orders on the Order Tag Management Page by Master Shipper Filter
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-marketplace-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-marketplace-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type": "Marketplace","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": true,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}} |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | masterShipperName | {shipper-v4-marketplace-name} |
    Then Operator searches and selects orders created on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  Scenario: Search Orders on the Order Tag Management Page by Status & Granular Status Filter
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-marketplace-client-id}                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-marketplace-client-secret}                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    Then Operator searches and selects orders created on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  Scenario: Search Orders on the Order Tag Management Page by CSV File
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-marketplace-client-id}                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-marketplace-client-secret}                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | {"hubId":{hub-id}}                    |
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator searches and selects orders created on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  Scenario: Add Order Tag To Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-marketplace-client-id}                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-marketplace-client-secret}                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    Given Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator searches and selects orders created on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator tags order with:
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                      |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator unmask edit order V2 page
    Then Operator verify the tags shown on Edit Order V2 page
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE TAGS                                                                        |
      | description | Tags updated From none To {order-tag-name-2}, {order-tag-name-3}, {order-tag-name} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ADD TO ROUTE |
    And DB Core - Operator verifies tags of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order:
      | {order-tag-id}   |
      | {order-tag-id-2} |
      | {order-tag-id-3} |
    And DB Core - Operator verifies order_tags_search record of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order:
      | tagIds   | {order-tag-id},{order-tag-id-2},{order-tag-id-3} |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | driverId | {ninja-driver-id}                                |