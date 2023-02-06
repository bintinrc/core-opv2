@OperatorV2 @Driver @RouteManifest
Feature: Route Manifest

  @LaunchBrowser @ShouldAlwaysRun @EnableClearCache
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: View Verified POA/POH
    Given API Driver - Driver login with username "{ninja-driver-2-username}" and "{ninja-driver-2-password}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    Given API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given DB Core - get reservation id from order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-2-id} } |
    Given API Core - Operator get reservation from reservation id "{KEY_LIST_OF_RESERVATION_IDS[1]}"
    Given API Core - Operator add reservation pick-ups to the route using data below:
      | reservationId | {KEY_LIST_OF_RESERVATION_IDS[1]}   |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success reservation waypoint from Route Manifest page
    And API Driver - Driver submit POH and upload photo using data below:
      | submitPohRequest | {"arrival_lat":1.3124816743097882,"arrival_lng":103.86115769737604,"hub_lat": 1.31191933963,"hub_lng": 103.8613747288,"final_parcel_count":2,"hub_staff_username":"ty","num_photos":1,"original_parcel_count":0,"route_external_ids":[{KEY_LIST_OF_CREATED_ROUTES[1].id}],"verification_type":"QR"} |
      | hubHandoverId    | 1                                                                                                                                                                                                                                                                                                                      |
    And Operator refresh page
    When Operator click view POA/POH button on Route Manifest page
    Then Operator click View on Map
    And Operator verifies Proof of Arrival table for the row number "1" on Route Manifest page:
      | verifiedByGps       | Yes                |
      | distanceFromSortHub | 67                 |
    And Operator verifies Proof of Handover table for the row number "1" on Route Manifest page:
      | estQty           | 0                   |
      | staffUsername    | ty                  |
      | handover         | QR                  |
      | cntQty           | 2                   |
    And Operator click View Photo

  @DeleteOrArchiveRoute
  Scenario: View Un-verified POA/POH
    Given API Driver - Driver login with username "{ninja-driver-2-username}" and "{ninja-driver-2-password}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    Given API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given DB Core - get reservation id from order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-2-id} } |
    Given API Core - Operator get reservation from reservation id "{KEY_LIST_OF_RESERVATION_IDS[1]}"
    Given API Core - Operator add reservation pick-ups to the route using data below:
      | reservationId | {KEY_LIST_OF_RESERVATION_IDS[1]}   |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success reservation waypoint from Route Manifest page
    And API Driver - Driver submit POH and upload photo using data below:
      | submitPohRequest | {"arrival_lat":-6.2421224,"arrival_lng":106.8469057,"final_parcel_count":2,"handover_time":"2022-12-06T09:55:09+0700","hub_staff_username":"ty","num_photos":1,"original_parcel_count":0,"route_external_ids":[{KEY_LIST_OF_CREATED_ROUTES[1].id}],"verification_type":"QR"} |
      | hubHandoverId    | 1                                                                                                                                                                                                                                                                                                                      |
    And Operator refresh page
    When Operator click view POA/POH button on Route Manifest page
    Then Operator click View on Map
    And Operator verifies Proof of Arrival table for the row number "1" on Route Manifest page:
      | verifiedByGps       | No                  |
      | distanceFromSortHub | N/A                 |
    And Operator verifies Proof of Handover table for the row number "1" on Route Manifest page:
      | estQty           | 0                   |
      | staffUsername    | ty                  |
      | handover         | QR                  |
      | cntQty           | 2                   |
    And Operator click View Photo

  @DeleteOrArchiveRoute
  Scenario: Unable to View POA/POH
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    Given API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given DB Core - get reservation id from order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-2-id} } |
    Given API Core - Operator get reservation from reservation id "{KEY_LIST_OF_RESERVATION_IDS[1]}"
    Given API Core - Operator add reservation pick-ups to the route using data below:
      | reservationId | {KEY_LIST_OF_RESERVATION_IDS[1]}   |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success reservation waypoint from Route Manifest page
    And Operator refresh page
    Then Operator verify POA/POH button is disabled on Route Manifest page

  @DeleteOrArchiveRoute
  Scenario: View Multiple Rows of Verified POA/POH
    Given API Driver - Driver login with username "{ninja-driver-2-username}" and "{ninja-driver-2-password}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    Given API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given DB Core - get reservation id from order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-2-id} } |
    Given API Core - Operator get reservation from reservation id "{KEY_LIST_OF_RESERVATION_IDS[1]}"
    Given API Core - Operator add reservation pick-ups to the route using data below:
      | reservationId | {KEY_LIST_OF_RESERVATION_IDS[1]}   |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator open Route Manifest page for route ID "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator success reservation waypoint from Route Manifest page
    And API Driver - Driver submit POH and upload photo using data below:
      | submitPohRequest | {"arrival_lat":-6.2421224,"arrival_lng":106.8469057,"final_parcel_count":2,"handover_time":"2022-12-06T09:55:09+0700","hub_staff_username":"ty","num_photos":1,"original_parcel_count":0,"route_external_ids":[{KEY_LIST_OF_CREATED_ROUTES[1].id}],"verification_type":"QR"} |
      | hubHandoverId    | 1                                                                                                                                                                                                                                                                                                                      |
    And Operator refresh page
    When Operator click view POA/POH button on Route Manifest page
    And Operator verifies Proof of Arrival table for the row number "1" on Route Manifest page:
      | verifiedByGps       | No                  |
      | distanceFromSortHub | N/A                 |
    And Operator verifies Proof of Handover table for the row number "1" on Route Manifest page:
      | estQty           | 0                   |
      | staffUsername    | ty                  |
      | handover         | QR                  |
      | cntQty           | 2                   |
    And Operator click View Photo
    And API Driver - Driver submit POH and upload photo using data below:
      | submitPohRequest | {"arrival_lat":-6.2421224,"arrival_lng":106.8469057,"final_parcel_count":2,"handover_time":"2022-12-06T09:55:09+0700","hub_staff_username":"ty","num_photos":1,"original_parcel_count":0,"route_external_ids":[{KEY_LIST_OF_CREATED_ROUTES[1].id}],"verification_type":"QR"} |
      | hubHandoverId    | 1                                                                                                                                                                                                                                                                                                                      |
    And Operator refresh page
    When Operator click view POA/POH button on Route Manifest page
    Then Operator click View on Map
    And Operator verifies Proof of Arrival table for the row number "2" on Route Manifest page:
      | verifiedByGps       | No                  |
      | distanceFromSortHub | N/A                 |
    And Operator verifies Proof of Handover table for the row number "2" on Route Manifest page:
      | estQty           | 0                   |
      | staffUsername    | ty                  |
      | handover         | QR                  |
      | cntQty           | 2                   |
    And Operator click View Photo