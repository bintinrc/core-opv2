@OrderLevelTagManagement
Feature:  Order Level Tag Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to search multiple order with filters and tag them with ABC
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> Order Level Tag Management
    And Operator filters by Shipper = "20106-opv2_sg_shipper_v4"
    And Operator filters by Status = "Pending"
    And Operator filters by Granular Status = "Pending Pickup"
    And Operator clicks "Load Selection" button
    And Operator selects orders created
    And Operator tags order with "ABC"
    Then Operator verifies orders are tagged on Edit order page