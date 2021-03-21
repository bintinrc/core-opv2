@OperatorV2 @Core @NewFeatures @StampDisassociation
Feature: Stamp Disassociation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Should not be Able to Disassociate Order that Has no Stamp ID (uid:c2577ba7-edfb-4f9f-9260-a6751789398b)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enter Stamp ID of the created order on Stamp Disassociation page
    Then Operator verify the label says "stamp id not available" on Stamp Disassociation page
    Then Operator verify order details on Stamp Disassociation page

  Scenario: Stamp Disassociation of Order by Stamp Id - Invalid Stamp Id (uid:c1598789-691b-40bf-8299-a485da6bee67)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enter Invalid Stamp ID on Stamp Disassociation page
    Then Operator will get the Not Found alert

  Scenario: Stamp Disassociation of Order by Stamp Id - Valid Stamp Id (uid:e30458b3-d636-4732-b54d-061371e04073)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    When Operator change Stamp ID of the created order to "GENERATED" on Edit order page
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enter Stamp ID of the created order on Stamp Disassociation page
    Then Operator verify order details on Stamp Disassociation page
    When Operator click on the Disassociate Stamp button
    When Operator go to menu Order -> All Orders
    Then Operator can't find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_STAMP_ID                  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op