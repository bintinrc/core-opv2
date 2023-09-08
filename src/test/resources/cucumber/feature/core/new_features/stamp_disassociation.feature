@OperatorV2 @Core @NewFeatures @StampDisassociation
Feature: Stamp Disassociation

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Should not be Able to Disassociate Order that Has no Stamp ID
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" value into 'Scan Stamp ID' field on Stamp Disassociation page
    Then Operator verify the label says "stamp id not available" on Stamp Disassociation page
    Then Operator verify order details on Stamp Disassociation page for order "KEY_LIST_OF_CREATED_ORDERS[1]"

  Scenario: Stamp Disassociation of Order by Stamp Id - Invalid Stamp Id
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enters "INVALID_STAMP_ID" value into 'Scan Stamp ID' field on Stamp Disassociation page
    Then Operator will get the "Not Found" alert on Stamp Disassociation page

  Scenario: Stamp Disassociation of Order by Stamp Id - Valid Stamp Id
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given New Stamp ID was generated
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | {"internal_ref":{"stamp_id":"{KEY_CORE_STAMP_ID}"},"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enters "{KEY_CORE_STAMP_ID}" value into 'Scan Stamp ID' field on Stamp Disassociation page
    Then Operator verify order details on Stamp Disassociation page for order "KEY_LIST_OF_CREATED_ORDERS[1]"
    When Operator click on the Disassociate Stamp button
    And Operator go to menu Order -> All Orders
    Then Operator can't find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | KEY_CORE_STAMP_ID   |

  Scenario: Stamp Disassociation of Order by Stamp Id - Invalid Tracking Id
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enters "INVALID_TRACKING_ID" value into 'Scan Stamp ID' field on Stamp Disassociation page
    Then Operator will get the "Not Found" alert on Stamp Disassociation page

  Scenario: Stamp Disassociation of Order by Stamp Id - Valid Tracking Id
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given New Stamp ID was generated
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | {"internal_ref":{"stamp_id":"{KEY_CORE_STAMP_ID}"},"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" value into 'Scan Stamp ID' field on Stamp Disassociation page
    Then Operator verify order details on Stamp Disassociation page for order "KEY_LIST_OF_CREATED_ORDERS[1]"
    When Operator click on the Disassociate Stamp button
    Then Operator verify the label says "stamp id not available" on Stamp Disassociation page
    And Disassociate Stamp button is disabled
