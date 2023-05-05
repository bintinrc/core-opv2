@OperatorV2 @Recovery @FailedPickupManagementV2 @batool
Feature: Failed Pickup Management Page - Action Feature

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
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

  Scenario: Kill Browser
    Given no-op