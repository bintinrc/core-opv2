@OperatorV2
Feature: Parcel Tag

  #LOOKS LIKE SOME ANAND'S PRACTICES. NEED TO BE REMOVED

 @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
   Scenario: Multiple order create with parcel tag
   Given API Shipper create multiple V4 orders using data below:
     | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
     | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
     | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |

   Then API Shipper tags multiple parcels as per the below tag
     | OrderTag          | 5499   |
   Then API Shipper checks that order has been successfully tagged


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op