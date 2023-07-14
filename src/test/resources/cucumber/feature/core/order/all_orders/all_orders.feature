@OperatorV2 @Core @AllOrders @AllOrdersPage
Feature: All Orders

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path
  Scenario: Operator Cancel Multiple Orders on All Orders Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator unmask all orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    And Operator cancel multiple orders below on All Orders page:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And DB Core - verify orders record:
      | id             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | status         | Cancelled                          |
      | granularStatus | Cancelled                          |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id}         |
      | type       | PP                                                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | status     | Cancelled                                                  |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | type       | DD                                                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status     | Cancelled                                                  |


  Scenario: Operator Download CSV File of Blocked TIDs by Force Success Multiple Parcel Orders and Active PETS
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived At Sorting Hub" on Edit Order page
    When Operator create new recovery ticket on Edit Order page:
      | entrySource                   | CUSTOMER COMPLAINT |
      | investigatingDepartment       | Recovery           |
      | investigatingHub              | {hub-name}         |
      | ticketType                    | PARCEL EXCEPTION   |
      | ticketSubType                 | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    Then API Operator verifies order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | status         | ON_HOLD                                    |
      | granularStatus | ON_HOLD                                    |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived At Sorting Hub" on Edit Order page
    When Operator create new recovery ticket on Edit Order page:
      | entrySource                   | CUSTOMER COMPLAINT |
      | investigatingDepartment       | Recovery           |
      | investigatingHub              | {hub-name}         |
      | ticketType                    | PARCEL EXCEPTION   |
      | ticketSubType                 | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    Then API Operator verifies order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | status         | ON_HOLD                                    |
      | granularStatus | ON_HOLD                                    |
    When Operator go to menu Order -> All Orders
    And Operator Manually Complete orders on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator verifies error messages in dialog on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} \| Order id={KEY_LIST_OF_CREATED_ORDER_ID[1]} has active PETS ticket. Please resolve PETS ticket to update status. |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} \| Order id={KEY_LIST_OF_CREATED_ORDER_ID[2]} has active PETS ticket. Please resolve PETS ticket to update status. |
    When Operator clicks 'Download the failed updates' in Update Errors dialog on All Orders page
    Then Operator verifies manually complete errors CSV file on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
