@MileZero @VnOnly @LoyaltyVn
Feature: Loyalty

  @DeleteOrArchiveRoute
  Scenario: Loyalty - normal shipper - point accumulation - vn (uid:9464b6c3-f8b1-4397-83b7-6149ced77b78)
    Given API Ninja Dash init with username = "{shipper-loyalty-postpaid-username}" and password = "{shipper-loyalty-postpaid-password}"
    Given API Ninja Dash create new order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |

    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"

    When Loyalty DB gets loyalty point for created order
    Then DB Operator verify loyalty point for completed order is "1.0"

  @DeleteOrArchiveRoute
  Scenario: Loyalty - marketplace shipper - point accumulation - vn (uid:67c23ab3-a271-4757-93d3-ee891090aa6e)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {marketplace-loyalty-postpaid-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {marketplace-loyalty-postpaid-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |

    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"

    When Loyalty DB gets loyalty point for created order
    Then DB Operator verify loyalty point for completed order is "1.0"