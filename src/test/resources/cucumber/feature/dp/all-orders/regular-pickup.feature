Feature: Regular Pickup

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Regular Pickup - Success Create Reservation - Pickup Reservations isn't Exist - Download CSV - Normal Dps
    Given Operator go to menu Order -> All Orders
    #Given API Shipper create V4 order using data below:
     # | shipperClientId     | {opv2-dp-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
     # | shipperClientSecret | {opv2-dp-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
     # | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
     # | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    #Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    #When API DP get the DP Details by DP ID = "{opv2-dp-dp-id}"
    #And API Operator get order events by created order id
    #And DB Operator gets all details for ninja collect confirmed status
    #Then Operator verifies that all the details for Confirmed Status are right
    #Given API Operator get DP information by DP ID for DP with ID = "{opv2-dp-dpms-id}"
    #And API Operator create new route using data below:
     # | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    #Given API Operator add parcel to the route using data below:
     # | addParcelToRouteRequest | { "type":"DD" } |
    #And API Operator Van Inbound parcel
    #Given API Operator start the route
    #And API Driver collect all his routes
    #And API Driver get pickup/delivery waypoint of the created order
    #Given API Operator get order details
    #Given DB Operator get DP job id from Hibernate
    #Given API Driver v5 success dp drop off
    #When DB Operator gets all details for ninja collect driver drop off confirmed status
    #Then Operator verifies that all the details for ninja collect driver drop off confirmed status are right
    #And DB Operator changes the collect end date to today from Hibernate
    #And API DP fires overstay reminder
    #Given DB Operator set pickup date of DP reservation to current date from Hibernate
    #Given API Operator trigger Add Overstayed Orders
    #Given DB Operator set collect until date of DP reservation to yesterday's date from Hibernate
    #Given API Operator trigger overstay to create new reservation
    When Operator clicks Clear All Selections and Load Selection button on All Orders Page
    And Operator apply Regular pickup action