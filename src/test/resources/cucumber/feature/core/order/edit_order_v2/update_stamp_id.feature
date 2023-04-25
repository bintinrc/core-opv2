@OperatorV2 @Core @EditOrder @DeleteOrder @EditOrder4
Feature: Update Stamp ID

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Cancelled Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Cancelled                         |
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core Operator gets Order by Stamp ID
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Staging Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core Operator gets Order by Stamp ID
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with On Hold Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | On Hold                           |
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core Operator gets Order by Stamp ID
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Pickup Fail Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Pickup Fail                       |
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core Operator gets Order by Stamp ID
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with En-Route To Sorting Hub Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | En-route to Sorting Hub           |
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core Operator gets Order by Stamp ID
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Pending Reschedule Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Pending Reschedule                |
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Stamp ID updated successfully: {KEY_STAMP_ID} |
    Then Operator verify next order info on Edit Order V2 page:
      | stampId | {KEY_STAMP_ID} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE JOB INFO                                     |
      | description | Stamp ID updated: assigned new value {KEY_STAMP_ID} |
    And DB Core Operator gets Order by Stamp ID
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {KEY_STAMP_ID}      |
    And Operator switch to Edit Order's window

  Scenario: Update Stamp ID - Disallow Update Stamp ID with Completed Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Completed                         |
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that error react notification displayed:
      | top | Not allowed to update order after completion. |

  Scenario: Update Stamp ID - Disallow Update Stamp ID with Returned To Sender Order
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Returned To Sender                |
    When Operator open Edit Order V2 page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit Order V2 page
    Then Operator verifies that error react notification displayed:
      | top | Not allowed to update order after completion. |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op