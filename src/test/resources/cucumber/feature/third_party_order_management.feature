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
