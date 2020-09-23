@OperatorV2Deprecated @NonInboundedOrders
Feature: Non Inbounded Orders

  #DEPRECATED

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator find Pending Pickup order on page Non Inbounded Orders (uid:d2641c13-63bd-42d9-bb48-07f447aeda5d)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Non Inbounded Orders
    When Operator select filter and click Load Selection on Non Inbounded Orders page using data below:
      | routeDate   | {{current-date-yyyy-MM-dd}} |
      | shipperName | {shipper-v4-name}           |
    Then Operator verify following parameters of the created order on Non Inbounded Orders page:
      | granularStatus | Pending Pickup |

  Scenario: Operator should not find Global Inbounded order on page Non Inbounded Orders (uid:d5b6160c-1642-4063-aed0-b8571a90572b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu New Features -> Non Inbounded Orders
    When Operator select filter and click Load Selection on Non Inbounded Orders page using data below:
      | routeDate   | {{current-date-yyyy-MM-dd}} |
      | shipperName | {shipper-v4-name}           |
    Then Operator verify the created order is NOT found on Non Inbounded Orders page

  Scenario: Operator should be able to Cancel multiple selected orders on page Non Inbounded Orders (uid:552f1bc5-11e3-4ce2-aff0-660aee093524)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Non Inbounded Orders
    When Operator select filter and click Load Selection on Non Inbounded Orders page using data below:
      | routeDate   | {{current-date-yyyy-MM-dd}} |
      | shipperName | {shipper-v4-name}           |
    When Operator cancel created orders Non Inbounded Orders page
    Then Operator verify created orders are NOT found on Non Inbounded Orders page

  Scenario: Operator should be able to Download CSV of multiple selected orders on page Non Inbounded Orders (uid:691e7438-cd0b-42e3-ab75-9dea2b80c1d0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Non Inbounded Orders
    When Operator select filter and click Load Selection on Non Inbounded Orders page using data below:
      | routeDate   | {{current-date-yyyy-MM-dd}} |
      | shipperName | {shipper-v4-name}           |
    When Operator download CSV file for created orders on Non Inbounded Orders page
    Then Operator verify the CSV of selected Non Inbounded Orders is downloaded successfully and contains correct info

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op