@Deprecated
Feature: Edit Order

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Update Order Status from Transit/Arrived at Sorting Hub to Pending/Pending on Edit Order Page (uid:b3a052cf-9dbf-4cff-b4ec-8d944516cc2e)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update status of the created order on Edit order page using data below:
      | status                        | Pending        |
      | granularStatus                | Pending Pickup |
      | lastPickupTransactionStatus   | Pending        |
      | lastDeliveryTransactionStatus | Pending        |
    Then Operator verify the created order info is correct on Edit Order page

  Scenario: Operator Update Order Status from Pending/Pending to Cancelled/Cancelled on Edit Order Page (uid:3e788d22-fce5-4cf3-b22d-3985db12cfd3)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update status of the created order on Edit order page using data below:
      | status                        | Cancelled |
      | granularStatus                | Cancelled |
      | lastPickupTransactionStatus   | Cancelled |
      | lastDeliveryTransactionStatus | Cancelled |
    Then Operator verify the created order info is correct on Edit Order page
    And Operator verify color of order header on Edit Order page is "RED"

  Scenario: Operator Update Order Status from Pending/Pending to Transit/Arrived at Sorting Hub on Edit Order Page (uid:1f72e16b-afdb-4911-a2d1-4b4c5783f062)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update status of the created order on Edit order page using data below:
      | status                        | Transit                |
      | granularStatus                | Arrived at Sorting Hub |
      | lastPickupTransactionStatus   | Success                |
      | lastDeliveryTransactionStatus | Pending                |
    Then Operator verify the created order info is correct on Edit Order page

  Scenario: Operator Update Order Status from Pending/Pending to Completed/Completed on Edit Order Page (uid:8f40d738-057c-4f14-a301-ed884bd6a91f)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update status of the created order on Edit order page using data below:
      | status                        | Completed |
      | granularStatus                | Completed |
      | lastPickupTransactionStatus   | Success   |
      | lastDeliveryTransactionStatus | Success   |
    Then Operator verify the created order info is correct on Edit Order page
    And Operator verify color of order header on Edit Order page is "GREEN"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
