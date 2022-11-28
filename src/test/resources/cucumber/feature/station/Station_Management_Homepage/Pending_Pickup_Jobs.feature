@StationManagement @PendingPickupJobs
Feature: Total Completion Rate

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @TimeBased @SystemIdNotSg @default-vn
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

  @ForceSuccessOrder @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: View N+0 Pickup Rates - Pending Due Today Parcel
    Given Operator loads Operator portal home page
    And DB Operator update the parcel details to past date "{gradle-previous-2-day-yyyy-MM-dd} 00:00:00" for the hub "<HubId>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"testaddress23","address2":"","country":"VN","postcode":"018981","latitude":"5.55555","longitude":"5.55555"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"testaddress23","address2":"","country":"VN","postcode":"018981","latitude":"5.55555","longitude":"5.55555"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And API Operator calls pending pickup job trigger for station
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the tile:"<TileName>" is equal to "0"

    Examples:
      | HubName      | HubId      | Country | TileName         |
      | {hub-name-2} | {hub-id-2} | Vietnam | N+0 Pickup Rates |

  @ForceSuccessOrder @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: View N+0 Pickup Rates - Success Due Today Parcel
    Given Operator loads Operator portal home page
    And DB Operator update the parcel details to past date "{gradle-previous-2-day-yyyy-MM-dd} 00:00:00" for the hub "<HubId>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"testaddress23","address2":"","country":"VN","postcode":"018981","latitude":"5.55555","longitude":"5.55555"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"testaddress23","address2":"","country":"VN","postcode":"018981","latitude":"5.55555","longitude":"5.55555"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success Reservation by scanning created parcel
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And API Operator calls pending pickup job trigger for station
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the tile:"<TileName>" is equal to "100"

    Examples:
      | HubName      | HubId      | Country | TileName         |
      | {hub-name-2} | {hub-id-2} | Vietnam | N+0 Pickup Rates |

  @ForceSuccessOrder @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn  @Debug
  Scenario Outline: View N+0 Pickup Rates - Success Due Today No Job Parcel
    Given Operator loads Operator portal home page
    And DB Operator update the parcel details to past date "{gradle-previous-2-day-yyyy-MM-dd} 00:00:00" for the hub "<HubId>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"testaddress23","address2":"","country":"VN","postcode":"018981","latitude":"5.55555","longitude":"5.55555"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"testaddress23","address2":"","country":"VN","postcode":"018981","latitude":"5.55555","longitude":"5.55555"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver success Reservation by scanning created parcel
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