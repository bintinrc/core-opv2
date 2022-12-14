@OperatorV2 @Core @Analytics @CodReport
Feature: COD Report

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator is Able to Load CODs For A Day and Verify the Created Order is Exist and Contains Correct Info (uid:1319d4d2-56bf-404d-a239-6557181f6935)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get CODs For A Day" and Date = "{gradle-current-date-yyyy-MM-dd}"
    Then Operator verify COD record on COD Report page:
      | trackingId     | {KEY_CREATED_ORDER_TRACKING_ID} |
      | granularStatus | Pending Pickup                  |
      | shipperName    | {shipper-v4-name}               |
      | codAmount      | 23.57                           |
      | collectedAt    | Delivery                        |
      | shippingAmount | 0.00                            |
      | collectedSum   | 0.00                            |
      | collected      | 0.00                            |

  @DeleteOrArchiveRoute
  Scenario: Operator is Able to Load Driver CODs For A Route Day and Verify the Created Order is Exist and Contains Correct Info (uid:8832530d-310b-45d2-bcc9-b5f1b303687d)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-0-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-0-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get Driver CODs For A Route Day" and Date = "{gradle-next-1-day-yyyy-MM-dd}"
    Then Operator verify COD record on COD Report page:
      | trackingId     | {KEY_CREATED_ORDER_TRACKING_ID} |
      | granularStatus | Arrived at Sorting Hub          |
      | shipperName    | {shipper-v4-name}               |
      | codAmount      | 23.57                           |
      | collectedAt    | Delivery                        |
      | shippingAmount | 0.00                            |
      | collectedSum   | 0.00                            |
      | collected      | 0.00                            |

  Scenario: Operator is Able to Download CODs For A Day and Verify the Data is Correct (uid:1f366b13-8cc7-4d61-8165-5ccffe29619e)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get CODs For A Day" and Date = "{gradle-current-date-yyyy-MM-dd}"
    When Operator download COD Report
    When API Operator get order details
    Then Operator verify the downloaded COD Report data is correct

  @DeleteOrArchiveRoute
  Scenario: Operator is Able to Download Driver CODs For A Route Day and Verify the Data is Correct (uid:8cdfc308-3e30-4c08-8ae4-ecef64339b71)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-0-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-0-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get Driver CODs For A Route Day" and Date = "{gradle-next-1-day-yyyy-MM-dd}"
    When Operator download COD Report
    When API Operator get order details
    Then Operator verify the downloaded COD Report data is correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op