@OperatorV2 @Core @Order @AllOrders
Feature: All Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Cancel Multiple Orders on All Orders Page (uid:075f601c-dea6-4967-9eaf-f65d95ab6e7a)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator cancel multiple orders on All Orders page
    Then API Operator verify multiple orders info after Canceled

  Scenario: Operator Print Waybill for Single Order on All Orders Page and Verify the Downloaded PDF Contains Correct Info (uid:4989c98b-9a7d-4f87-8bc3-d7b3692ce279)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator print Waybill for single order on All Orders page
    Then Operator verify the printed waybill for single order on All Orders page contains correct info

#  Scenario: Operator Download CSV File of Blocked TIDs by RTS Multiple Parcel Orders and Active PETS (uid:73f80b40-746f-4083-805d-6d58c1678531)
#    Given Operator go to menu Utilities -> QRCode Printing
#    And API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
#    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
#    Then Operator verify order status is "Transit" on Edit Order page
#    And Operator verify order granular status is "Arrived At Sorting Hub" on Edit Order page
#    When Operator create new recovery ticket on Edit Order page:
#      | entrySource                   | CUSTOMER COMPLAINT |
#      | investigatingDepartment       | Recovery           |
#      | investigatingHub              | {hub-name}         |
#      | ticketType                    | PARCEL EXCEPTION   |
#      | ticketSubType                 | INACCURATE ADDRESS |
#      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
#      | custZendeskId                 | 1                  |
#      | shipperZendeskId              | 1                  |
#      | ticketNotes                   | GENERATED          |
#    Then API Operator verifies order state:
#      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
#      | status         | ON_HOLD                                    |
#      | granularStatus | ON_HOLD                                    |
#    And API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
#    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
#    Then Operator verify order status is "Transit" on Edit Order page
#    And Operator verify order granular status is "Arrived At Sorting Hub" on Edit Order page
#    When Operator create new recovery ticket on Edit Order page:
#      | entrySource                   | CUSTOMER COMPLAINT |
#      | investigatingDepartment       | Recovery           |
#      | investigatingHub              | {hub-name}         |
#      | ticketType                    | PARCEL EXCEPTION   |
#      | ticketSubType                 | INACCURATE ADDRESS |
#      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
#      | custZendeskId                 | 1                  |
#      | shipperZendeskId              | 1                  |
#      | ticketNotes                   | GENERATED          |
#    Then API Operator verifies order state:
#      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
#      | status         | ON_HOLD                                    |
#      | granularStatus | ON_HOLD                                    |
#    When Operator go to menu Order -> All Orders
#    And Operator find multiple orders by uploading CSV on All Orders page
#    And Operator select 'Set RTS to Selected' action for found orders on All Orders page
#    Then Operator verify "Return to Sender" process in Selection Error dialog on All Orders page
#    And Operator verify orders info in Selection Error dialog on All Orders page:
#      | trackingId                                 | reason                   |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Invalid status to change |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Invalid status to change |
#    When Operator clicks 'Download the invalid selection' in Selection Error dialog on All Orders page
#    Then Operator verifies invalid selection CSV file on All Orders page:
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
#
#  Scenario: Operator Download CSV File of Blocked TIDs by Force Success Multiple Parcel Orders and Active PETS (uid:de96ff5a-0888-4403-bff0-d940eb4673e4)
#    Given Operator go to menu Utilities -> QRCode Printing
#    And API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
#    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
#    Then Operator verify order status is "Transit" on Edit Order page
#    And Operator verify order granular status is "Arrived At Sorting Hub" on Edit Order page
#    When Operator create new recovery ticket on Edit Order page:
#      | entrySource                   | CUSTOMER COMPLAINT |
#      | investigatingDepartment       | Recovery           |
#      | investigatingHub              | {hub-name}         |
#      | ticketType                    | PARCEL EXCEPTION   |
#      | ticketSubType                 | INACCURATE ADDRESS |
#      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
#      | custZendeskId                 | 1                  |
#      | shipperZendeskId              | 1                  |
#      | ticketNotes                   | GENERATED          |
#    Then API Operator verifies order state:
#      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
#      | status         | ON_HOLD                                    |
#      | granularStatus | ON_HOLD                                    |
#    And API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
#    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
#    Then Operator verify order status is "Transit" on Edit Order page
#    And Operator verify order granular status is "Arrived At Sorting Hub" on Edit Order page
#    When Operator create new recovery ticket on Edit Order page:
#      | entrySource                   | CUSTOMER COMPLAINT |
#      | investigatingDepartment       | Recovery           |
#      | investigatingHub              | {hub-name}         |
#      | ticketType                    | PARCEL EXCEPTION   |
#      | ticketSubType                 | INACCURATE ADDRESS |
#      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
#      | custZendeskId                 | 1                  |
#      | shipperZendeskId              | 1                  |
#      | ticketNotes                   | GENERATED          |
#    Then API Operator verifies order state:
#      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
#      | status         | ON_HOLD                                    |
#      | granularStatus | ON_HOLD                                    |
#    When Operator go to menu Order -> All Orders
#    And Operator Manually Complete orders on All Orders page:
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
#    Then Operator verifies error messages in dialog on All Orders page:
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} \| Order id={KEY_LIST_OF_CREATED_ORDER_ID[1]} has active PETS ticket. Please resolve PETS ticket to update status. |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} \| Order id={KEY_LIST_OF_CREATED_ORDER_ID[2]} has active PETS ticket. Please resolve PETS ticket to update status. |
#    When Operator clicks 'Download the failed updates' in Update Errors dialog on All Orders page
#    Then Operator verifies manually complete errors CSV file on All Orders page:
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op