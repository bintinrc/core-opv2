@OperatorV2 @Core @EditOrderV2 @OrderDimension
Feature: Order Dimensions Value and Type

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario Outline: Publish Dimension Value and Device Source on Hub Inbound Event with Updated Dimension and Size Value - Device Type = Manual
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSize>"}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                               |
      | globalInboundRequest | { "hubId":{hub-id}, "dimensions":{"width":<newWidth>,"height":<newHeight>,"length":<newLength>,"weight":<newWeight>,"size":"<newSize>"}} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    Then Operator verifies order details on Edit Order V2 page:
      | weight | <newWeight> |
      | height | <newHeight> |
      | length | <newLength> |
      | width  | <newWidth>  |
      | size   | <newSize>   |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | HUB INBOUND SCAN                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | hubName     | {hub-name}                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | description | Inbounded at hub {hub-id} from Global Shipper {shipper-v4-id} Weight changed from <oldWeight> to <newWeight> Length changed from <oldLength> to <newLength> Width changed from <oldWidth> to <newWidth> Height changed from <oldHeight> to <newHeight> Parcel Size ID changed from <oldSizeId> to <newSizeId> Set Aside: false Device Type: MANUAL Raw Height: <newHeight> Raw Length: <newLength> Raw Width: <newWidth> Raw Weight: <newWeight> |
    And DB Core - verify orders record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                  |
      | dimensions   | {"width":<newWidth>.0,"height":<newHeight>.0,"length":<newLength>.0,"weight":<newWeight>.0,"size":"<newSizeShort>"} |
      | parcelSizeId | <newSizeId>                                                                                                         |
    Examples:
      | oldWeight | oldHeight | oldLength | oldWidth | oldSize | oldSizeId | newWeight | newHeight | newLength | newWidth | newSize | newSizeId | newSizeShort |
      | 1         | 1         | 1         | 1        | S       | 0         | 5         | 45        | 10        | 30       | MEDIUM  | 1         | M            |

  @MediumPriority
  Scenario Outline: Publish Dimension Value and Device Source on Hub Inbound Event with No Updated Dimension or Size - Device Type = Manual
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSizeShort>"}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                             |
      | globalInboundRequest | { "hubId":{hub-id}, "dimensions":{"width":<newWidth>,"height":<newHeight>,"length":<newLength>,"weight":<newWeight>,"size":<newSize>}} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    Then Operator verifies order details on Edit Order V2 page:
      | weight | <oldWeight> |
      | height | <oldHeight> |
      | length | <oldLength> |
      | width  | <oldWidth>  |
      | size   | <oldSize>   |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | HUB INBOUND SCAN                                                                                                                                                                                                                                                                                                                                                                                          |
      | hubName     | {hub-name}                                                                                                                                                                                                                                                                                                                                                                                                |
      | description | Inbounded at hub {hub-id} from Global Shipper {shipper-v4-id} Weight changed from <oldWeight> to <oldWeight> Length changed from <oldLength> to <oldLength> Width changed from <oldWidth> to <oldWidth> Height changed from <oldHeight> to <oldHeight> Parcel Size ID changed from <oldSizeId> to <oldSizeId> Set Aside: false Device Type: MANUAL Raw Height: 0 Raw Length: 0 Raw Width: 0 Raw Weight: 0 |
    And DB Core - verify orders record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                  |
      | dimensions   | {"width":<oldWidth>.0,"height":<oldHeight>.0,"length":<oldLength>.0,"weight":<oldWeight>.0,"size":"<oldSizeShort>"} |
      | parcelSizeId | <oldSizeId>                                                                                                         |
    Examples:
      | oldWeight | oldHeight | oldLength | oldWidth | oldSize | oldSizeShort | oldSizeId | newWeight | newHeight | newLength | newWidth | newSize |
      | 1         | 1         | 1         | 1        | SMALL   | S            | 0         | null      | null      | null      | null     | null    |

  @MediumPriority
  Scenario Outline: Publish Dimension Value on Update Dimension Event - Manual Dimension
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSize>"}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - update order dimensions:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                       |
      | dimensions | {"width":<newWidth>,"height":<newHeight>,"length":<newLength>,"weight":<newWeight>,"pricingWeight":<newWeight>,"parcelSize":"<newSize>"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | weight | <newWeight> |
      | height | <newHeight> |
      | length | <newLength> |
      | width  | <newWidth>  |
      | size   | <newSize>   |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE DIMENSION                                                                                                                                                                                                                                                                                       |
      | description | Weight changed from <oldWeight> to <newWeight> Pricing Weight changed from <oldWeight> to <newWeight> Length changed from <oldLength> to <newLength> Width changed from <oldWidth> to <newWidth> Height changed from <oldHeight> to <newHeight> Parcel Size ID changed from <oldSizeId> to <newSizeId> |
    And DB Core - verify orders record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                  |
      | dimensions   | {"width":<newWidth>.0,"height":<newHeight>.0,"length":<newLength>.0,"weight":<newWeight>.0,"size":"<newSizeShort>"} |
      | parcelSizeId | <newSizeId>                                                                                                         |
    Examples:
      | oldWeight | oldHeight | oldLength | oldWidth | oldSize | oldSizeId | newWeight | newHeight | newLength | newWidth | newSize | newSizeId | newSizeShort |
      | 1         | 1         | 1         | 1        | S       | 0         | 5         | 45        | 10        | 30       | MEDIUM  | 1         | M            |

  @MediumPriority
  Scenario Outline: Publish Dimension Value and Device Source on Hub Inbound Event with Updated Dimension and Size Value - Device Type = DWS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSize>"}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - DWS inbound V1
      | barcodes          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}    |
      | hubId             | {hub-id}                                 |
      | dwsInboundRequest | {"dimensions":{"l":100,"w":300,"h":450}} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    Then Operator verifies order details on Edit Order V2 page:
      | weight | <oldWeight> |
      | height | <newHeight> |
      | length | <newLength> |
      | width  | <newWidth>  |
      | size   | <newSize>   |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | HUB INBOUND SCAN                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | hubName     | {hub-name}                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | description | Inbounded at hub {hub-id} from Global Shipper {shipper-v4-id} Weight changed from <oldWeight> to <oldWeight> Length changed from <oldLength> to <newLength> Width changed from <oldWidth> to <newWidth> Height changed from <oldHeight> to <newHeight> Parcel Size ID changed from <oldSizeId> to <newSizeId> Set Aside: false Device Type: DWS Raw Height: <newHeight> Raw Length: <newLength> Raw Width: <newWidth> Raw Weight: 0 |
    And DB Core - verify orders record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                  |
      | dimensions   | {"width":<newWidth>.0,"height":<newHeight>.0,"length":<newLength>.0,"weight":<oldWeight>.0,"size":"<newSizeShort>"} |
      | parcelSizeId | <newSizeId>                                                                                                         |
    Examples:
      | oldWeight | oldHeight | oldLength | oldWidth | oldSize | oldSizeId | newHeight | newLength | newWidth | newSize | newSizeId | newSizeShort |
      | 1         | 1         | 1         | 1        | S       | 0         | 45        | 10        | 30       | MEDIUM  | 1         | M            |

  @MediumPriority
  Scenario Outline: Publish Dimension Value and Device Source on Hub Inbound Event with No Updated Dimension or Size - Device Type = DWS
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSizeShort>"}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - DWS inbound V1
      | barcodes          | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}       |
      | hubId             | {hub-id}                                    |
      | dwsInboundRequest | {"dimensions":{"l":null,"w":null,"h":null}} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    Then Operator verifies order details on Edit Order V2 page:
      | weight | <oldWeight> |
      | height | <oldHeight> |
      | length | <oldLength> |
      | width  | <oldWidth>  |
      | size   | <oldSize>   |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | HUB INBOUND SCAN                                                                                                                                                                                                                                                                                                                                                                                       |
      | hubName     | {hub-name}                                                                                                                                                                                                                                                                                                                                                                                             |
      | description | Inbounded at hub {hub-id} from Global Shipper {shipper-v4-id} Weight changed from <oldWeight> to <oldWeight> Length changed from <oldLength> to <oldLength> Width changed from <oldWidth> to <oldWidth> Height changed from <oldHeight> to <oldHeight> Parcel Size ID changed from <oldSizeId> to <oldSizeId> Set Aside: false Device Type: DWS Raw Height: 0 Raw Length: 0 Raw Width: 0 Raw Weight: 0 |
    And DB Core - verify orders record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                  |
      | dimensions   | {"width":<oldWidth>.0,"height":<oldHeight>.0,"length":<oldLength>.0,"weight":<oldWeight>.0,"size":"<oldSizeShort>"} |
      | parcelSizeId | <oldSizeId>                                                                                                         |
    Examples:
      | oldWeight | oldHeight | oldLength | oldWidth | oldSize | oldSizeShort | oldSizeId |
      | 1         | 1         | 1         | 1        | SMALL   | S            | 0         |
