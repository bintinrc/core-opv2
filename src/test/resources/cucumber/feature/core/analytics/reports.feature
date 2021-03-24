@OperatorV2 @Core @Analytics @Reports
Feature: Order Creation V4

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Generate/Send Driver CODs for A Day Report (uid:c050d2f7-8386-4000-acbb-0e7c45d1621b)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    When Operator go to menu Analytics -> Reports
    And Operator filter COD Reports by Mode = "Get CODs For A Day" and Date = "{gradle-current-date-yyyy-MM-dd}"
    And  Operator generate COD Reports
    Then Verify the COD reports attachments are sent to the Operator email

  @DeleteOrArchiveRoute
  Scenario: Generate Order Statuses Report - Less Than 4000 Tracking Ids (uid:f0a75b33-339e-4d48-8d0c-bb4c8b19191c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver deliver all created parcels successfully
    When Operator go to menu Analytics -> Reports
    And Operator generates order statuses report for created orders on Reports page
    Then Operator verifies that success toast displayed:
      | top | Downloaded CSV |
    Then Operator verifies order statuses report file contains following data:
      | trackingId                                 | status    | size    | inboundDate | orderCreationDate                   | estimatedDeliveryDate                  | firstDeliveryAttempt                | lastDeliveryAttempt                 | deliveryAttempts | secondDeliveryAttempt | thirdDeliveryAttempt | lastUpdateScan                      | failureReason |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Completed | XXLARGE | NA          | ^{gradle-current-date-yyyy-MM-dd}.* | {gradle-next-3-working-day-yyyy-MM-dd} | ^{gradle-current-date-yyyy-MM-dd}.* | ^{gradle-current-date-yyyy-MM-dd}.* | 1                | NA                    | NA                   | ^{gradle-current-date-yyyy-MM-dd}.* | NA            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Completed | XXLARGE | NA          | ^{gradle-current-date-yyyy-MM-dd}.* | {gradle-next-3-working-day-yyyy-MM-dd} | ^{gradle-current-date-yyyy-MM-dd}.* | ^{gradle-current-date-yyyy-MM-dd}.* | 1                | NA                    | NA                   | ^{gradle-current-date-yyyy-MM-dd}.* | NA            |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op