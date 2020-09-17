@OperatorV2 @ShipperSupport @OperatorV2Part2 @FailedPickupManagement @Saas @Inbound
Feature: Failed Pickup Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario Outline: Operator find failed pickup C2C/Return order on Failed Pickup orders list (<hiptest-uid>)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    When Operator go to menu Shipper Support -> Failed Pickup Management
    Then Operator verify the failed pickup C2C/Return order is listed on Failed Pickup orders list
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Return | uid:fa0d5e83-ac12-4629-a416-c76577f683b3 | Return    |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator download and verify CSV file of failed pickup C2C/Return order on Failed Pickup orders list (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    When Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator download CSV file of failed pickup C2C/Return order on Failed Pickup orders list
    Then Operator verify CSV file of failed pickup C2C/Return order on Failed Pickup orders list downloaded successfully
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Return | uid:047a8650-493c-4da3-a80e-f3efa0b08cd5 | Return    |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator reschedule failed pickup C2C/Return order on next day (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    When Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator reschedule failed pickup C2C/Return order on next day
    Then Operator verify failed pickup C2C/Return order rescheduled on next day successfully
    And API Operator verify order info after failed pickup C2C/Return order rescheduled on next day
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Return | uid:5d699f49-f393-402b-92f9-8b676ebce0fb | Return    |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator reschedule failed pickup C2C/Return order on specific date (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    When Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator reschedule failed pickup C2C/Return order on next 2 days
    Then Operator verify failed pickup C2C/Return order rescheduled on next 2 days successfully
    And API Operator verify order info after failed pickup C2C/Return order rescheduled on next 2 days
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Return | uid:97126afe-c6ab-4aff-9dca-fc19ba021727 | Return    |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator should be able to cancel failed pickup of C2C/Return order (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    When Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator cancel order on Failed Pickup Management page
    Then API Operator verify failed pickup order info after Canceled
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Return | uid:7b390a2f-975f-483b-97e4-3b9c6e2572f7 | Return    |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator should be able to cancel multiple failed pickup of C2C/Return orders (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Driver failed multiple C2C/Return orders pickup
    When Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator cancel multiple orders on Failed Pickup Management page
    Then API Operator verify multiple failed pickup orders info after Canceled
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Return | uid:72f6a742-59f2-4761-bdda-91699975de5b | Return    |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator reschedule multiple failed pickup of C2C/Return orders on specific date (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Driver failed multiple C2C/Return orders pickup
    When Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator reschedule multiple failed pickup C2C/Return orders on next 2 days
    Then Operator verify multiple failed pickup C2C/Return orders rescheduled on next 2 days successfully
    And API Operator verify multiple orders info after failed pickup C2C/Return order rescheduled on next 2 days
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Return | uid:721b3db0-da4c-482a-a9cb-cb8b6087147a | Return    |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
