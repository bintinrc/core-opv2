@StationManagement @PendingPickupJobs
Feature: Pending Pickup Jobs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: View N+0 Pickup Rates - No Due Today Parcel
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the N+0 tile:"<TileName>" is equal to "-"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | TileName         |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: View N+0 Pickup Rates - Pending Due Today Parcel
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the tile:"<TileName>" is equal to "0"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | TileName         |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates |

  @Happypath @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: View N+0 Pickup Rates - Success Due Today Parcel
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When DB Core - get reservation id from order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                          |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobType    | RESERVATION                                                                                                               |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the tile:"<TileName>" is equal to "100"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | TileName         |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: View N+0 Pickup Rates - Success Due Today No Job Parcel
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver fail the waypoint "{KEY_WAYPOINT_ID}" in the reservation "{KEY_CREATED_RESERVATION_ID}"
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 11          |
      | failureReasonIndexMode | FIRST       |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                                                           |
      | withLatLong                 | Yes                                                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"5.55555","longitude":"5.55555","milkrun_settings":[],"is_milk_run":false} |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]},"pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver get Reservation Job
    And API Driver success Reservation by scanning created parcel
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the tile:"<TileName>" is equal to "100"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | TileName         |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates |


  @Happypath @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Create New Job for No Job Address
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    When API Core - Operator get reservation from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And API Operator add reservation pick-up to the route
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver fail the waypoint "{KEY_WAYPOINT_ID}" in the reservation "{KEY_CREATED_RESERVATION_ID}"
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 11          |
      | failureReasonIndexMode | FIRST       |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    When Operator get the count from the pending pickup tile: "<TileName1>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verifies that url is redirected to "pickup-appointment" page on clicking the "Create Job" button
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_RESERVATIONS[1].addressId}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has decreased by 1
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then Operator verify Assign to Route button is displayed for the record

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |


  @Happypath @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Success Pickup All parcel in Reservation
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success Reservation by scanning created parcel
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verifies that No Pending Pickups message is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Fail All Parcels in Reservation
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And API Operator add reservation pick-up to the route
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver fail the waypoint "{KEY_WAYPOINT_ID}" in the reservation "{KEY_CREATED_RESERVATION_ID}"
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 11          |
      | failureReasonIndexMode | FIRST       |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed


    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: Search Pending Pickup Job - Search by Pickup Address
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    And Operator searches data in the pending pickup table by applying the following filters and expect one record:
      | <ColumnName>        |
      | <SearchValuePrefix> |
    And Operator searches data in the pending pickup table by applying the following filters and expect zero record:
      | <ColumnName>        |
      | <SearchValueSuffix> |

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    | ColumnName                 | SearchValuePrefix | SearchValueSuffix |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs | Pickup Address/ Address ID | pickup            | dfhdfh            |


  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: Search Pending Pickup Job - Search by Address ID
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    And Operator searches data in the pending pickup table by applying the following filters and expect one record:
      | <ColumnName>        |
      | <SearchValuePrefix> |
    And Operator searches data in the pending pickup table by applying the following filters and expect zero record:
      | <ColumnName>        |
      | <SearchValueSuffix> |

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    | ColumnName                 | SearchValuePrefix | SearchValueSuffix |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs | Pickup Address/ Address ID | pickup            | dfhdfh            |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: Search Pending Pickup Job - Search by Shipper Name
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    And Operator searches data in the pending pickup table by applying the following filters and expect one record:
      | <ColumnName>        |
      | <SearchValuePrefix> |
    And Operator searches data in the pending pickup table by applying the following filters and expect zero record:
      | <ColumnName>        |
      | <SearchValueSuffix> |

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    | ColumnName               | SearchValuePrefix | SearchValueSuffix |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs | Shipper Name/ Shipper ID | STATION-SHIPPER   | fdgdfg            |


  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: Search Pending Pickup Job - Search by Shipper ID
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    And Operator searches data in the pending pickup table by applying the following filters and expect one record:
      | <ColumnName>        |
      | <SearchValuePrefix> |
    And Operator searches data in the pending pickup table by applying the following filters and expect zero record:
      | <ColumnName>        |
      | <SearchValueSuffix> |

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    | ColumnName               | SearchValuePrefix | SearchValueSuffix |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs | Shipper Name/ Shipper ID | 138               | 21212122          |


  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: Search Pending Pickup Job - Search by Driver Name
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    And Operator searches data in the pending pickup table by applying the following filters and expect one record:
      | <ColumnName>        |
      | <SearchValuePrefix> |
    And Operator searches data in the pending pickup table by applying the following filters and expect zero record:
      | <ColumnName>        |
      | <SearchValueSuffix> |

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    | ColumnName            | SearchValuePrefix | SearchValueSuffix |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs | Driver Name/ Route ID | STATION           | dfgdfg            |


  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: Search Pending Pickup Job - Search by Route ID
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    And Operator searches data in the pending pickup table by applying the following filters and expect one record:
      | <ColumnName>        |
      | <SearchValuePrefix> |
    And Operator searches data in the pending pickup table by applying the following filters and expect zero record:
      | <ColumnName>        |
      | <SearchValueSuffix> |

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    | ColumnName            | SearchValuePrefix      | SearchValueSuffix |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs | Driver Name/ Route ID | {KEY_CREATED_ROUTE_ID} | 121212121         |


  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: View Addresses with Unrouted Jobs
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "DRIVER_EMPTY" column is equal to "-"
    Then Operator verifies that "Assign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @happypath @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn @NotExecute
  Scenario Outline: Assign Pending Pickup Job to Route
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verifies that url is redirected to "pickup-appointment" page on clicking the "Assign to Route" button
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    And API Operator add reservation pick-up to the route
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    Then Operator verify value on pending pickup table for the "DRIVER_NAME_ROUTE_ID" column is equal to "{ninja-driver-name} / {KEY_CREATED_ROUTE_ID}"
    Then Operator verifies that "Reassign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    | ColumnName                 | SearchValuePrefix |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs | Pickup Address/ Address ID | Pendingpickup     |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn @NotExecute
  Scenario Outline: Reassign Pending Pickup Job to Route
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    And API Operator add reservation pick-up to the route
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" remains unchanged
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    Then Operator verifies that url is redirected to "pickup-appointment" page on clicking the "Reassign to Route" button
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    And API Operator add reservation pick-up to the route
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" remains unchanged
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    Then Operator verify value on pending pickup table for the "DRIVER_NAME_ROUTE_ID" column is equal to "{ninja-driver-name} / {KEY_CREATED_ROUTE_ID}"
    Then Operator verifies that "Reassign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |


  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn @NotExecute
  Scenario Outline: Remove Pending Pickup Job from Route
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    And API Operator add reservation pick-up to the route
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    Then Operator verifies that url is redirected to "pickup-appointment" page on clicking the "Reassign to Route" button
    When API Operator unroute the reservation "{KEY_CREATED_RESERVATION_ID}"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "DRIVER_EMPTY" column is equal to "-"
    Then Operator verifies that "Assign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @happypath @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: Success Pickup by Global Inbound
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"<HubId>" } |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verifies that No Pending Pickups message is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View Due Tomorrow Parcel if Reservation Date is Today
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 11:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" remains unchanged
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 0"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    Then Operator verifies that "Assign to Route" action button is displayed
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-previous-1-day-yyyy-MM-dd} 11:30:00" for the hub "<HubId>"
    When DB Station - Operator updates reservation_date "{gradle-previous-1-day-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 1"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 12:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @Happypath @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View Due Today Parcel if Reservation Date is Today
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 1"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    Then Operator verifies that "Assign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 12:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View Due Today Parcel if Reservation Date is Tomorrow
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-next-1-day-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    When Operator get the count from the pending pickup tile: "<TileName1>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 1"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-previous-1-day-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" remains unchanged
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    When operator click "Unrouted Jobs" filter button
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 0"
    Then Operator verify value on pending pickup table for the "PARCEL_LATE" column is equal to "Late: 1"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    Then Operator verifies that "Assign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 12:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |


  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View Due Tomorrow Parcel if Reservation Date is Tomorrow
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 11:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-next-1-day-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" remains unchanged
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    When operator click "No Jobs Created" filter button
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 0"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-previous-1-day-yyyy-MM-dd} 11:30:00" for the hub "<HubId>"
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 1"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    Then Operator verifies that "Assign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 12:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View Late Parcel Created Before Cut Off Time
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-previous-1-day-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-previous-1-day-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" remains unchanged
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName1>" remains unchanged
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    When operator click "No Jobs Created" filter button
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_LATE" column is equal to "Late: 1"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 12:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View Late Parcel Created After Cut Off Time
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-previous-2-day-yyyy-MM-dd} 11:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-previous-1-day-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" remains unchanged
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName1>" remains unchanged
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    When operator click "No Jobs Created" filter button
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_LATE" column is equal to "Late: 1"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 12:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: Partial Success Pickup Due Today Reservation
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_CREATED_RESERVATION_ID}       |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_WAYPOINT_ID}                                                                     |
      | jobType    | RESERVATION                                                                           |
      | jobMode    | PICK_UP                                                                               |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 1"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 12:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: Partial Success Pickup Late Reservation
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-previous-1-day-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    When DB Station - Operator updates reservation_date "{gradle-previous-1-day-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 0
    When Operator get the count from the pending pickup tile: "<TileName1>"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_CREATED_RESERVATION_ID}       |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_WAYPOINT_ID}                                                                     |
      | jobType    | RESERVATION                                                                           |
      | jobMode    | PICK_UP                                                                               |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 0
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has decreased by 0
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    When operator click "No Jobs Created" filter button
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_LATE" column is equal to "Late: 1"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 12:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn @NotExecute
  Scenario Outline: Success Pickup Address with No jobs with New Reservation Created by OC
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_CREATED_RESERVATION_ID}       |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver fail the waypoint "{KEY_WAYPOINT_ID}" in the reservation "{KEY_CREATED_RESERVATION_ID}"
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 11          |
      | failureReasonIndexMode | FIRST       |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    When Operator get the count from the pending pickup tile: "<TileName1>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending pickup order2","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending order2","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 10 seconds
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_CREATED_RESERVATION_ID}       |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 2"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 2"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_WAYPOINT_ID}                                                                     |
      | jobType    | RESERVATION                                                                           |
      | jobMode    | PICK_UP                                                                               |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_WAYPOINT_ID}                                                                     |
      | jobType    | RESERVATION                                                                           |
      | jobMode    | PICK_UP                                                                               |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has decreased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verifies that No Pending Pickups message is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @Happypath @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn @NotExecute
  Scenario Outline: Success Pickup Address with No jobs with New Reservation Created on PAM
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_CREATED_RESERVATION_ID}       |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver fail the waypoint "{KEY_WAYPOINT_ID}" in the reservation "{KEY_CREATED_RESERVATION_ID}"
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 11          |
      | failureReasonIndexMode | FIRST       |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    When Operator get the count from the pending pickup tile: "<TileName1>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 1"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_WAYPOINT_ID}                                                                     |
      | jobType    | RESERVATION                                                                           |
      | jobMode    | PICK_UP                                                                               |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has decreased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verifies that No Pending Pickups message is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Cancel All Parcels in Reservation
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    Given DB Operator get Grab reservation id
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    Given API Operator cancel created orders
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verifies that No Pending Pickups message is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Cancel No Job Parcel
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And API Operator add reservation pick-up to the route
    And API Driver collect all his routes
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver fail the waypoint "{KEY_WAYPOINT_ID}" in the reservation "{KEY_CREATED_RESERVATION_ID}"
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 11          |
      | failureReasonIndexMode | FIRST       |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    When Operator get the count from the pending pickup tile: "<TileName1>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Given API Operator cancel created orders
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has decreased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verifies that No Pending Pickups message is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Cancel Some Parcels in Reservation
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    Given DB Operator get Grab reservation id
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 2"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 2"
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 1"
    Then Operator verifies that "Assign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Force Complete Parcel
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Given DB Operator get Grab reservation id
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    Given API Operator force succeed all created orders
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verifies that No Pending Pickups message is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Force Success Pending Pickup Job
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss}Station Pendingpickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_CREATED_RESERVATION_ID}       |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {shipper-v4-legacy-id}           |
      | status      | ROUTED                           |
    When Operator finish reservation with success
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Force Fail Pending Pickup Job
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given DB Operator get Grab reservation id
    And DB Operator get waypoint Id from reservation id "{KEY_CREATED_RESERVATION_ID}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_CREATED_RESERVATION_ID}       |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd}   |
      | shipperName | {shipper-v4-legacy-id}           |
      | status      | ROUTED                           |
    When Operator finish reservation with failure
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Cancel Pending Pickup Job
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss}Station Pendingpickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    Given DB Operator get Grab reservation id
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    When Update status reservation to Cancelled
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verifies that "Create Job" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Cancel Some Parcels in Reservation
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss}Station Pendingpickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    Given DB Operator get Grab reservation id
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" remains unchanged
    Then Operator verifies that the count in the pending pickup tile: "<TileName1>" remains unchanged
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 1"
    Then Operator verifies that "Assign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |


  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: View Timeslot of Pending Pickup Job - Pickup Time 9am-12pm
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss}Station Pendingpickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TIMESLOT" column is equal to "Timeslot: <start_time> - <end_time>"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 12:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: View Timeslot of Pending Pickup Job - Pickup Time 12pm-3pm
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss}Station Pendingpickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TIMESLOT" column is equal to "Timeslot: <start_time> - <end_time>"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 12:00      | 15:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: View Timeslot of Pending Pickup Job - Pickup Time 3pm-6pm
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss}Station Pendingpickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TIMESLOT" column is equal to "Timeslot: <start_time> - <end_time>"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 15:00      | 18:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: View Timeslot of Pending Pickup Job - Pickup Time 6pm-10pm
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss}Station Pendingpickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TIMESLOT" column is equal to "Timeslot: <start_time> - <end_time>"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 18:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: View Timeslot of Pending Pickup Job - Pickup Time 9am-6pm
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss}Station Pendingpickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TIMESLOT" column is equal to "Timeslot: <start_time> - <end_time>"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 18:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: View Timeslot of Pending Pickup Job - Pickup Time 9am-10pm
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss}Station Pendingpickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TIMESLOT" column is equal to "Timeslot: <start_time> - <end_time>"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: Sort Pending Pickup Job by Parcels to Pickup
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss}Station Pending Pickup Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 2
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 2"
    When Operator clicks on the sort icon in the Parcel to Pickup column
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: View Priority Level of Pending Pickup Job - Priority Level 0 (Non Priority)
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When API Core - Operator get reservation from reservation id "{KEY_CREATED_RESERVATION_ID}"
    When API Core - Operator update priority level for the reservation using data below:
      | pickupAddressId | {KEY_LIST_OF_RESERVATIONS[1].addressId} |
      | legacyShipperId | {shipper-v4-legacy-id}                  |
      | priorityLevel   | <priority>                              |
      | reservationId   | {KEY_CREATED_RESERVATION_ID}            |
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "PRIORITY_LEVEL" column is equal to "Priority Level: <priority>"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | priority | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | 0        | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: View Priority Level of Pending Pickup Job - Priority Level 1 (Normal Priority)
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When API Core - Operator get reservation from reservation id "{KEY_CREATED_RESERVATION_ID}"
    When API Core - Operator update priority level for the reservation using data below:
      | pickupAddressId | {KEY_LIST_OF_RESERVATIONS[1].addressId} |
      | legacyShipperId | {shipper-v4-legacy-id}                  |
      | priorityLevel   | <priority>                              |
      | reservationId   | {KEY_CREATED_RESERVATION_ID}            |
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "PRIORITY_LEVEL" column is equal to "Priority Level: <priority>"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | priority | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | 1        | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: View Priority Level of Pending Pickup Job - Priority Level 2 - 90 (Late Priority)
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When API Core - Operator get reservation from reservation id "{KEY_CREATED_RESERVATION_ID}"
    When API Core - Operator update priority level for the reservation using data below:
      | pickupAddressId | {KEY_LIST_OF_RESERVATIONS[1].addressId} |
      | legacyShipperId | {shipper-v4-legacy-id}                  |
      | priorityLevel   | <priority>                              |
      | reservationId   | {KEY_CREATED_RESERVATION_ID}            |
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "PRIORITY_LEVEL" column is equal to "Priority Level: <priority>"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | priority | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | 2        | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @SystemIdNotSg @default-vn
  Scenario Outline: View Priority Level of Pending Pickup Job - Priority Level 91 - above (Urgent Priority)
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    When DB Station - Operator update the first mile parcel createdAt to "{gradle-current-date-yyyy-MM-dd} 10:30:00" for the hub "<HubId>"
    Given DB Operator get Grab reservation id
    When API Core - Operator get reservation from reservation id "{KEY_CREATED_RESERVATION_ID}"
    When API Core - Operator update priority level for the reservation using data below:
      | pickupAddressId | {KEY_LIST_OF_RESERVATIONS[1].addressId} |
      | legacyShipperId | {shipper-v4-legacy-id}                  |
      | priorityLevel   | <priority>                              |
      | reservationId   | {KEY_CREATED_RESERVATION_ID}            |
    When DB Station - Operator updates reservation_date "{gradle-current-date-yyyy-MM-dd}" for the reservation id "{KEY_CREATED_RESERVATION_ID}" in the stationJobs table
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "PRIORITY_LEVEL" column is equal to "Priority Level: <priority>"

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | priority | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | 91       | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Resume Pickup Cancelled Parcel
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    Given DB Operator get Grab reservation id
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has decreased by 1
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    When API Operator resume the created order
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in the second in the pending pick up tile: "<TileName2>" has increased by 1
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "Job ID: {KEY_CREATED_RESERVATION_ID}"
    Then Operator verify value on pending pickup table for the "TOTAL_PARCEL_COUNT" column is equal to "Total: 1"
    Then Operator verify value on pending pickup table for the "PARCEL_DUE_TODAY" column is equal to "Due Today: 1"
    Then Operator verifies that "Assign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |


  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View Addresses with No Jobs Created
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":false,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verifies that "No Jobs Created" button is in clicked status
    Then Operator verifies that "Unrouted Jobs" button is in unclicked status
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verify value on pending pickup table for the "DRIVER_EMPTY" column is equal to "-"
    Then Operator verifies that "Create Job" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | priority | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | 91       | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: View Addresses with Routed Jobs
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":false,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And Operator waits for 80 seconds
    And API Station - Operator calls pending pickup job trigger for station
    And API Station - Operator clears station cache
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verifies that "Unrouted Jobs" button is in clicked status
    Then Operator verifies that "No Jobs Created" button is in unclicked status
    When operator click "Unrouted Jobs" filter button
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then Operator verify value on pending pickup table for the "DRIVER_NAME_ROUTE_ID" column is equal to "{ninja-driver-name} / {KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator verifies that "Reassign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |


  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View Addresses with only Late Parcel and No Jobs Created
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And DB Station - Operator update the first mile parcel createdAt to "{date: -1 days next, YYYY-MM-dd} 10:30:00" for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verifies that "No Jobs Created" button is in clicked status
    Then Operator verifies that "Unrouted Jobs" button is in unclicked status
    Then Operator verifies that No Pending Pickups message is displayed
    When operator click "No Jobs Created" filter button
    Then Operator verify value on pending pickup table for the "NO_UPCOMING_JOB" column is equal to "No upcoming"
    Then Operator verify value on pending pickup table for the "DRIVER_EMPTY" column is equal to "-"
    Then Operator verifies that "Create Job" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @SystemIdNotSg @default-vn
  Scenario Outline: View Addresses with only Late Parcel and Unrouted Job
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":true,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    And Operator waits for 80 seconds
    And DB Station - Operator update the first mile parcel createdAt to "{date: -1 days next, YYYY-MM-dd} 10:30:00" for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verifies that "Unrouted Jobs" button is in clicked status
    Then Operator verifies that "No Jobs Created" button is in unclicked status
    When operator click "Unrouted Jobs" filter button
    Then Operator verify value on pending pickup table for the "JOB_ID" column is equal to "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then Operator verify value on pending pickup table for the "DRIVER_EMPTY" column is equal to "-"
    Then Operator verifies that "Assign to Route" action button is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-3} | {hub-id-3} | 2.22222  | 2.22222   | 09:00      | 12:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Unable to View Addresses with Unrouted Jobs
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":false,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                 |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                   |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                  |
      | jobType         | RESERVATION                                                                        |
      | jobAction       | FAIL                                                                               |
      | jobMode         | PICK_UP                                                                            |
      | failureReasonId | 13                                                                                 |
    When API Station - Operator clears station cache
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName1>"
    Then Operator verifies that "No Jobs Created" button is in clicked status
    Then Operator verifies that "Unrouted Jobs" button is in unclicked status
    Then Operator verifies that No Pending Pickups message is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @ForceSuccessOrder @ForceSuccessReservationByApi @DeleteOrArchiveRoute @TimeBased @SystemIdNotSg @default-vn
  Scenario Outline: Unable to View Addresses with No Jobs Created
    Given Operator loads Operator portal home page
    When DB Station - Operator delete Station Pending Pickup records for the hub "<HubId>"
    And API Station - Operator calls pending pickup job trigger for station
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    When Operator get the count from the pending pickup tile: "<TileName1>"
    When Operator get the count from one more tile in pending pickup: "<TileName2>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","reference":{"merchant_order_number":"ship-123","merchant_order_metadata":{"delivery_verification_identity":null}},"from":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"TEST-NADIA-CUSTOMER","phone_number":"+6591434259","email":"nadia.dwijaatmaja@ninjavan.co","address":{"address1":"JalanBidakaraMentengDalamTebet","address2":"NVQA","country":"VN","postcode":"12870"}},"parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP","is_pickup_required":false,"pickup_date":"{gradle-current-date-yyyy-MM-dd}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"<start_time>","end_time":"<end_time>","timezone":"Asia/Ho_Chi_Minh"},"pickup_instructions":"pickupinstruction","pickup_address":{"name":"TEST-NADIA-SHIPPER","phone_number":"+6591434259","address":{"address1":"{gradle-current-date-yyyyMMddHHmmsss} Station Pending Pickup","address2":"","country":"VN","postcode":"018981","latitude":"<latitude>","longitude":"<longitude>"}},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Ho_Chi_Minh"},"delivery_instructions":"deliveryinstruction","dimensions":{"weight":1,"width":10,"height":10,"length":10,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    When API Station - Operator clears station cache
    And API Station - Operator calls pending pickup job trigger for station
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator clicks on the hamburger button for the pending pickup tile: "<TileName2>"
    Then Operator verifies that "Unrouted Jobs" button is in clicked status
    Then Operator verifies that "No Jobs Created" button is in unclicked status
    Then Operator verifies that No Pending Pickups message is displayed

    Examples:
      | HubName      | HubId      | latitude | longitude | start_time | end_time | Country | ModalName        | TileName1                      | TileName2                    |
      | {hub-name-2} | {hub-id-2} | 5.55555  | 5.55555   | 09:00      | 22:00    | Vietnam | N+0 Pickup Rates | Addresses with no jobs created | Addresses with unrouted jobs |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op