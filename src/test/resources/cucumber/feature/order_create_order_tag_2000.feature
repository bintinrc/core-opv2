@OperatorV2 @OperatorV2Part1 @Anand
Feature: Global Inbound

 @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
   Scenario: Multiple order create with parcel tag
   Given API Shipper create multiple V4 orders using data below and then tags parcel to urgent:

     | numberOfOrder     | 3      |
     | generateFromAndTo | RANDOM |
     | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op