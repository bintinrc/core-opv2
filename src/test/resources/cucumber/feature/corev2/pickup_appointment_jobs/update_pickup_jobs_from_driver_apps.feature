@OperatorV2 @CoreV2 @PickupAppointment @UpdatePAJobsFromDriverApp
Feature: update pickup jobs from driver apps

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob
  Scenario: Success pickup jobs on Driver Apps - Order with pickup
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {normal-shipper-pickup-appointment-1-client-id}                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {normal-shipper-pickup-appointment-1-client-secret}                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-3-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-3-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When DB Control - get pickup appointment job id from order id "{KEY_CREATED_ORDER_ID}"
    When shipper print id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    And DB Core - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When shipper print id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    And API Driver - Driver read routes:
      | driverId        | {driver-id}                        |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                         |
      | waypointId | {KEY_WAYPOINT_ID}                                                          |
      | parcels    | [{ "tracking_id": "{KEY_CREATED_ORDER_TRACKING_ID}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                          |
      | jobType    | PICKUP_APPOINTMENT                                                         |
      | jobAction  | SUCCESS                                                                    |
      | jobMode    | PICK_UP                                                                    |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator click edit icon for Pickup job row
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}" status = "COMPLETED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}" has proof in proof_jobs table


  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Success pickup jobs on Driver Apps - PA Job
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When shipper print id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    And DB Core - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                       |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":false} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "ROUTED" ,in pickup_appointment_jobs table
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {driver-id}                        |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                         |
      | waypointId | {KEY_WAYPOINT_ID}                                                          |
      | parcels    | [{ "tracking_id": "{KEY_CREATED_ORDER_TRACKING_ID}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                          |
      | jobType    | PICKUP_APPOINTMENT                                                         |
      | jobAction  | SUCCESS                                                                    |
      | jobMode    | PICK_UP                                                                    |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator click edit icon for Pickup job row
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "COMPLETED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table

  @DeleteShipperAddressCommonV2   @deletePickupJob
  Scenario: Fail pickup jobs on Driver Apps - PA Job
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When shipper print id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    And DB Core - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                       |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":false} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "ROUTED" ,in pickup_appointment_jobs table
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {driver-id}                        |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                              |
      | waypointId      | {KEY_WAYPOINT_ID}                                                                               |
      | routes          | KEY_DRIVER_ROUTES                                                                               |
      | jobType         | PICKUP_APPOINTMENT                                                                              |
      | parcels         | [{ "tracking_id": "{KEY_CREATED_ORDER_TRACKING_ID}", "action":"FAIL","failure_reason_id":1472}] |
      | jobAction       | FAIL                                                                                            |
      | jobMode         | PICK_UP                                                                                         |
      | failureReasonId | 1472                                                                                            |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator click edit icon for Pickup job row
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table

  @deletePickupJob
  Scenario: Fail pickup jobs on Driver Apps - Order with pickup
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {normal-shipper-pickup-appointment-1-client-id}                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {normal-shipper-pickup-appointment-1-client-secret}                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-3-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-3-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When DB Control - get pickup appointment job id from order id "{KEY_CREATED_ORDER_ID}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    And DB Core - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When shipper print id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    And API Driver - Driver read routes:
      | driverId        | {driver-id}                        |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                              |
      | waypointId      | {KEY_WAYPOINT_ID}                                                                               |
      | routes          | KEY_DRIVER_ROUTES                                                                               |
      | jobType         | PICKUP_APPOINTMENT                                                                              |
      | failureReasonId | 1472                                                                                            |
      | parcels         | [{ "tracking_id": "{KEY_CREATED_ORDER_TRACKING_ID}", "action":"FAIL","failure_reason_id":1472}] |
      | jobAction       | FAIL                                                                                            |
      | jobMode         | PICK_UP                                                                                         |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator click edit icon for Pickup job row
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}" has proof in proof_jobs table

