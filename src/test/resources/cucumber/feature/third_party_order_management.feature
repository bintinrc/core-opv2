@OperatorV2 @OperatorV2Part1 @ThirdPartyOrderManagement
Feature: Third Party Order Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator upload Single, edit and delete new Mapping on page Third Party Order Management (uid:29da63e4-d636-4c76-ae28-df53a3a7ff5c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
    Then Operator verify the new mapping is created successfully
    When Operator edit the new mapping with a new data
    Then Operator verify the new edited data is updated successfully
    When Operator delete the new mapping
    Then Operator verify the new mapping is deleted successfully

  Scenario: Operator upload bulk new Mapping on page Third Party Order Management (uid:a61fc8df-f3e3-4f5b-a1f5-56aa33bad394)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2      |
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads bulk mapping
    Then Operator verify multiple new mapping is created successfully

  Scenario: Return To Sender (RTS) Third Party Order - through OPv2, single RTS (uid:c211afdc-dea7-49c9-bd30-ba3645295321)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
    Then Operator verify the new mapping is created successfully
    When API Operator get order details
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator RTS single order on next day on All Orders page
    Then API Operator Verify 3pl Order Info After Rts-ed on next day

  Scenario: Return To Sender (RTS) Third Party Order - through OPv2, bulk RTS (uid:fbd7e87d-a57d-42ed-b747-2c0c6319fcb7)
      Given API Shipper create multiple V4 orders using data below:
        | numberOfOrder     | 2      |
        | generateFromAndTo | RANDOM |
        | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
      Given Operator go to menu Shipper Support -> Blocked Dates
      Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
      When Operator uploads bulk mapping
      When Operator go to menu Order -> All Orders
      When Operator find multiple orders by uploading CSV on All Orders page
      When Operator RTS multiple orders on next day on All Orders page
      Then API Operator verify multiple orders info after 3pl parcels RTS-ed on next day

#  # Note: Rizaq said they removed the Complete Order feature because the flow is changed.
#  Scenario: Operator upload Single new Mapping and complete the order on page Third Party Order Management (uid:f56de670-3197-4efe-8e39-e8cfb066794d)
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
#    When Operator uploads new mapping
#    Then Operator verify the new mapping is created successfully
#    When Operator complete the new mapping order
#    Then Operator verify the new mapping order is completed

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
