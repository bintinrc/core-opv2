@OperatorV2 @Core @CrossBorderAnd3PL @ThirdPartyOrderManagement @happy-path
Feature: Third Party Order Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Upload Bulk Third Party Orders Successfully (uid:bf633cb4-8610-43f6-b023-83599e0ee1c2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Cross Border & 3PL -> Third Party Order Management
    And Operator uploads bulk mapping
    Then Operator verify multiple new mapping is created successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op