@PriorityLevels
Feature: Priority Levels

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to download all Sample CSV file on Priority Levels page (uid:0f2fd3e3-cd21-4500-854d-4464fd4a1597)
    Given Operator go to menu Order -> All Orders
    And Operator go to menu New Features -> Priority Levels
    Then Operator verifies "Orders Sample CSV" is downloaded successfully and correct
    Then Operator verifies "Reservations Sample CSV" is downloaded successfully and correct

  Scenario: Operator should be able to Update via CSV (Orders) on Priority Levels page (uid:72d27657-7d71-47bf-b3a5-4cac9a1d3b33)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2      |
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu New Features -> Priority Levels
    And Operator uploads "Order CSV" using next priority levels for orders:
      | order | priorityLevel |
      | 1     | 10            |
      | 2     | 10            |
    Then Operator verifies order's priority is changed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op