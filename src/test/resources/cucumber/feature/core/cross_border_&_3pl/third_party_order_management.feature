@OperatorV2 @Core @CrossBorderAnd3PL @ThirdPartyOrderManagement
Feature: Third Party Order Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Upload Single Third Party Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | 3plShipperName | {3pl-shipper-name} |
      | 3plShipperId   | {3pl-shipper-id}   |
    Then Operator verify the new mapping is created successfully
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order V2 page
    And Operator verify order granular status is "Transferred to 3PL" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | TRANSFERRED TO THIRD PARTY |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                              |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Pending Pickup\nNew Granular Status: Transferred to 3PL\n\nOld Order Status: Pending\nNew Order Status: Transit\n\nReason: CREATE_THIRD_PARTY_ORDER |

  Scenario: Operator Edit Third Party Order (uid:c0683282-fc84-4b36-a6ad-3a77bb0efc0a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | 3plShipperName | {3pl-shipper-name} |
      | 3plShipperId   | {3pl-shipper-id}   |
    Then Operator verify the new mapping is created successfully
    When Operator edit the new mapping with a new data
    Then Operator verify the new edited data is updated successfully

  Scenario: Operator Delete Third Party Order (uid:eacf2d3b-a8c3-4ca2-a7ce-888299d86e29)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | 3plShipperName | {3pl-shipper-name} |
      | 3plShipperId   | {3pl-shipper-id}   |
    Then Operator verify the new mapping is created successfully
    When Operator delete the new mapping
    Then Operator verify the new mapping is deleted successfully

  @happy-path
  Scenario: Operator Upload Bulk Third Party Orders Successfully (uid:77d98b59-635e-409e-8b0d-9e2aaa0f8a04)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads bulk mapping
    Then Operator verify multiple new mapping is created successfully

  Scenario: Operator Not Allowed to Transfer to 3PL for Completed Order - NOT Transferred to 3PL & Completed (uid:6b8e5cf9-0dab-4a5c-ac18-bd6846a41446)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Then API Operator wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | COMPLETED                                  |
      | granularStatus | COMPLETED                                  |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | 3plShipperName | {3pl-shipper-name} |
      | 3plShipperId   | {3pl-shipper-id}   |
    Then Operator verify upload results on Third Party Order Management page:
      | trackingId        | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.trackingId}                         |
      | shipperId         | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.shipperId}                          |
      | thirdPlTrackingId | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.thirdPlTrackingId}                  |
      | status            | Order {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.trackingId} Already Completed |
    And API Operator verifies order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | COMPLETED                                  |
      | granularStatus | COMPLETED                                  |

  Scenario: Operator Not Allowed to Transfer to 3PL for Completed Order - Transferred to 3PL & Completed (uid:62fd5735-c980-4043-b8d8-b0c099259218)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads new mapping
      | 3plShipperName | {3pl-shipper-name} |
      | 3plShipperId   | {3pl-shipper-id}   |
    Then Operator verify the new mapping is created successfully
    When API Operator force succeed created order
    Then API Operator wait for following order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | COMPLETED                                  |
      | granularStatus | COMPLETED                                  |
    And Operator uploads new mapping
      | 3plShipperName | {3pl-shipper-name} |
      | 3plShipperId   | {3pl-shipper-id}   |
    Then Operator verify upload results on Third Party Order Management page:
      | trackingId        | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.trackingId}                                                                                                             |
      | shipperId         | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.shipperId}                                                                                                              |
      | thirdPlTrackingId | {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.thirdPlTrackingId}                                                                                                      |
      | status            | Order {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.trackingId} uploaded multiple times with 3PL id: {KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS.thirdPlTrackingId} |
    And API Operator verifies order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | COMPLETED                                  |
      | granularStatus | COMPLETED                                  |

  Scenario: Operator Download and Verify Third Party Shipper Orders CSV File (uid:e7286159-6709-400a-8795-d5f155f34588)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator download CSV file on Third Party Order Management page
    Then 3pl-orders CSV file is downloaded successfully
