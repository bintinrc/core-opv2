@StationManagement @PendingPickupJobs
Feature: Total Completion Rate

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View N+0 Pickup Rates - No Due Today Parcel
    Given Operator loads Operator portal home page
    And DB Operator update the parcel details to past date "{gradle-previous-2-day-yyyy-MM-dd} 00:00:00" for the hub "<HubId>"
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And API Operator calls pending pickup job trigger for station
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the tile:"<TileName>" is equal to "-"

    Examples:
      | HubName      | HubId      | Country | TileName         |
      | {hub-name-2} | {hub-id-2} | Vietnam | N+0 Pickup Rates |

  @ForceSuccessOrder @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View N+0 Pickup Rates - Pending Due Today Parcel
    Given Operator loads Operator portal home page
    And DB Operator update the parcel details to past date "{gradle-previous-2-day-yyyy-MM-dd} 00:00:00" for the hub "<HubId>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "AUTO-STATION-FROM","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "19 - 23 Lam Son Square, District 1, Ho Chi Minh City","address2": "","country": "VN","postcode": "1440","latitude": 21.01028637,"longitude": 105.81}},"to": {"name": "AUTO-STATION-TO","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1": "19 - 23 Lam Son Square, District 1, Ho Chi Minh City","address2": "","country": "VN","postcode": "1440","latitude": 21.01028637,"longitude": 105.81}},"parcel_job":{"cash_on_delivery": 40000,"insured_value": 85000, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And API Operator calls pending pickup job trigger for station
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the tile:"<TileName>" is equal to "0"

    Examples:
      | HubName      | HubId      | Country | TileName         |
      | {hub-name-2} | {hub-id-2} | Vietnam | N+0 Pickup Rates |

  @ForceSuccessOrder @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View N+0 Pickup Rates - Success Due Today Parcel
    Given Operator loads Operator portal home page
    And DB Operator update the parcel details to past date "{gradle-previous-2-day-yyyy-MM-dd} 00:00:00" for the hub "<HubId>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "AUTO-STATION-FROM","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "19 - 23 Lam Son Square, District 1, Ho Chi Minh City","address2": "","country": "VN","postcode": "1440","latitude": 21.01028637,"longitude": 105.81}},"to": {"name": "AUTO-STATION-TO","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1": "19 - 23 Lam Son Square, District 1, Ho Chi Minh City","address2": "","country": "VN","postcode": "1440","latitude": 21.01028637,"longitude": 105.81}},"parcel_job":{"cash_on_delivery": 40000,"insured_value": 85000, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And API Operator calls pending pickup job trigger for station
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the tile:"<TileName>" is equal to "100"

    Examples:
      | HubName      | HubId      | Country | TileName         |
      | {hub-name-2} | {hub-id-2} | Vietnam | N+0 Pickup Rates |

  @ForceSuccessOrder @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View N+0 Pickup Rates - Success Due Today No Job Parcel
    Given Operator loads Operator portal home page
    And DB Operator update the parcel details to past date "{gradle-previous-2-day-yyyy-MM-dd} 00:00:00" for the hub "<HubId>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "AUTO-STATION-FROM","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "19 - 23 Lam Son Square, District 1, Ho Chi Minh City","address2": "","country": "VN","postcode": "1440","latitude": 21.01028637,"longitude": 105.81}},"to": {"name": "AUTO-STATION-TO","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1": "19 - 23 Lam Son Square, District 1, Ho Chi Minh City","address2": "","country": "VN","postcode": "1440","latitude": 21.01028637,"longitude": 105.81}},"parcel_job":{"cash_on_delivery": 40000,"insured_value": 85000, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {shipper-v4-legacy-id}           |
      | status      | ROUTED                           |
    And Operator fails reservation with failure Reason for the ReservationID "{KEY_LIST_OF_CREATED_RESERVATION_IDS[1]}"
      | Failure Reason | No parcels to pick up at all - ODP |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Operator calls the list route endpoint "{KEY_CREATED_ROUTE_ID}"
    And API Driver collect all his routes
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver get Reservation Job using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
    And API Driver success Reservation using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} |
      | routeId       | {KEY_CREATED_ROUTE_ID}                   |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]}        |
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And API Operator calls pending pickup job trigger for station
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the tile:"<TileName>" is equal to "100"

    Examples:
      | HubName      | HubId      | Country | TileName         |
      | {hub-name-2} | {hub-id-2} | Vietnam | N+0 Pickup Rates |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op