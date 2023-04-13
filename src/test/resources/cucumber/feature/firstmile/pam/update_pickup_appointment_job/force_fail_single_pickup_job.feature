@OperatorV2 @CoreV2 @PickupAppointment @ForceFailSinglePickupJob @ForceFailPA
Feature: Force Fail Single Pickup Job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddressCommonV2 @HappyPath
  Scenario: Force fail single pickup job - Routed - with photo
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
      | endDay   | {gradle-next-2-day-yyyy-MM-dd} |
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Fail button enabled in pickup job drawer
    Then Operator check Success button enabled in pickup job drawer
    When Operator click Fail button in pickup job drawer
    When Operator select from failure drop down number = "1", failure reason = "Ninja Point - Delivery Parcel Damaged"
    When Operator upload Fail proof photo on pickup appointment job
    When Operator click proceed fail on pickup appointment job
    Then Operator check pickup fail modal for job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has:
      | Ninja Point - Delivery Parcel Damaged |
    When Operator click submit button on pickup fail job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Fail job successful                 |
      | jobID               | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has "1" proof in proof_photos table


  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Force fail single pickup job - In progress - with photo
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "IN_PROGRESS" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-2-day-yyyy-MM-dd} |
    When Operator select only In progress job status, on pickup jobs filter
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Fail button enabled in pickup job drawer
    Then Operator check Success button enabled in pickup job drawer
    When Operator click Fail button in pickup job drawer
    When Operator select from failure drop down number = "1", failure reason = "Ninja Point - Delivery Parcel Damaged"
    When Operator upload Fail proof photo on pickup appointment job
    When Operator click proceed fail on pickup appointment job
    Then Operator check pickup fail modal for job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has:
      | Ninja Point - Delivery Parcel Damaged |
    When Operator click submit button on pickup fail job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Fail job successful                 |
      | jobID               | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has "1" proof in proof_photos table

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Force fail single pickup job - Routed - no photo
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
      | endDay   | {gradle-next-2-day-yyyy-MM-dd} |
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Fail button enabled in pickup job drawer
    Then Operator check Success button enabled in pickup job drawer
    When Operator click Fail button in pickup job drawer
    When Operator select from failure drop down number = "1", failure reason = "Ninja Point - Delivery Parcel Damaged"
    When Operator click proceed fail on pickup appointment job
    Then Operator check pickup fail modal for job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has:
      | Ninja Point - Delivery Parcel Damaged |
    When Operator click submit button on pickup fail job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Fail job successful                 |
      | jobID               | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has "0" proof in proof_photos table


  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Force fail single pickup job - In progress - no photo
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "IN_PROGRESS" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-2-day-yyyy-MM-dd} |
    When Operator select only In progress job status, on pickup jobs filter
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Fail button enabled in pickup job drawer
    Then Operator check Success button enabled in pickup job drawer
    When Operator click Fail button in pickup job drawer
    When Operator select from failure drop down number = "1", failure reason = "Ninja Point - Delivery Parcel Damaged"
    When Operator click proceed fail on pickup appointment job
    Then Operator check pickup fail modal for job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has:
      | Ninja Point - Delivery Parcel Damaged |
    When Operator click submit button on pickup fail job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Fail job successful                 |
      | jobID               | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has "0" proof in proof_photos table

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Force fail single pickup job - Routed - route is archived
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
    When API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-2-day-yyyy-MM-dd} |
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Tool tip is hidden
    When Operator hover on Fail button in pickup job drawer
    Then Operator check Fail button disabled in pickup job drawer
    Then Operator check Tool tip is shown

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Force fail single pickup job - In progress - route is archived
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-2-day-yyyy-MM-dd} |
    When Operator select only In progress job status, on pickup jobs filter
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Tool tip is hidden
    When Operator hover on Fail button in pickup job drawer
    Then Operator check Fail button disabled in pickup job drawer
    Then Operator check Tool tip is shown

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op