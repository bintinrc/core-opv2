@OperatorV2 @NewFeatures @OperatorV2Part1 @StampDisassociation
Feature: Stamp Disassociation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should not be able to disassociate order that has no stamp ID (uid:9c006a83-8b32-425c-b423-65ca78944277)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enter Stamp ID of the created order on Stamp Disassociation page
    Then Operator verify the label says "stamp id not available" on Stamp Disassociation page
    Then Operator verify order details on Stamp Disassociation page

  Scenario: Stamp Disassociation On Order V2 - tracking id or stamp id is wrong (uid:93b33221-9162-4a89-ab8f-34fb62cba0dc)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enter Invalid Stamp ID on Stamp Disassociation page
    Then Operator will get the Not Found alert

  Scenario: Stamp Disassociation On Order V2 - tracking id or stamp id correct (uid:10cd3d05-6cca-4f8b-b7a6-cbb3bc07a2ae)
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
