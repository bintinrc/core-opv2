@OperatorV2 @CoreV2 @PickupAppointment @UpdatePAJobsFromDriverApp @CWF
Feature: update pickup jobs from driver apps

#  @LaunchBrowser @ShouldAlwaysRun
#  Scenario: Login to Operator Portal V2
#    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"


  Scenario: Success pickup jobs on Driver Apps - Order with pickup
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {normal-shipper-pickup-appointment-1-client-id}                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {normal-shipper-pickup-appointment-1-client-secret}                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-3-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-3-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When DB Control - get pickup appointment job id from order id "{KEY_CREATED_ORDER_ID}"
    And DB Core - get waypoint id for job id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
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


  @RT
  Scenario: Success pickup jobs on Driver Apps - Order with pickup
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {normal-shipper-pickup-appointment-1-client-id}                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {normal-shipper-pickup-appointment-1-client-secret}                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-3-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-3-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When DB Control - get pickup appointment job id from order id "{KEY_CREATED_ORDER_ID}"
    When shipper print id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {normal-shipper-pickup-appointment-1-client-id}                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {normal-shipper-pickup-appointment-1-client-secret}                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-3-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-3-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When DB Control - get pickup appointment job id from order id "{KEY_CREATED_ORDER_ID}"
    When shipper print id "{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}"
  API Shipper create multiple V4 orders using data below: