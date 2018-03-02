@OperatorV2 @ShipperPickups
Feature: Shipper Pickups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator find Normal Reservation created by Auto-Reservation on Shipper Pickups page (uid:97e650a6-f7f9-4a49-8a6f-216cf5f80f51)
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator enable auto reservation for Shipper with ID = "{shipper-v2-id}" and change shipper default address to the new address
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    Given API Operator disable auto reservation for Shipper with ID = "{shipper-v2-id}"
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName | {shipper-v2-name}          |
      | comments    | Generated by order create. |

  Scenario: Operator find Normal Reservation on Shipper Pickups page (uid:877efac2-803a-4c50-a1d4-5e9792ff5490)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id} |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v2-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |

    @ArchiveRouteViaDb
    Scenario: Operator add Reservation to Route using API and verify the Reservation info is correct (uid:b8b62011-882f-451b-9331-6cec2077aab2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id} |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v2-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |
      | routeId      | GET_FROM_CREATED_ROUTE       |
      | driverName   | {ninja-driver-name}          |

    @ArchiveRouteViaDb
    Scenario: Operator assign Reservation to Route on Shipper Pickups page (uid:992f1485-ef00-45cc-88d8-df36a3e4e77d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id} |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    When Operator refresh routes on Shipper Pickups page
    When Operator assign Reservation to Route on Shipper Pickups page
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName  | {shipper-v2-name}            |
      | approxVolume | Less than 10 Parcels         |
      | comments     | GET_FROM_CREATED_RESERVATION |
      | routeId      | GET_FROM_CREATED_ROUTE       |
      | driverName   | {ninja-driver-name}          |

  @ArchiveRouteViaDb
  Scenario: Operator assign Reservation to Route with priority level on Shipper Pickups page (uid:4e1e8b2b-ddad-48c4-98ea-b1f5a5ef448c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id} |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    When Operator refresh routes on Shipper Pickups page
    When Operator assign Reservation to Route with priority level = "3" on Shipper Pickups page
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName   | {shipper-v2-name}            |
      | approxVolume  | Less than 10 Parcels         |
      | comments      | GET_FROM_CREATED_RESERVATION |
      | routeId       | GET_FROM_CREATED_ROUTE       |
      | driverName    | {ninja-driver-name}          |
      | priorityLevel | 3                            |

  Scenario: Operator create and verify the reservations details is correct on Shipper Pickups page (uid:acc59c88-9da5-4990-9a48-26c23ba7e464)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id} |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    Then Operator verify the reservations details is correct on Shipper Pickups page using data below:
      | shipperName   | {shipper-v2-name}            |
      | shipperId     | {shipper-v2-id}              |
      | reservationId | GET_FROM_CREATED_RESERVATION |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
