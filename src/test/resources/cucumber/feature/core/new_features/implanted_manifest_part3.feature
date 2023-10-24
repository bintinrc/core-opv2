@OperatorV2 @Core @NewFeatures @ImplantedManifest @ImplantedManifestPart3
Feature: Implanted Manifest

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePickupAppointmentJob @ArchiveRouteCommonV2
  Scenario: Operator Creates Implanted Manifest for PA Job with Total Scanned Orders = Total of POD
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    And DB Route - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | waypointId  | {KEY_WAYPOINT_ID}                  |
      | routes      | KEY_DRIVER_ROUTES                  |
      | parcels     | []                                 |
      | jobType     | PICKUP_APPOINTMENT                 |
      | jobAction   | SUCCESS                            |
      | jobMode     | PICK_UP                            |
      | basePayload | {"pickup_quantity":1}              |
    When Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator creates manifest for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" reservation on Implanted Manifest page
    Then Operator verifies that success react notification displayed:
      | top | Manifest has been created |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And Operator clicks "Filter Jobs" button on Pickup Jobs page
    And Operator open Job Details for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" job on Pickup Jobs page
    Then Operator verify Job Details values on Pickup Jobs page:
      | status                | SUCCESS                               |
      | removedTid            | -                                     |
      | scannedAtShipperCount | 1                                     |
      | scannedAtShippers     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator click Download Parcel List button in Job Details modal on Pickup Jobs page
    Then Operator verify downloaded parcel list contains TIDs on Pickup Jobs page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | DRIVER PICKUP SCAN                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE STATUS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | IMPLANTED MANIFEST SCAN                                                                                                                                      |
      | description | Driver ID: {ninja-driver-id} Route ID: {KEY_LIST_OF_CREATED_ROUTES[1].id} Waypoint ID: {KEY_WAYPOINT_ID} Reservation ID: {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And DB Core - Operator verifies inbound_scans record:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}                     |
      | type     | 1                                                      |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                     |
      | location | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineShortAddress} |
    And DB Core - verify orders record:
      | id                  | {KEY_LIST_OF_CREATED_ORDERS[1].id}     |
      | latestInboundScanId | {KEY_CORE_LIST_OF_INBOUND_SCANS[1].id} |
    And DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table

  Scenario: Operator Failed to Create Implanted Manifest Pickup with Invalid PA Job Id
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator creates manifest for "1" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error                                                    |
      | bottom | Reservation or Job ID not found! Please enter another ID |

  @DeletePickupAppointmentJob
  Scenario: Operator Failed to Create Implanted Manifest Pickup with Invalid PA Job Status - Pending PA Job
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    When Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator creates manifest for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error                                                    |
      | bottom | Reservation or Job ID not found! Please enter another ID |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And Operator open Job Details for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" job on Pickup Jobs page
    Then Operator verify no Proof of Pickup details in Job Details modal on Pickup Jobs page

  @DeletePickupAppointmentJob @ArchiveRouteCommonV2
  Scenario: Operator Failed to Create Implanted Manifest Pickup with Invalid PA Job Status - Failed PA Job
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    And DB Route - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | waypointId      | {KEY_WAYPOINT_ID}                  |
      | routes          | KEY_DRIVER_ROUTES                  |
      | jobType         | PICKUP_APPOINTMENT                 |
      | parcels         | []                                 |
      | jobAction       | FAIL                               |
      | jobMode         | PICK_UP                            |
      | failureReasonId | 1472                               |
    When Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator creates manifest for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error                             |
      | bottom | Not a success pickup appointment! |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And Operator open Job Details for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" job on Pickup Jobs page
    Then Operator verify Job Details values on Pickup Jobs page:
      | status               | FAIL |
      | failedAtShipperCount | 0    |
      | failedAtShippers     |      |


  @DeletePickupAppointmentJob @ArchiveRouteCommonV2
  Scenario: Operator Failed to Create Implanted Manifest Pickup - PA Job without POD Pickup
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    And DB Route - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                               |
      | waypointId | {KEY_WAYPOINT_ID}                                                                |
      | routes     | KEY_DRIVER_ROUTES                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS"}] |
      | jobType    | PICKUP_APPOINTMENT                                                               |
      | jobAction  | SUCCESS                                                                          |
      | jobMode    | PICK_UP                                                                          |
    When Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    When Operator creates manifest for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error             |
      | bottom | No POD available! |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And Operator open Job Details for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" job on Pickup Jobs page
    Then Operator verify Job Details values on Pickup Jobs page:
      | status                | SUCCESS                               |
      | scannedAtShipperCount | 1                                     |
      | scannedAtShippers     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  @DeletePickupAppointmentJob @ArchiveRouteCommonV2
  Scenario: Operator Failed to Create Implanted Manifest Pickup - Total Scanned Orders != Total of POD for PA Job
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    And DB Route - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | waypointId  | {KEY_WAYPOINT_ID}                  |
      | routes      | KEY_DRIVER_ROUTES                  |
      | parcels     | []                                 |
      | jobType     | PICKUP_APPOINTMENT                 |
      | jobAction   | SUCCESS                            |
      | jobMode     | PICK_UP                            |
      | basePayload | {"pickup_quantity":2}              |
    When Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator creates manifest for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error                                       |
      | bottom | POD and Manifest parcel count do not match. |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And Operator open Job Details for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" job on Pickup Jobs page
    Then Operator verify Job Details values on Pickup Jobs page:
      | status                | SUCCESS |
      | scannedAtShipperCount | 0       |
      | scannedAtShippers     |         |

  @DeletePickupAppointmentJob @ArchiveRouteCommonV2
  Scenario: Operator Failed to Create Implanted Manifest Pickup - PA Job POD More Than 7 Days Ago
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-paj-id} |
      | generateAddress | RANDOM              |
    And API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{shipper-v4-paj-id}, "from":{ "addressId": {KEY_LIST_OF_CREATED_ADDRESSES[1].id} }, "pickupService":{ "level":"Standard", "type":"Scheduled"}, "pickupTimeslot":{ "ready":"{date: 1 days next, YYYY-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, YYYY-MM-dd}T12:00:00+08:00"}, "pickupApproxVolume":"Less than 10 Parcels"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    And DB Route - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}              |
      | waypointId  | {KEY_WAYPOINT_ID}                               |
      | routes      | KEY_DRIVER_ROUTES                               |
      | parcels     | []                                              |
      | jobType     | PICKUP_APPOINTMENT                              |
      | jobAction   | SUCCESS                                         |
      | jobMode     | PICK_UP                                         |
      | basePayload | {"pickup_quantity":1,"commit_date": 1686402522} |
    When Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub "{hub-name}" and scan barcodes:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    When Operator creates manifest for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" reservation on Implanted Manifest page
    Then Operator verifies that error react notification displayed:
      | top    | Error                                       |
      | bottom | POD and Manifest parcel count do not match. |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And Operator open Job Details for "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" job on Pickup Jobs page
    Then Operator verify Job Details values on Pickup Jobs page:
      | status                | SUCCESS |
      | scannedAtShipperCount | 0       |
      | scannedAtShippers     |         |
