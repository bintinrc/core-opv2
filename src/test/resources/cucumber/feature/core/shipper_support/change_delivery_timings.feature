@OperatorV2 @Core @ShipperSupport @ChangeDeliveryTimings
Feature: Change Delivery Timings

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Download and Verify CSV file of Change Delivery Timings' Sample
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator click on Download Button for Sample CSV File of Change Delivery Timings' sample
    Then Operator verify CSV file of Change Delivery Timings' sample

  @happy-path
  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | startDate  | {gradle-current-date-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}   |
      | timewindow | 0                                |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) updated      |
      | bottom             | Change delivery timings |
      | waitUntilInvisible | true                    |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with NULL Timewindow Id
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | startDate  | {gradle-current-date-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}   |
      | timewindow |                                  |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) updated      |
      | bottom             | Change delivery timings |
      | waitUntilInvisible | true                    |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with Invalid Tracking ID
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | INVALID_TRACKING_ID              |
      | startDate  | {gradle-current-date-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}   |
      | timewindow | -1                               |
    Then Operator verify the tracking ID is invalid on Change Delivery Timings page

  @DeleteOrArchiveRoute
  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with Invalid Order State
    Given Operator go to menu Utilities -> QRCode Printing
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
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) updated      |
      | bottom             | Change delivery timings |
      | waitUntilInvisible | true                    |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

#Note: Seems the delivery timings can still updated event the csv not contain start date, so will let Dev know first and later will decide either deprecate this scenario or dev will fix it first
#  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with One of the Date is Empty
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Order - Shipper create multiple V4 orders using data below:
#      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
#      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
#      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{to-address}} |
#    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
#    Given Operator go to menu Shipper Support -> Change Delivery Timings
#    When Operator uploads the CSV file on Change Delivery Timings page using data below:
#      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
#      | startDate  |                                            |
#      | endDate    | {gradle-current-date-yyyy-MM-dd}           |
#      | timewindow | -1                                         |
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
#    Then Operator verify Delivery details on Edit order page using data below:
#      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
#      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

#Note: Seems wrong with the feature, somehow the startdate is 2023-06-22 and enddate is 2023-06-21
#  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with Start Date is Later than End Date
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    Given Operator go to menu Shipper Support -> Change Delivery Timings
#    When Operator uploads the CSV file on Change Delivery Timings page using data below:
#      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}  |
#      | startDate  | {gradle-next-1-day-yyyy-MM-dd}   |
#      | endDate    | {gradle-current-date-yyyy-MM-dd} |
#      | timewindow | -1                               |
#    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
#    Then Operator verify Delivery details on Edit order page using data below:
#      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
#      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

# Note: Seems the delivery timings can still updated event the csv not contain start date/end date, so will let Dev know first and later will decide either deprecate this scenario or dev will fix it first
#  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with Both Date Empty
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Order - Shipper create multiple V4 orders using data below:
#      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
#      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
#      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{to-address}} |
#    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
#    Given Operator go to menu Shipper Support -> Change Delivery Timings
#    When Operator uploads the CSV file on Change Delivery Timings page using data below:
#      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
#      | timewindow | 0                                          |
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
#    Then Operator verify Delivery details on Edit order page using data below:
#      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
#      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with Order Tagged to DP
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator tag "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order to "{dp-id}" DP
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | startDate  | {gradle-current-date-yyyy-MM-dd} |
      | endDate    | {gradle-next-1-day-yyyy-MM-dd}   |
      | timewindow | 0                                |
    Then Operator verify errors on Change Delivery Timings page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} \| Delivery is assigned to a DP! Not allowed to change delivery timings. |
    And Operator click Close button on Change Delivery Timings page

  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page with Past Date
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | startDate  | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate    | {gradle-previous-1-day-yyyy-MM-dd} |
      | timewindow | 0                                  |
    Then Operator verify errors on Change Delivery Timings page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} \| cannot change delivery date before today's date |
    And Operator click Close button on Change Delivery Timings page

  Scenario: Operator Change Delivery Timings with Partial Failed Orders
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads CSV file without submit on Change Delivery Timings page:
      | trackingId                            | startDate                        | endDate                        | timewindow |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {gradle-current-date-yyyy-MM-dd} | {gradle-next-1-day-yyyy-MM-dd} | 0          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {gradle-current-date-yyyy-MM-dd} | {gradle-next-1-day-yyyy-MM-dd} | 0          |
    And Operator waits for 2 seconds
    And API Operator delete order
    And Operator waits for 2 seconds
    And Operator submit uploaded CSV file on Change Delivery Timings page
    Then Operator verify errors on Change Delivery Timings page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} \| Invalid tracking id |
    And Operator click Close button on Change Delivery Timings page
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) updated      |
      | bottom             | Change delivery timings |
      | waitUntilInvisible | true                    |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-current-date-yyyy-MM-dd} 09:00:00 |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 22:00:00   |

  Scenario Outline: Operator Uploads the CSV File on Change Delivery Timings With Various Timeslot - <timeWindow>
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID}        |
      | startDate  | {gradle-next-1-working-day-yyyy-MM-dd} |
      | endDate    | {gradle-next-2-working-day-yyyy-MM-dd} |
      | timewindow | <timewindowId>                         |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) updated      |
      | bottom             | Change delivery timings |
      | waitUntilInvisible | true                    |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify Delivery details on Edit order page using data below:
      | startDateTime | {gradle-next-1-working-day-yyyy-MM-dd} <timeForm> |
      | endDateTime   | {gradle-next-2-working-day-yyyy-MM-dd} <timeTo>   |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE SLA |
    And Operator save the last DELIVERY transaction of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order as "KEY_TRANSACTION_AFTER"
    And DB Operator verifies waypoints record:
      | id           | {KEY_TRANSACTION_AFTER.waypointId} |
      | timewindowId | <timewindowId>                     |

    Examples:
      | timeWindow  | timewindowId | timeForm | timeTo   |
      | 9.00-12.00  | 0            | 09:00:00 | 12:00:00 |
      | 12.00-15.00 | 1            | 12:00:00 | 15:00:00 |
      | 15.00-18.00 | 2            | 15:00:00 | 18:00:00 |
      | 18.00-22.00 | 3            | 18:00:00 | 22:00:00 |
      | 09:00-22:00 | -1           | 09:00:00 | 22:00:00 |
      | 09:00-18:00 | -2           | 09:00:00 | 18:00:00 |
      | 18:00-22:00 | -3           | 18:00:00 | 22:00:00 |
