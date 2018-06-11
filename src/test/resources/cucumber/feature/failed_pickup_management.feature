@OperatorV2 @FailedPickupManagement @Inbound
Feature: Failed Pickup Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteViaDb
  Scenario Outline: Operator find failed pickup C2C/Return order on Failed Pickup orders list (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    And Operator refresh page
    When Operator go to menu Shipper Support -> Failed Pickup Management
    Then Operator verify the failed pickup C2C/Return order is listed on Failed Pickup orders list
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | C2C    | uid:8e27fdff-334b-4fc3-b0b6-a2826ba284c0 | C2C       |
      | Return | uid:fa0d5e83-ac12-4629-a416-c76577f683b3 | Return    |

  @ArchiveRouteViaDb
  Scenario Outline: Operator download and verify CSV file of failed pickup C2C/Return order on Failed Pickup orders list (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    And Operator refresh page
    When Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator download CSV file of failed pickup C2C/Return order on Failed Pickup orders list
    Then Operator verify CSV file of failed pickup C2C/Return order on Failed Pickup orders list downloaded successfully
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | C2C    | uid:821b30e9-26a2-4e52-a6fd-d5f426599751 | C2C       |
      | Return | uid:047a8650-493c-4da3-a80e-f3efa0b08cd5 | Return    |

  @ArchiveRouteViaDb
  Scenario Outline: Operator reschedule failed pickup C2C/Return order on next day (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    And Operator refresh page
    When Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator reschedule failed pickup C2C/Return order on next day
    Then Operator verify failed pickup C2C/Return order rescheduled on next day successfully
    And API Operator verify order info after failed pickup C2C/Return order rescheduled on next day
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | C2C    | uid:815e700a-68f7-4b89-a9a0-ffbd8c5cbcdb | C2C       |
      | Return | uid:5d699f49-f393-402b-92f9-8b676ebce0fb | Return    |

  @ArchiveRouteViaDb
  Scenario Outline: Operator reschedule failed pickup C2C/Return order on specific date (<hiptest-uid>)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    And Operator refresh page
    When Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator reschedule failed pickup C2C/Return order on next 2 days
    Then Operator verify failed pickup C2C/Return order rescheduled on next 2 days successfully
    And API Operator verify order info after failed pickup C2C/Return order rescheduled on next 2 days
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | C2C    | uid:bec16db3-4ee0-4334-8a2f-d090a4f681cd | C2C       |
      | Return | uid:97126afe-c6ab-4aff-9dca-fc19ba021727 | Return    |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
