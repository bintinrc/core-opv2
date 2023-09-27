@OperatorV2 @Core @EditOrderV2 @UpdateStampId
Feature: Update Stamp ID

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Cancelled Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Cancelled                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core - verify orders record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | stampId | {KEY_STAMP_ID}                     |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window of "{KEY_LIST_OF_CREATED_ORDERS[1].id}"

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Staging Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core - verify orders record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | stampId | {KEY_STAMP_ID}                     |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window of "{KEY_LIST_OF_CREATED_ORDERS[1].id}"

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with On Hold Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | {DEFAULT-INVESTIGATING-PARTY}         |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | DAMAGED                               |
      | orderOutcomeName   | ORDER OUTCOME (NEW_DAMAGED)           |
      | creatorUserId      | {ticketing-creator-user-id}           |
      | creatorUserName    | {ticketing-creator-user-name}         |
      | creatorUserEmail   | {ticketing-creator-user-email}        |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core - verify orders record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | stampId | {KEY_STAMP_ID}                     |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window of "{KEY_LIST_OF_CREATED_ORDERS[1].id}"

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Pickup Fail Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Pickup Fail                        |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core - verify orders record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | stampId | {KEY_STAMP_ID}                     |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window of "{KEY_LIST_OF_CREATED_ORDERS[1].id}"

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with En-Route To Sorting Hub Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | En-route to Sorting Hub            |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core - verify orders record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | stampId | {KEY_STAMP_ID}                     |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window of "{KEY_LIST_OF_CREATED_ORDERS[1].id}"

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Pending Reschedule Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Pending Reschedule                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core - verify orders record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | stampId | {KEY_STAMP_ID}                     |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window of "{KEY_LIST_OF_CREATED_ORDERS[1].id}"

  Scenario: Update Stamp ID - Disallow Update Stamp ID with Completed Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Completed                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that error react notification displayed:
      | top    | Status 200: Unknown                                              |
      | bottom | ^.*Error Message: Not allowed to update order after completion.* |

  Scenario: Update Stamp ID - Disallow Update Stamp ID with Returned To Sender Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Returned To Sender                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that error react notification displayed:
      | top    | Status 200: Unknown                                              |
      | bottom | ^.*Error Message: Not allowed to update order after completion.* |

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with New Stamp ID
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | KEY_STAMP_ID |
    And DB Core - verify order by Stamp ID:
      | stampId    | {KEY_STAMP_ID}                        |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | KEY_STAMP_ID        |
    And Operator switch to Edit Order's window of "{KEY_LIST_OF_CREATED_ORDERS[1].id}"

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Stamp ID that Have been Used Before
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "NVSGSTAMPCOREOPV21" on Edit Order V2 page
    Then Operator verifies that error react notification displayed:
      | top    | Status 200: Unknown                                                             |
      | bottom | ^.*Error Message: Stamp NVSGSTAMPCOREOPV21 exists in order NVSGDIMMI000965047.* |
    When  Operator refresh page
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | - |

  Scenario: Remove Stamp ID
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    And Operator remove Stamp ID of the created order on Edit Order V2 page
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | - |
    When Operator go to menu Order -> All Orders
    Then Operator can't find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | KEY_STAMP_ID        |