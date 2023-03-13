@NinjaChat
Feature: OPv2 - Messaging module Scenarios

  @ChangeEprUserIdForCustomer @ForceSuccessOrder @LaunchBrowser @ui
  Scenario: Messaging Module - Show Message History
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator go to menu Mass Communications -> Messaging Module
    And Search for created order using "{KEY_CREATED_ORDER_TRACKING_ID}"
    Then Operator Verify data is shown in history table for "{KEY_CREATED_ORDER_TRACKING_ID}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op