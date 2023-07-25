#@OperatorV2 @Core @EditOrder @EditOrder3 @OrderDimension
Feature: Order Dimensions Value and Type

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Publish Dimension Value and Device Source on Hub Inbound Event with Updated Dimension and Size Value - Device Type = Manual
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSize>"}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id}, "dimensions":{"width":30,"height":45,"length":10,"weight":5,"size":"MEDIUM"}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived At Sorting Hub" on Edit Order page
    Then Operator verifies dimensions information on Edit Order page:
      | weight | <newWeight> |
      | height | <newHeight> |
      | length | <newLength> |
      | width  | <newWidth>  |
      | size   | <newSize>   |
    And Operator verify order event on Edit order page using data below:
      | name        | HUB INBOUND SCAN                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | hubName     | {hub-name}                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | description | Inbounded at Hub {hub-id} from Shipper {shipper-v4-legacy-id} Weight changed from <oldWeight> to <newWeight> Length changed from <oldLength> to <newLength> Width changed from <oldWidth> to <newWidth> Height changed from <oldHeight> to <newHeight> Parcel Size ID changed from <oldSizeId> to <newSizeId> Set Aside: false Device Type: MANUAL Raw Height: <newHeight> Raw Length: <newLength> Raw Width: <newWidth> Raw Weight: <newWeight> |
    And DB Operator verifies orders record using data below:
      | dimensions   | {"weight":<newWeight>,"height":<newHeight>,"length":<newLength>,"width":<newWidth>,"size":"<newSizeShort>"} |
      | parcelSizeId | <newSizeId>                                                                                                 |
    Examples:
      | oldWeight | oldHeight | oldLength | oldWidth | oldSize | oldSizeId | newWeight | newHeight | newLength | newWidth | newSize | newSizeId | newSizeShort |
      | 1         | 1         | 1         | 1        | S       | 0         | 5         | 45        | 10        | 30       | MEDIUM  | 1         | M            |

  Scenario Outline: Publish Dimension Value and Device Source on Hub Inbound Event with No Updated Dimension or Size - Device Type = Manual
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSizeShort>"}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id}, "dimensions":{"width":<newWidth>,"height":<newHeight>,"length":<newLength>,"weight":<newWeight>,"size":<newSize>}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived At Sorting Hub" on Edit Order page
    Then Operator verifies dimensions information on Edit Order page:
      | weight | <oldWeight> |
      | height | <oldHeight> |
      | length | <oldLength> |
      | width  | <oldWidth>  |
      | size   | <oldSize>   |
    And Operator refresh page
    And Operator verify order event on Edit order page using data below:
      | name        | HUB INBOUND SCAN                                                                                                                                                                                                                                                                                                                                                                                          |
      | hubName     | {hub-name}                                                                                                                                                                                                                                                                                                                                                                                                |
      | description | Inbounded at Hub {hub-id} from Shipper {shipper-v4-legacy-id} Weight changed from <oldWeight> to <oldWeight> Length changed from <oldLength> to <oldLength> Width changed from <oldWidth> to <oldWidth> Height changed from <oldHeight> to <oldHeight> Parcel Size ID changed from <oldSizeId> to <oldSizeId> Set Aside: false Device Type: MANUAL Raw Height: 0 Raw Length: 0 Raw Width: 0 Raw Weight: 0 |
    And DB Operator verifies orders record using data below:
      | dimensions   | {"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSizeShort>"} |
      | parcelSizeId | <oldSizeId>                                                                                                 |
    Examples:
      | oldWeight | oldHeight | oldLength | oldWidth | oldSize | oldSizeShort | oldSizeId | newWeight | newHeight | newLength | newWidth | newSize |
      | 1         | 1         | 1         | 1        | SMALL   | S            | 0         | null      | null      | null      | null     | null    |

  Scenario Outline: Publish Dimension Value on Update Dimension Event - Manual Dimension
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSize>"}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update dimensions of an order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}                                                                                                        |
      | dimensions | {"width":<newWidth>,"height":<newHeight>,"length":<newLength>,"weight":<newWeight>,"pricingWeight":<newWeight>,"parcelSize":"<newSize>"} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verifies dimensions information on Edit Order page:
      | weight | <newWeight> |
      | height | <newHeight> |
      | length | <newLength> |
      | width  | <newWidth>  |
      | size   | <newSize>   |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE DIMENSION                                                                                                                                                                                                                                                                                       |
      | description | Weight changed from <oldWeight> to <newWeight> Pricing Weight changed from <oldWeight> to <newWeight> Length changed from <oldLength> to <newLength> Width changed from <oldWidth> to <newWidth> Height changed from <oldHeight> to <newHeight> Parcel Size Id changed from <oldSizeId> to <newSizeId> |
    And DB Operator verifies orders record using data below:
      | dimensions   | {"weight":<newWeight>,"height":<newHeight>,"length":<newLength>,"width":<newWidth>,"size":"<newSizeShort>"} |
      | parcelSizeId | <newSizeId>                                                                                                 |
    Examples:
      | oldWeight | oldHeight | oldLength | oldWidth | oldSize | oldSizeId | newWeight | newHeight | newLength | newWidth | newSize | newSizeId | newSizeShort |
      | 1         | 1         | 1         | 1        | S       | 0         | 5         | 45        | 10        | 30       | MEDIUM  | 1         | M            |

  Scenario Outline: Publish Dimension Value and Device Source on Hub Inbound Event with Updated Dimension and Size Value - Device Type = DWS
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSize>"}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":5000.0},"dimensions":{"l":100,"w":300,"h":450},"hub_id":{hub-id}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived At Sorting Hub" on Edit Order page
    Then Operator verifies dimensions information on Edit Order page:
      | weight | <newWeight> |
      | height | <newHeight> |
      | length | <newLength> |
      | width  | <newWidth>  |
      | size   | <newSize>   |
    And Operator verify order event on Edit order page using data below:
      | name        | HUB INBOUND SCAN                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | hubName     | {hub-name}                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | description | Inbounded at Hub {hub-id} from Shipper {shipper-v4-legacy-id} Weight changed from <oldWeight> to <newWeight> Length changed from <oldLength> to <newLength> Width changed from <oldWidth> to <newWidth> Height changed from <oldHeight> to <newHeight> Parcel Size ID changed from <oldSizeId> to <newSizeId> Set Aside: false Device Type: DWS Raw Height: <newHeight> Raw Length: <newLength> Raw Width: <newWidth> Raw Weight: <newWeight> |
    And DB Operator verifies orders record using data below:
      | dimensions   | {"weight":<newWeight>,"height":<newHeight>,"length":<newLength>,"width":<newWidth>,"size":"<newSizeShort>"} |
      | parcelSizeId | <newSizeId>                                                                                                 |
    Examples:
      | oldWeight | oldHeight | oldLength | oldWidth | oldSize | oldSizeId | newWeight | newHeight | newLength | newWidth | newSize | newSizeId | newSizeShort |
      | 1         | 1         | 1         | 1        | S       | 0         | 5         | 45        | 10        | 30       | MEDIUM  | 1         | M            |

  Scenario Outline: Publish Dimension Value and Device Source on Hub Inbound Event with No Updated Dimension or Size - Device Type = DWS
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSizeShort>"}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":null},"dimensions":{"l":null,"w":null,"h":null},"hub_id":{hub-id}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived At Sorting Hub" on Edit Order page
    Then Operator verifies dimensions information on Edit Order page:
      | weight | <oldWeight> |
      | height | <oldHeight> |
      | length | <oldLength> |
      | width  | <oldWidth>  |
      | size   | <oldSize>   |
    And Operator verify order event on Edit order page using data below:
      | name        | HUB INBOUND SCAN                                                                                                                                                                                                                                                                                                                                                                                       |
      | hubName     | {hub-name}                                                                                                                                                                                                                                                                                                                                                                                             |
      | description | Inbounded at Hub {hub-id} from Shipper {shipper-v4-legacy-id} Weight changed from <oldWeight> to <oldWeight> Length changed from <oldLength> to <oldLength> Width changed from <oldWidth> to <oldWidth> Height changed from <oldHeight> to <oldHeight> Parcel Size ID changed from <oldSizeId> to <oldSizeId> Set Aside: false Device Type: DWS Raw Height: 0 Raw Length: 0 Raw Width: 0 Raw Weight: 0 |
    And DB Operator verifies orders record using data below:
      | dimensions   | {"weight":<oldWeight>,"height":<oldHeight>,"length":<oldLength>,"width":<oldWidth>,"size":"<oldSizeShort>"} |
      | parcelSizeId | <oldSizeId>                                                                                                 |
    Examples:
      | oldWeight | oldHeight | oldLength | oldWidth | oldSize | oldSizeShort | oldSizeId |
      | 1         | 1         | 1         | 1        | SMALL   | S            | 0         |
