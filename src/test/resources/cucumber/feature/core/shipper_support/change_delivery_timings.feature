@OperatorV2 @Core @ShipperSupport @ChangeDeliveryTimings
Feature: Change Delivery Timings

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Download and Verify CSV file of Change Delivery Timings' Sample (uid:d62b8c4f-43a0-44c9-a880-48e9cbecd14c)
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator click on Download Button for Sample CSV File of Change Delivery Timings' sample
    Then Operator verify CSV file of Change Delivery Timings' sample

  @CloseNewWindows
  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page (uid:c45d09b1-9082-4e8d-86f6-1fee6987ea15)
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

  @CloseNewWindows
  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with NULL Timewindow Id (uid:8f87e215-1680-44d6-86c0-2b517ca85ad3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | startDate  | {gradle-current-date-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}   |
      | timewindow |                                  |
    Given Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    And Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with Invalid Tracking ID (uid:82ca200a-d5d3-45da-adf6-b9a63d9545ea)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | INVALID_TRACKING_ID              |
      | startDate  | {gradle-current-date-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}   |
      | timewindow | -1                               |
    Then Operator verify the tracking ID is invalid on Change Delivery Timings page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with Invalid Order State (uid:66c7644b-64e7-4c60-963c-1ef5a837cd8e)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And Operator go to menu Shipper Support -> Change Delivery Timings
    And Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | startDate  | {gradle-current-date-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}   |
      | timewindow | 0                                |
    And Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

  @CloseNewWindows
  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with One of the Date is Empty (uid:16505a85-abcd-4121-a5e5-598e1d9cd2d9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | startDate  |                                  |
      | endDate    | {gradle-current-date-yyyy-MM-dd} |
      | timewindow | -1                               |
    And Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

  @CloseNewWindows
  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with Start Date is Later than End Date (uid:7b563c16-28f8-48a7-ac6e-5967d0042c3f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | startDate  | {gradle-next-1-day-yyyy-MM-dd}   |
      | endDate    | {gradle-current-date-yyyy-MM-dd} |
      | timewindow | -1                               |
    And Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

  @CloseNewWindows
  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with Both Date Empty (uid:bf8bfde6-f452-4bf8-ab4d-c5bb299ce9c4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | timewindow | 0                               |
    Given Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    Then Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op