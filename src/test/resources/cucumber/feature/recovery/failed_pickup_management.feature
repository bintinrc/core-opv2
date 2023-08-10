@OperatorV2 @Recovery @FailedPickupManagementV2 @ClearCache @ClearCookies
Feature: Failed Pickup Management Page - Action Feature

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator - Select all shown - Failed Pickup Management page
    Given Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    When Recovery User - clicks "Select All Shown" button on Failed Pickup Management page
    And Recovery User - verifies number of selected rows on Failed Pickup Management page

  Scenario: Operator - Show only selection - Failed pickup Management page
    Given Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    And Recovery User - selects 1 rows on Failed Pickup Management page
    When Recovery User - clicks "Show Only Selected" button on Failed Pickup Management page
    Then Recovery User - verify the number of selected Failed Pickup rows is "1"

  Scenario: Operator - Deselect all shown - Failed Pickup Management page
    Given Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    When Recovery User - clicks "Select All Shown" button on Failed Pickup Management page
    And Recovery User - verifies number of selected rows on Failed Pickup Management page
    When Recovery User - clicks "Deselect All Shown" button on Failed Pickup Management page
    Then Recovery User - verify the number of selected Failed Pickup rows is "0"

  Scenario: Operator - Clear Current selection - Failed Pickup Management page
    Given Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    When Recovery User - clicks "Select All Shown" button on Failed Pickup Management page
    And Recovery User - verifies number of selected rows on Failed Pickup Management page
    When Recovery User - clicks "Clear Current Selection" button on Failed Pickup Management page
    Then Recovery User - verify the number of selected Failed Pickup rows is "0"

  Scenario: Operator - Find Failed Pickup Return Order - by some filters
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
    And Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And Recovery User - Search failed orders by shipperName = "{KEY_LIST_OF_CREATED_ORDERS[1].shipper.name}"
    And Recovery User - verify failed pickup table on FPM page:
      | trackingId            | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}        |
      | shipperName           | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | failureReasonComments | Parcel is not ready for collection           |

  Scenario: Operator - Download and Verify Failed Pickup order - CSV File
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
    And Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And Recovery User - selects 1 rows on Failed Pickup Management page
    And Recovery User - Download CSV file of failed pickup order on Failed Pickup orders list
    And Recovery User - verify CSV file of failed pickup order on Failed Pickup orders list downloaded successfully

  Scenario: Operator - Reschedule Failed Pickup - Single Order - on Next Day
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
    And Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Recovery User - reschedule failed pickup order on next day
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order Rescheduling Success       |
      | description | Success to reschedule 1 order(s) |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RESCHEDULE |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type    | PICKUP                                   |
      | status  | FAIL                                     |
      | driver  | {ninja-driver-name}                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
      | dnr     | NORMAL                                   |
      | name    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP                                   |
      | status | PENDING                                  |
      | dnr    | NORMAL                                   |
      | name   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} |

  Scenario: Operator - Reschedule Failed Pickup - Single Order - specific date
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
    And Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And Recovery User - selects 1 rows on Failed Pickup Management page
    And Recovery User - Reschedule Selected failed pickup order on Failed Pickup orders list
    And Recovery User - set reschedule date to "{date: 2 days next, yyyy-MM-dd}" on Failed Pickup Management Page
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order Rescheduling Success       |
      | description | Success to reschedule 1 order(s) |
    And Recovery User - verify CSV file downloaded after reschedule failed pickup
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RESCHEDULE |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type    | PICKUP                                   |
      | status  | FAIL                                     |
      | driver  | {ninja-driver-name}                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
      | dnr     | NORMAL                                   |
      | name    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP                                   |
      | status | PENDING                                  |
      | dnr    | NORMAL                                   |
      | name   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} |

  Scenario: Operator - Reschedule Multiple Failed Pickup Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{"tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | PICK_UP                                                                                             |
      | failureReasonId | 139                                                                                                 |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{"tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | PICK_UP                                                                                             |
      | failureReasonId | 139                                                                                                 |
    And Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And Recovery User - selects 1 rows on Failed Pickup Management page
    When Recovery User - Clear the TID filter on Failed Pickup Management page
    And Recovery User - Search failed orders by trackingId = "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And Recovery User - selects 1 rows on Failed Pickup Management page
    When Recovery User - Clear the TID filter on Failed Pickup Management page
    When Recovery User - clicks "Show Only Selected" button on Failed Pickup Management page
    And Recovery User - Reschedule Selected failed pickup order on Failed Pickup orders list
    And Recovery User - set reschedule date to "{date: 2 days next, yyyy-MM-dd}" on Failed Pickup Management Page
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Order Rescheduling Success       |
      | description | Success to reschedule 2 order(s) |
    And Recovery User - verify CSV file downloaded after reschedule failed pickup

     #Verify first failed order
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RESCHEDULE |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type    | PICKUP                                   |
      | status  | FAIL                                     |
      | driver  | {ninja-driver-name}                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
      | dnr     | NORMAL                                   |
      | name    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP                                   |
      | status | PENDING                                  |
      | dnr    | NORMAL                                   |
      | name   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} |

     #Verify Second failed order
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "Pending" on Edit Order V2 page
    And Operator verify order granular status is "Pending Pickup" on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RESCHEDULE |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type    | PICKUP                                   |
      | status  | FAIL                                     |
      | driver  | {ninja-driver-name}                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
      | dnr     | NORMAL                                   |
      | name    | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | PICKUP                                   |
      | status | PENDING                                  |
      | dnr    | NORMAL                                   |
      | name   | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} |

  Scenario: Operator - Cancel Failed Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
    And Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And Recovery User - selects 1 rows on Failed Pickup Management page
    When Recovery User - Cancel Selected orders in Failed Pickup Management page
    Then Recovery User - verifies Cancel Selected dialog
      | trackingId                            | status      |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Pickup fail |
    When Recovery User - inputs cancellation reason in Cancel Selected dialog
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Cancel Order Successfully    |
      | description | Success 1 order(s) Cancelled |
    And Operator go to menu Order -> All Orders
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify transaction on Edit Order V2 page using data below:
      | type    | PICKUP                                   |
      | status  | FAIL                                     |
      | driver  | {ninja-driver-name}                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
      | dnr     | RESCHEDULING                             |
      | name    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY                               |
      | status | CANCELLED                              |
      | dnr    | CANCEL                                 |
      | name   | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |

  Scenario: Operator - Cancel Multiple Failed Pickup Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{"tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | PICK_UP                                                                                             |
      | failureReasonId | 139                                                                                                 |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[1].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{"tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | PICK_UP                                                                                             |
      | failureReasonId | 139                                                                                                 |
    And Operator go to menu Shipper Support -> Failed Pickup Management
    And Operator refresh page
    And Recovery User - Wait until FPM Page loaded completely
    And Recovery User - Search failed orders by trackingId = "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And Recovery User - selects 1 rows on Failed Pickup Management page
    When Recovery User - Clear the TID filter on Failed Pickup Management page
    And Recovery User - Search failed orders by trackingId = "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And Recovery User - selects 1 rows on Failed Pickup Management page
    When Recovery User - Clear the TID filter on Failed Pickup Management page
    When Recovery User - clicks "Show Only Selected" button on Failed Pickup Management page
    When Recovery User - Cancel Selected orders in Failed Pickup Management page
    Then Recovery User - verifies Cancel Selected dialog
      | trackingId                            | status      |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Pickup fail |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Pickup fail |
    When Recovery User - inputs cancellation reason in Cancel Selected dialog
    Then Recovery User - verifies that toast displayed with message below:
      | message     | Cancel Order Successfully    |
      | description | Success 2 order(s) Cancelled |
    And Operator go to menu Order -> All Orders

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify transaction on Edit Order V2 page using data below:
      | type    | PICKUP                                   |
      | status  | FAIL                                     |
      | driver  | {ninja-driver-name}                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
      | dnr     | RESCHEDULING                             |
      | name    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY                                 |
      | status | CANCELLED                                |
      | dnr    | CANCEL                                   |
      | name   | {KEY_LIST_OF_CREATED_ORDERS[1].toName} |

    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order status is "Cancelled" on Edit Order V2 page
    And Operator verify order granular status is "Cancelled" on Edit Order V2 page
    And Operator verify transaction on Edit Order V2 page using data below:
      | type    | PICKUP                                   |
      | status  | FAIL                                     |
      | driver  | {ninja-driver-name}                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
      | dnr     | RESCHEDULING                             |
      | name    | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY                                 |
      | status | CANCELLED                                |
      | dnr    | CANCEL                                   |
      | name   | {KEY_LIST_OF_CREATED_ORDERS[2].toName} |
