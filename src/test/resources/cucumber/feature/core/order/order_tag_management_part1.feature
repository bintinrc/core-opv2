@OperatorV2 @Core @Order @OrderTagManagement @OrderTagManagementPart1
Feature: Order Tag Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path
  Scenario: Add Tags to Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator searches and selects orders created on Order Tag Management page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator tags order with:
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify the tags shown on Edit Order V2 page
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |

  @happy-path
  Scenario: Remove Tags from Order
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator searches and selects orders created on Order Tag Management page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator tags order with:
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator searches and selects orders created on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator removes order tags on Order Tag Management page:
      | {order-tag-name}   |
      | {order-tag-name-2} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify the tags shown on Edit Order V2 page
      | {order-tag-name-3} |

  Scenario: Update Tags from Order
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator searches and selects orders created on Order Tag Management page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator tags order with:
      | {order-tag-name} |
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator searches and selects orders created on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator tags order with:
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify the tags shown on Edit Order V2 page
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |

  Scenario: Clear All Tags from Order
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator searches and selects orders created on Order Tag Management page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator tags order with:
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator searches and selects orders created on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator clear all order tags on Order Tag Management page
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies no tags shown on Edit Order V2 page

  Scenario Outline: Search Orders on Order Tag Management Page by Order Type Filter - <Note>
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                     |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                              |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | orderType | <orderType> |
    Then Operator searches and selects orders created on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Examples:
      | Note   | orderType | isPickupRequired |
      | Normal | Normal    | false            |
      | Return | Return    | true             |

  Scenario: Search Orders on the Order Tag Management Page by RTS Filter - Hide RTS Orders
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                              |
      | rtsRequest | { "reason": "Return to sender: Nobody at address", "timewindow_id":1, "date":"{date: 1 days next, yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                              |
      | rtsRequest | { "reason": "Return to sender: Nobody at address", "timewindow_id":1, "date":"{date: 1 days next, yyyy-MM-dd}"} |
    When Operator go to menu Order -> Order Tag Management
    And Operator waits for 10 seconds
    Then Operator verifies selected value of RTS filter is "Hide" on Order Tag Management page
    When Operator clicks 'Clear All Selection' button on Order Tag Management page
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | rts | Hide |
    Then Operator verifies orders are not displayed on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
