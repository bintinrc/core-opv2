@OperatorV2 @FirstMile @PickupAppointment @ProofOfPickUp
Feature: Force Fail Single Pickup Job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Proof of pickup - Success Pickup by Driver - PA Job
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {normal-shipper-pickup-appointment-1-client-id}                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {normal-shipper-pickup-appointment-1-client-secret}                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-3-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-3-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When DB Control - get pickup appointment job id from order id "{KEY_CREATED_ORDER_ID}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    And DB Core - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
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
    And API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                         |
      | waypointId | {KEY_WAYPOINT_ID}                                                          |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Then Operator verifies the Table on Pickup Jobs Page
    And Operator click on button to view job details on Pickup Appointment Job page
    Then QA verify values on Pickup Jobs Details page are shown
      | shipperId  | {normal-shipper-pickup-appointment-1-global-id}  |
      | jobId      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}              |
      | waypointId | {KEY_WAYPOINT_ID}                                |
      | time       | {date: 0 days ago, yyyy-MM-dd}                   |
      | status     | SUCCESS                                          |
    And Operator click on button to view image on Pickup Appointment Job page
    And QA verify signature image on Pickup Appointment Job page
    And Operator click on button to cancel image on Pickup Appointment Job page
    And Operator click Download Parcel List button in Job Details modal on Pickup Jobs page
    And Verify that csv file is downloaded on pick up job page with filename for Job Id
      |  Job Id     |  {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}             |


  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Proof of pickup - Fail Pickup by Driver - PA Job
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {normal-shipper-pickup-appointment-1-client-id}                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {normal-shipper-pickup-appointment-1-client-secret}                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-3-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-3-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When DB Control - get pickup appointment job id from order id "{KEY_CREATED_ORDER_ID}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    And DB Core - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    And API Driver - Driver read routes:
      | driverId        | {driver-id}                        |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                         |
      | waypointId      | {KEY_WAYPOINT_ID}                                                          |
      | parcels         | [{ "tracking_id": "{KEY_CREATED_ORDER_TRACKING_ID}", "action": "FAIL"}]    |
      | routes          | KEY_DRIVER_ROUTES                                                          |
      | jobType         | PICKUP_APPOINTMENT                                                         |
      | jobAction       | FAIL                                                                       |
      | jobMode         | PICK_UP                                                                    |
      | failureReasonId | {failure-reason-id-1}                                                      |
    And API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_WAYPOINT_ID}                                                               |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Then Operator verifies the Table on Pickup Jobs Page
    And Operator click on button to view job details on Pickup Appointment Job page
    Then QA verify values on Pickup Jobs Details page are shown
      | shipperId  | {normal-shipper-pickup-appointment-1-global-id}  |
      | jobId      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}              |
      | waypointId | {KEY_WAYPOINT_ID}                                |
      | time       | {date: 0 days ago, yyyy-MM-dd}                   |
      | status     | FAIL                                             |
    And Operator waits for 10 seconds
    And Operator click on button to download image signature on Pickup Appointment Job page

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Proof of pickup - Multiple proof - PA Job
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {normal-shipper-pickup-appointment-1-client-id}                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {normal-shipper-pickup-appointment-1-client-secret}                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-3-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-3-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When DB Control - get pickup appointment job id from order id "{KEY_CREATED_ORDER_ID}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    And DB Core - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {driver-id}                        |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                         |
      | waypointId      | {KEY_WAYPOINT_ID}                                                          |
      | parcels         | [{ "tracking_id": "{KEY_CREATED_ORDER_TRACKING_ID}", "action": "FAIL"}]    |
      | routes          | KEY_DRIVER_ROUTES                                                          |
      | jobType         | PICKUP_APPOINTMENT                                                         |
      | jobAction       | FAIL                                                                       |
      | jobMode         | PICK_UP                                                                    |
      | failureReasonId | {failure-reason-id-1}                                                      |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                         |
      | waypointId | {KEY_WAYPOINT_ID}                                                          |
      | parcels    | [{ "tracking_id": "{KEY_CREATED_ORDER_TRACKING_ID}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                          |
      | jobType    | PICKUP_APPOINTMENT                                                         |
      | jobAction  | SUCCESS                                                                    |
      | jobMode    | PICK_UP                                                                    |
    And API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                              |
      | waypointId | {KEY_WAYPOINT_ID}                                                               |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Then Operator verifies the Table on Pickup Jobs Page
    And Operator click on button to view job details on Pickup Appointment Job page
    Then QA verify values on Pickup Jobs Details page are shown
      | shipperId  | {normal-shipper-pickup-appointment-1-global-id}  |
      | jobId      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}              |
      | waypointId | {KEY_WAYPOINT_ID}                                |
      | time       | {date: 0 days ago, yyyy-MM-dd}                   |
      | status     | FAIL                                             |
    And Operator waits for 10 seconds
    And Operator click on button to download image signature on Pickup Appointment Job page
    And Operator click on button to view second pick up proof on Pickup Appointment Job page
    Then QA verify values on Pickup Jobs Details page are shown
      | shipperId  | {normal-shipper-pickup-appointment-1-global-id}  |
      | jobId      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}              |
      | waypointId | {KEY_WAYPOINT_ID}                                |
      | time       | {date: 0 days ago, yyyy-MM-dd}                   |
      | status     | SUCCESS                                          |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op