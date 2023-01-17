@OperatorV2 @CoreV2 @PickupAppointment @ForceSuccessSinglePickupJob
Feature: Force Success Single Pickup Job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Force Success Single Pickup Job Routed With Photo
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "ROUTED" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Fail button enabled in pickup job drawer
    Then Operator check Success button enabled in pickup job drawer
    When Operator click success button in pickup job drawer
    When Operator upload Success proof photo on pickup appointment job
    When Operator click submit button on pickup success job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Success job successful              |
      | jobID               | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "COMPLETED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has "1" proof in proof_photos table

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Force Success Single Pickup Job In Progress With Photo
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Operator start the route
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "IN_PROGRESS" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator select only In progress job status, on pickup jobs filter
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Fail button enabled in pickup job drawer
    Then Operator check Success button enabled in pickup job drawer
    When Operator click success button in pickup job drawer
    When Operator upload Success proof photo on pickup appointment job
    When Operator click submit button on pickup success job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Success job successful              |
      | jobID               | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "COMPLETED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has "1" proof in proof_photos table

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Force Success Single Pickup Job Routed With No Photo
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "ROUTED" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Fail button enabled in pickup job drawer
    Then Operator check Success button enabled in pickup job drawer
    When Operator click success button in pickup job drawer
    When Operator click submit button on pickup success job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Success job successful              |
      | jobID               | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "COMPLETED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has no proof in proof_photos table

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Force Success Single Pickup Job In Progress With no Photo
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Operator start the route
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "IN_PROGRESS" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator select only In progress job status, on pickup jobs filter
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Fail button enabled in pickup job drawer
    Then Operator check Success button enabled in pickup job drawer
    When Operator click success button in pickup job drawer
    When Operator click submit button on pickup success job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Success job successful              |
      | jobID               | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "COMPLETED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has no proof in proof_photos table


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op