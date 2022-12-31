@OperatorV2 @CoreV2 @PickupAppointment @EditPickupJobCalendarView
Feature: Edit pickup jobs on Pickup Jobs page calendar view

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob
  Scenario: Edit pickup appointment job - no edit icon - completed PA Job
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Operator start the route
    When API Operator add route to appointment pickup job using data below:
      | overwrite | false |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_LIST_OF_PICKUP_JOB_IDS[1]}        |
      | pickupAppointmentProofRequest | {"status":"completed","photo_urls":[]} |
    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "COMPLETED" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field
    Then Operator verify there is no Edit button in job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}"
    Then Operator verify there is no Delete button in job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}"

  @deletePickupJob
  Scenario: Edit pickup appointment job - no edit icon - failed PA Job
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Operator start the route
    When API Operator add route to appointment pickup job using data below:
      | overwrite | false |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_LIST_OF_PICKUP_JOB_IDS[1]}                                                            |
      | pickupAppointmentProofRequest | {"failure_reason_code_id": 9, "failure_reason_id": 1476,"status":"failed","photo_urls":[]} |
    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "FAILED" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field
    Then Operator verify there is no Edit button in job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}"
    Then Operator verify there is no Delete button in job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op