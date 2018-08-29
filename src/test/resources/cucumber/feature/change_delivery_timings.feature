@OperatorV2 @OperatorV2Part1 @ChangeDeliveryTimings @Saas
Feature: Change Delivery Timings

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator download and verify CSV file of Change Delivery Timings' sample (uid:9e4e2241-3488-43ea-abd4-a22480d313dd)
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator click on Download Button for Sample CSV File of Change Delivery Timings' sample
    Then Operator verify CSV file of Change Delivery Timings' sample

  Scenario: Operator uploads the CSV file on Change Delivery Timings page (uid:4449fbd6-9fac-4d92-bbe6-41ebc2d38303)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {{tracking-id}}             |
      | startDate  | {{current-date-yyyy-MM-dd}} |
      | endDate    | {{next-1-day-yyyy-MM-dd}}   |
      | timewindow | 0                           |
    Then Operator verify that the Delivery Time Updated on Change Delivery Timings page
    Given Operator go to menu Order -> All Orders
    Then Operator verify that the Delivery Time is updated on All Orders page

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with null timewindow id (uid:07e9af4f-3762-468f-8538-8418c6f2627a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {{tracking-id}}             |
      | startDate  | {{current-date-yyyy-MM-dd}} |
      | endDate    | {{next-1-day-yyyy-MM-dd}}   |
      | timewindow |                 |
    Then Operator verify that the Delivery Time Updated on Change Delivery Timings page
    Given Operator go to menu Order -> All Orders
    Then Operator verify that the Delivery Time is updated on All Orders page

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with invalid Tracking ID (uid:79b23384-11ae-4d03-9d5b-16f35c2e4096)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | INVALID_TRACKING_ID         |
      | startDate  | {{current-date-yyyy-MM-dd}} |
      | endDate    | {{next-1-day-yyyy-MM-dd}}   |
      | timewindow | -1                          |
    Then Operator verify the tracking ID is invalid on Change Delivery Timings page

  @DeleteOrArchiveRoute
  Scenario: Operator uploads the CSV file on Change Delivery Timings page with invalid order state (uid:fbbabed4-94df-4f0b-95b4-f668836ba0fe)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {{tracking-id}}             |
      | startDate  | {{current-date-yyyy-MM-dd}} |
      | endDate    | {{next-1-day-yyyy-MM-dd}}   |
      | timewindow | 0                           |
    Then Operator verify the state order of the Tracking ID is invalid on Change Delivery Timings page

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with one of the date is empty (uid:58bd63ca-d461-47a6-a377-11dac88bbb8f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {{tracking-id}}             |
      | startDate  |                             |
      | endDate    | {{current-date-yyyy-MM-dd}} |
      | timewindow | -1                          |
    Then Operator verify the start and end date is not indicated correctly on Change Delivery Timings page

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with start date is later than end date (uid:5b96c619-4a16-4490-8a29-c3274315eb64)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {{tracking-id}}             |
      | startDate  | {{next-1-day-yyyy-MM-dd}}   |
      | endDate    | {{current-date-yyyy-MM-dd}} |
      | timewindow | -1                          |
    Then Operator verify that start date is later than end date on Change Delivery Timings page

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with both date empty (uid:7966f797-eb34-4ffc-ad44-499159cec435)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file on Change Delivery Timings page using data below:
      | trackingId | {{tracking-id}} |
      | startDate  |                 |
      | endDate    |                 |
      | timewindow | 0               |
    Then Operator verify that the Delivery Time Updated on Change Delivery Timings page
    Given Operator go to menu Order -> All Orders
    Then Operator verify that the Delivery Time is updated on All Orders page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
