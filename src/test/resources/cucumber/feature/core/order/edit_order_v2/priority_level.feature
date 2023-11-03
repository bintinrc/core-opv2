@OperatorV2 @Core @EditOrderV2 @PriorityLevel
Feature: Priority Level

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Edit Order - Add Priority Level less than 3
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Priority Level to "2" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Current order updated successfully |
    Then Operator verify Delivery Priority Level is "2" on Edit Order V2 page
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id            | {KEY_TRANSACTION.id} |
      | priorityLevel | 2                    |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id            | {KEY_TRANSACTION.id} |
      | priorityLevel | 0                    |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 17                                 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE SLA |

  Scenario: Edit Order - Update Priority Level less than Current Priority
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Operator update priority level of an order:
      | orderId       | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | priorityLevel | 2                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Edit Priority Level on Edit Order V2 page
    And Operator enter "1" Priority Level in Edit priority level dialog on Edit Order V2 page
    And Operator verify "New priority level has to be higher than the current level" error message in Edit priority level dialog on Edit Order V2 page
    And Operator verify Save changes button is disabled in Edit priority level dialog on Edit Order V2 page
    And Operator verify Current priority is "2" on Edit Order V2 page

  Scenario: Edit Order - Update Priority Level more than Current Priority
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Operator update priority level of an order:
      | orderId       | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | priorityLevel | 1                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Priority Level to "2" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Current order updated successfully |
    And Operator verify Current priority is "2" on Edit Order V2 page
    Then Operator verify Delivery Priority Level is "2" on Edit Order V2 page
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id            | {KEY_TRANSACTION.id} |
      | priorityLevel | 2                    |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id            | {KEY_TRANSACTION.id} |
      | priorityLevel | 0                    |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE SLA                                  |
      | description | Delivery Priority Level changed from 1 to 2 |

  Scenario: Edit Order - Add Priority Level After The Order Completed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Completed                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Priority Level to "2" on Edit Order V2 page
    Then Operator verifies that error react notification displayed:
      | top    | Status 200: Unknown                                              |
      | bottom | ^.*Error Message: Not allowed to update order after completion.* |
    And Operator verify Current priority is "0" on Edit Order V2 page

  Scenario: Edit Order - Add Priority Level more than 3
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Priority Level to "10" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Current order updated successfully |
    And Operator verify Current priority is "10" on Edit Order V2 page
    Then Operator verify Delivery Priority Level is "10" on Edit Order V2 page
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id            | {KEY_TRANSACTION.id} |
      | priorityLevel | 10                   |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id            | {KEY_TRANSACTION.id} |
      | priorityLevel | 0                    |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE SLA                                             |
      | description | Delivery Priority Level updated: assigned new value 10 |

  @happy-path @HighPriority
  Scenario: Operator Edit Priority Level
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Priority Level to "2" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Current order updated successfully |
    Then Operator verify Delivery Priority Level is "2" on Edit Order V2 page
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id            | {KEY_TRANSACTION.id} |
      | priorityLevel | 2                    |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id            | {KEY_TRANSACTION.id} |
      | priorityLevel | 0                    |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 17                                 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE SLA |
