@OperatorV2 @ShipperPickups
Feature: Shipper Pickups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator find Normal Reservation created by Auto-Reservation on Shipper Pickups page (uid:97e650a6-f7f9-4a49-8a6f-216cf5f80f51)
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator enable auto reservation for Shipper with ID = "{shipper-v2-id}" and change shipper default address to the new address
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
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
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
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
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
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
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
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
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
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
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    Then Operator verify the reservations details is correct on Shipper Pickups page using data below:
      | shipperName   | {shipper-v2-name}            |
      | shipperId     | {shipper-v2-id}              |
      | reservationId | GET_FROM_CREATED_RESERVATION |

  Scenario: Operator should be able to create/duplicate single reservation on Shipper Pickups page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    And Operator duplicates created reservation
    Then Operator verify the duplicated reservation is created successfully

  Scenario: Operator should be able to create/duplicate multiple reservations on Shipper Pickups page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple shipper addresses using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v2-id} |
      | generateAddress   | RANDOM          |
    Given API Operator create multiple reservations using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    And Operator duplicates created reservations
    Then Operator verify the duplicated reservations are created successfully

  @ArchiveRouteViaDb
  Scenario: Operator should be able to use the Route Suggestion and add single reservation to the route on Shipper Pickups page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [250]
    Given API Operator retrieve routes using data below:
      | tagIds | 250 |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    And Operator use the Route Suggestion to add created reservation to the route
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName | {shipper-v2-name}        |
      | routeId     | GET_FROM_SUGGESTED_ROUTE |
      | driverName  | GET_FROM_SUGGESTED_ROUTE |

  @ArchiveRouteViaDb
  Scenario: Operator should be able to use the Route Suggestion and add multiple reservations to the route on Shipper Pickups page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple shipper addresses using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v2-id} |
      | generateAddress   | RANDOM          |
    Given API Operator create multiple reservations using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [250]
    Given API Operator retrieve routes using data below:
      | tagIds | 250 |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    And Operator use the Route Suggestion to add created reservations to the route
    Then Operator verify the new reservations are listed on table in Shipper Pickups page using data below:
      | shipperName | {shipper-v2-name}        |
      | routeId     | GET_FROM_SUGGESTED_ROUTE |
      | driverName  | GET_FROM_SUGGESTED_ROUTE |

  @ArchiveRouteViaDb
  Scenario: Operator should be able to remove the route from single reservation on Shipper Pickups page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    And Operator removes the route from the created reservation
    Then Operator verify the route was removed from the created reservation

  @ArchiveRouteViaDb
  Scenario: Operator should be able to remove the route from multiple reservations on Shipper Pickups page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple shipper addresses using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v2-id} |
      | generateAddress   | RANDOM          |
    Given API Operator create multiple reservations using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-ups to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    And Operator removes the route from the created reservations
    Then Operator verify the route was removed from the created reservations

  @ArchiveRouteViaDb
  Scenario Outline: Operator should be able to filter the Shipper Pickups by parameters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":<zoneId>, "hubId":<hubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add reservation pick-up to the route
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate | TODAY      |
      | toDate   | TOMORROW   |
      | hub      | <hubName>  |
      | zone     | <zoneName> |
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | shipperName | {shipper-v2-name}      |
      | routeId     | GET_FROM_CREATED_ROUTE |
      | driverName  | {ninja-driver-name}    |
    Examples:
      | hubId    | hubName | zoneId    | zoneName        |
      | 2        | DOJO    | {zone-id} |                 |
      | {hub-id} |         | 2         | 2-ZZZ-All Zones |

  Scenario: Operator should be able to download CSV file on Shipper Pickups page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    And Operator download CSV file for created reservation
    Then Operator verify the reservation info is correct in downloaded CSV file

  Scenario: Operator should be able to edit the Priority Level of single reservation on Shipper Pickups page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given API Operator create reservation using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    And Operator set the Priority Level of the created reservation to "2" from Apply Action
    Then Operator verify the new reservation is listed on table in Shipper Pickups page using data below:
      | priorityLevel | 2 |

  Scenario: Operator should be able to edit the Priority Level of multiple reservation on Shipper Pickups page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple shipper addresses using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v2-id} |
      | generateAddress   | RANDOM          |
    Given API Operator create multiple reservations using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    And Operator set the Priority Level of the created reservations to "2" from Apply Action
    Then Operator verify the new reservations are listed on table in Shipper Pickups page using data below:
      | priorityLevel | 2 |

  Scenario: Operator should be able to edit the Priority Level of multiple reservation on Shipper Pickups page using "Set To All" option
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple shipper addresses using data below:
      | numberOfAddresses | 2               |
      | shipperId         | {shipper-v2-id} |
      | generateAddress   | RANDOM          |
    Given API Operator create multiple reservations using data below:
      | shipperId   | {shipper-v2-id}                                                                                                                                    |
      | reservation | [ { "timewindowId":2, "readyDatetime":"{{cur_date}} 07:00:00", "latestDatetime":"{{cur_date}} 10:00:00", "approxVolume":"Less than 10 Parcels" } ] |
    Given Operator go to menu Pick Ups -> Shipper Pickups
    When Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page
    And Operator set the Priority Level of the created reservations to "2" from Apply Action using "Set To All" option
    Then Operator verify the new reservations are listed on table in Shipper Pickups page using data below:
      | priorityLevel | 2 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
