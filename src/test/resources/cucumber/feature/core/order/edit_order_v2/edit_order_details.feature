@OperatorV2 @Core @EditOrderV2 @EditOrderDetails
Feature: Edit Order Details

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path
  Scenario: Operator Edit Order Details on Edit Order page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Edit Order Details on Edit Order V2 page
    When Operator Edit Order Details on Edit Order V2 page:
      | deliveryTypes | DELIVERY_SAME_DAY |
      | insuredValue  | 100               |
    Then Operator verifies that success react notification displayed:
      | top | Current order updated successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | deliveryType | DELIVERY_SAME_DAY |
      | insuredValue | 100               |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE INSURANCE                    |
      | description | Insured value changed from 0 to 100 |

  Scenario: Operator Edit Order Details - Edit Parcel Weight
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight": 5},"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Edit Order Details on Edit Order V2 page
    When Operator Edit Order Details on Edit Order V2 page:
      | weight | 10 |
    Then Operator verifies that success react notification displayed:
      | top | Current order updated successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | weight | 10 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE DIMENSION                                                |
      | description | Weight changed from 5 to 10 Pricing Weight changed from 5 to 10 |

  Scenario Outline: Operator Edit Order Details - Edit Parcel Size - <oldSize> to <newSize>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "<oldSize>", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Edit Order Details on Edit Order V2 page
    When Operator Edit Order Details on Edit Order V2 page:
      | size | <newSize> |
    Then Operator verifies that success react notification displayed:
      | top | Current order updated successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | size | <newSizeFull> |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE DIMENSION                                       |
      | description | Parcel Size ID changed from <oldSizeId> to <newSizeId> |
    Examples:
      | oldSize | oldSizeId | newSize | newSizeFull | newSizeId |
      | S       | 0         | M       | MEDIUM      | 1         |
      | M       | 1         | L       | LARGE       | 2         |
      | L       | 2         | XL      | EXTRALARGE  | 3         |
      | XL      | 3         | XXL     | XXLARGE     | 4         |
      | XXL     | 4         | XL      | EXTRALARGE  | 3         |

  Scenario: Operator Edit Order Details - Edit Parcel Dimensions
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                     |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"length":1,"width":2,"height":3},"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Edit Order Details on Edit Order V2 page
    When Operator Edit Order Details on Edit Order V2 page:
      | length  | 10 |
      | width   | 20 |
      | breadth | 30 |
    Then Operator verifies that success react notification displayed:
      | top | Current order updated successfully |
    Then Operator verifies order details on Edit Order V2 page:
      | length | 10 |
      | width  | 20 |
      | height | 30 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE DIMENSION                                                                   |
      | description | Length changed from 1 to 10 Width changed from 2 to 20 Height changed from 3 to 30 |
