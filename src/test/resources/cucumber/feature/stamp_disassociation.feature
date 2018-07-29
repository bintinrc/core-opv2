@OperatorV2 @OperatorV2Part1 @StampDisassociation
Feature: Stamp Disassociation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should not be able to disassociate order that has no stamp ID (uid:9c006a83-8b32-425c-b423-65ca78944277)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enter Stamp ID of the created order on Stamp Disassociation page
    Then Operator verify the label says "stamp id not available" on Stamp Disassociation page
    And Operator verify order details on Stamp Disassociation page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
