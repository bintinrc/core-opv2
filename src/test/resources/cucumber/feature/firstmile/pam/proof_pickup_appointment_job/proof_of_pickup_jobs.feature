@OperatorV2 @FirstMile @PickupAppointment @ProofOfPickUp
Feature: Force Fail Single Pickup Job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddressCommonV2 @Debug
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
    And Operator click on button to view job details
    Then QA verify values on Pickup Jobs Details page are shown
      | shipperId  | {normal-shipper-pickup-appointment-1-global-id}  |
      | jobId      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}              |
      | waypointId | {KEY_WAYPOINT_ID}                                |
      | time       | {date: 0 days ago, yyyy-MM-dd}                   |
    And Operator click on button to view image
    And QA verify signature image
    And Operator click on button to cancel image
    And Operator click on button to download parcel list
    And Verify that csv file is downloaded in pick up job page with filename for Job Id
      |  Job Id |  {KEY_CONTROL_CREATED_PA_JOB_IDS[1]}   |


#      | jobServiceLevel | Premium, Standard                                 |
#      | jobStatus       | Ready for Routing, Routed, In Progress, Cancelled |

#    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
#    When Operator select the data range
#      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
#      | endDay   | {gradle-next-2-day-yyyy-MM-dd} |
#    When Operator click load selection on pickup jobs filter
#    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
#    When Operator click edit icon for Pickup job row
#    Then Operator check Fail button enabled in pickup job drawer
#    Then Operator check Success button enabled in pickup job drawer
#    When Operator click Fail button in pickup job drawer
#    When Operator select from failure drop down number = "1", failure reason = "Ninja Point - Delivery Parcel Damaged"
#    When Operator upload Fail proof photo on pickup appointment job
#    When Operator click proceed fail on pickup appointment job
#    Then Operator check pickup fail modal for job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has:
#      | Ninja Point - Delivery Parcel Damaged |
#    When Operator click submit button on pickup fail job
#    Then QA verify successful message is displayed with the jobID:
#      | notificationMessage | Fail job successful                 |
#      | jobID               | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
#    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "FAILED" ,in pickup_appointment_jobs table
#    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
#    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has "1" proof in proof_photos table



  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op