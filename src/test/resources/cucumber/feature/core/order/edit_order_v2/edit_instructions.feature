@OperatorV2 @Core @EditOrderV2 @EditInstructions
Feature: Edit Instructions

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Edit Instructions of an Order on Edit Order Page - Pickup Instructions
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator click Order Settings -> Edit Instructions on Edit Order V2 page
    When Operator enter Order Instructions on Edit Order V2 page:
      | pickupInstruction | new pickup instruction |
    Then Operator verifies that success react notification displayed:
      | top                | Instructions updated |
      | waitUntilInvisible | true                 |
    And Operator refresh page
    When Operator verify Order Instructions on Edit Order V2 page:
      | pickupInstruction | new pickup instruction                      |
      | orderInstruction  | {KEY_LIST_OF_CREATED_ORDERS[1].instruction} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE INSTRUCTION |

  Scenario: Operator Edit Instructions of an Order on Edit Order Page - Delivery Instructions
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator click Order Settings -> Edit Instructions on Edit Order V2 page
    When Operator enter Order Instructions on Edit Order V2 page:
      | deliveryInstruction | new delivery instruction |
    Then Operator verifies that success react notification displayed:
      | top                | Instructions updated |
      | waitUntilInvisible | true                 |
    And Operator refresh page
    When Operator verify Order Instructions on Edit Order V2 page:
      | deliveryInstruction | new delivery instruction                    |
      | orderInstruction    | {KEY_LIST_OF_CREATED_ORDERS[1].instruction} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE INSTRUCTION |

  Scenario: Operator Edit Instructions of an Order on Edit Order Page - Order Instructions
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator click Order Settings -> Edit Instructions on Edit Order V2 page
    When Operator enter Order Instructions on Edit Order V2 page:
      | pickupInstruction   | new pickup instruction   |
      | deliveryInstruction | new delivery instruction |
      | orderInstruction    | new order instruction    |
    Then Operator verifies that success react notification displayed:
      | top                | Instructions updated |
      | waitUntilInvisible | true                 |
    And Operator refresh page
    When Operator verify Order Instructions on Edit Order V2 page:
      | pickupInstruction   | new pickup instruction   |
      | deliveryInstruction | new delivery instruction |
      | orderInstruction    | new order instruction    |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE INSTRUCTION |

  Scenario: Operator Remove Instructions of an Order on Edit Order Page - Pickup, Delivery, Order Instructions
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator click Order Settings -> Edit Instructions on Edit Order V2 page
    When Operator enter Order Instructions on Edit Order V2 page:
      | pickupInstruction   | empty |
      | deliveryInstruction | empty |
      | orderInstruction    | empty |
    Then Operator verifies that success react notification displayed:
      | top                | Instructions updated |
      | waitUntilInvisible | true                 |
    And Operator refresh page
    When Operator verify Order Instructions on Edit Order V2 page:
      | pickupInstruction   | - |
      | deliveryInstruction | - |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE INSTRUCTION |