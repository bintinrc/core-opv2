@OperatorV2 @Core @CrossBorderAnd3PL @ThirdPartyOrderManagement
Feature: Third Party Order Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Upload Single Third Party Order
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | 3plShipperName | {3pl-shipper-name}                    |
      | 3plShipperId   | {3pl-shipper-id}                      |
    Then Operator verify the new mapping is created successfully
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Transferred to 3PL" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | TRANSFERRED TO THIRD PARTY |
    And Operator verify order event on Edit Order V2 page using data below:
      | tags        | MANUAL ACTION                                                                                                                                                            |
      | name        | UPDATE STATUS                                                                                                                                                            |
      | description | Old Granular Status: Pending Pickup\nNew Granular Status: Transferred to 3PL\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: CREATE_THIRD_PARTY_ORDER |

  Scenario: Operator Edit Third Party Order
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | 3plShipperName | {3pl-shipper-name}                    |
      | 3plShipperId   | {3pl-shipper-id}                      |
    Then Operator verify the new mapping is created successfully
    When Operator edit the new mapping with a new data
    Then Operator verify the new edited data is updated successfully

  Scenario: Operator Delete Third Party Order
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | 3plShipperName | {3pl-shipper-name}                    |
      | 3plShipperId   | {3pl-shipper-id}                      |
    Then Operator verify the new mapping is created successfully
    When Operator delete the new mapping
    Then Operator verify the new mapping is deleted successfully

  @happy-path @HighPriority
  Scenario: Operator Upload Bulk Third Party Orders Successfully
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads bulk mapping for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    Then Operator verify multiple new mapping is created successfully

  Scenario: Operator Not Allowed to Transfer to 3PL for Completed Order - NOT Transferred to 3PL & Completed
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then API Core -  Wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status         | COMPLETED                             |
      | granularStatus | COMPLETED                             |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | 3plShipperName | {3pl-shipper-name}                    |
      | 3plShipperId   | {3pl-shipper-id}                      |
    Then Operator verify upload results on Third Party Order Management page:
      | trackingId        | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.trackingId}                         |
      | shipperId         | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.shipperId}                          |
      | thirdPlTrackingId | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.thirdPlTrackingId}                  |
      | status            | Order {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.trackingId} Already Completed |
    And API Core -  Wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status         | COMPLETED                             |
      | granularStatus | COMPLETED                             |

  Scenario: Operator Not Allowed to Transfer to 3PL for Completed Order - Transferred to 3PL & Completed
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | 3plShipperName | {3pl-shipper-name}                    |
      | 3plShipperId   | {3pl-shipper-id}                      |
    Then Operator verify the new mapping is created successfully
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core -  Wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status         | COMPLETED                             |
      | granularStatus | COMPLETED                             |
    And Operator uploads new mapping
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | 3plShipperName | {3pl-shipper-name}                    |
      | 3plShipperId   | {3pl-shipper-id}                      |
    Then Operator verify upload results on Third Party Order Management page:
      | trackingId        | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.trackingId}                                                                                                             |
      | shipperId         | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.shipperId}                                                                                                              |
      | thirdPlTrackingId | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.thirdPlTrackingId}                                                                                                      |
      | status            | Order {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.trackingId} uploaded multiple times with 3PL id: {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.thirdPlTrackingId} |
    And API Core -  Wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | status         | COMPLETED                             |
      | granularStatus | COMPLETED                             |

  Scenario: Operator Download and Verify Third Party Shipper Orders CSV File
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator download CSV file on Third Party Order Management page
    Then 3pl-orders CSV file is downloaded successfully
