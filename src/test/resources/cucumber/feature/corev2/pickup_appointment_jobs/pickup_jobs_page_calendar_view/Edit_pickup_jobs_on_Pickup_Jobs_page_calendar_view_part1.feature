@OperatorV2 @CoreV2 @PickupAppointment @EditPickupJobCalendarView
Feature: Edit pickup jobs on Pickup Jobs page calendar view

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddress
  Scenario: Edit pickup appointment job - no edit icon - completed PA Job
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Operator start the route
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                       |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":false} |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}    |
      | pickupAppointmentProofRequest | {"status":"completed","photo_urls":[]} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "COMPLETED" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in Shipper Address field
    Then Operator verify there is no Edit button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify there is no Delete button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"

  @deletePickupJob @DeleteShipperAddress
  Scenario: Edit pickup appointment job - no edit icon - failed PA Job
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Operator start the route
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                       |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":false} |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                        |
      | pickupAppointmentProofRequest | {"failure_reason_code_id": 9, "failure_reason_id": 1476,"status":"failed","photo_urls":[]} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "FAILED" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in Shipper Address field
    Then Operator verify there is no Edit button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify there is no Delete button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"

  @deletePickupJob @DeleteShipperAddress
  Scenario: Edit pickup appointment job - enable jobs priority
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                       |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":false} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in Shipper Address field
    And Operator click on edit button for pickup job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify Save button in disabled
    And Operator select Pickup job tag = "PRIOR" in Job Tags Field
    Then Operator verify Save button in enabled
    When Operator click Save button
    Then Operator verify notification is displayed with message = "Job updated" and description below:
      | description                    |
      | 09:00                          |
      | 12:00                          |
      | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator hover on job = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" edit button
    Then Operator check star icon on job = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" with status = "routed"
    Then Operator check tag = "PRIOR" is displayed on job
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "PRIOR" length = 1 in pickup_appointment_jobs_pickup_tags

  @deletePickupJob @DeleteShipperAddress
  Scenario: Edit pickup appointment job - disable jobs priority
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    And DB Control - get pickup tag id for tag name = "PRIOR"
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"},"tagIds":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id}        |
      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                       |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":false} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in Shipper Address field
    And Operator click on edit button for pickup job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify Save button in disabled
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "PRIOR" length = 1 in pickup_appointment_jobs_pickup_tags
    When Operator clear job tags input
    Then Operator verify Save button in enabled
    When Operator click Save button
    Then Operator verify notification is displayed with message = "Job updated" and description below:
      | description                    |
      | 09:00                          |
      | 12:00                          |
      | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator hover on job = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" edit button
    Then Operator check no star icon on job = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" with status = "routed"
    Then Operator check no tag = "PRIOR" is displayed on job
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "PRIOR" length = 0 in pickup_appointment_jobs_pickup_tags

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op