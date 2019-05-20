@OrderLevelTagManagement
Feature:  Order Level Tag Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to search multiple order with filters and tag them with ABC
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> Order Level Tag Management
    When Operator selects filter and clicks Load Selection on Order Level Tag Management page using data below:
      | shipperName     | {shipper-v4-legacy-id}-{shipper-v4-name} |
      | status          | Pending                                  |
      | granular status | Pending Pickup                           |
    And Operator searches and selects orders created
    And Operator tags order with "ABC"
    Then Operator verifies orders are tagged on Edit order page

  Scenario: Operator should be able to find multiple orders with CSV and tag them with ABC
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> Order Level Tag Management
    And Operator uploads CSV with orders created
    And Operator selects orders created
    And Operator tags order with "ABC"
    Then Operator verifies orders are tagged on Edit order page

  Scenario: Operator verify the failed delivery order that already tagged is show correct tag on Failed Delivery Management page
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 1                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> Order Level Tag Management
    When Operator selects filter and clicks Load Selection on Order Level Tag Management page using data below:
      | shipperName     | {shipper-v4-legacy-id}-{shipper-v4-name} |
      | status          | Pending                                  |
      | granular status | Pending Pickup                           |
    And Operator selects orders created
    And Operator tags order with "ABC"
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
      #java.lang.ExceptionInInitializerError
      #	at co.nvqa.commons.cucumber.glue.StandardApiDriverSteps.apiDriverFailedTheDeliveryOfTheParcel(StandardApiDriverSteps.java:318)
      #	at co.nvqa.commons.cucumber.glue.StandardApiDriverSteps.apiDriverFailedTheDeliveryOfTheCreatedParcel(StandardApiDriverSteps.java:297)
      #	at ✽.API Driver failed the delivery of the created parcel(file:order_level_tag_management.feature:48)
      #Caused by: co.nvqa.commons.util.NvTestRuntimeException: com.mysql.cj.jdbc.exceptions.CommunicationsException: Communications link failure
      #
      #The last packet sent successfully to the server was 0 milliseconds ago. The driver has not received any packets from the server.
    Then Operator verifies the failed delivery order is listed and tagged on Failed Delivery orders list

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
