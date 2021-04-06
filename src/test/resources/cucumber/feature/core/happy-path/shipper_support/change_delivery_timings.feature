@OperatorV2 @Core @ShipperSupport @ChangeDeliveryTimings @happy-path
Feature: Change Delivery Timings

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page (uid:a0f33e34-b37b-4a8e-b18f-6c52155c3bdb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | startDate  | {gradle-current-date-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}   |
      | timewindow | 0                                |
    Given Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    And Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op