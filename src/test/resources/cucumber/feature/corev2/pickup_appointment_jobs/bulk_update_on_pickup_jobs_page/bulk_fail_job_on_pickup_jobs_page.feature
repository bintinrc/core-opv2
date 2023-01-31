@OperatorV2 @CoreV2 @PickupAppointment @BulkFailPickupJobs @CWF
Feature: bulk fail job on pickup jobs page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario:Bulk Update PA Job - Fail Job - no proof
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[2].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page
    Then Operator check 2 route with id = "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator check 2 driver with name = "{KEY_LIST_OF_CREATED_ROUTES[1].driver.firstName}"
    Then Operator check 2 tags with name = "Routed"
    Given  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    And Operator clicks "Fail job" button on Pickup Jobs page
    And Operator click select fail reason on bulk fail modal for jobId = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    When Operator select from failure drop down number = "1", failure reason = "Ninja Point - Delivery Parcel Damaged"
    When Operator click proceed fail on pickup appointment job
    And Operator click select fail reason on bulk fail modal for jobId = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}"
    When Operator select from failure drop down number = "1", failure reason = "Ninja Point - Delivery Parcel Damaged"
    When Operator click proceed fail on pickup appointment job
    When Operator click on Submit button on bulk fail modal
    Then Operator verify notification is displayed with message = "Bulk fail job successful" and description below:
      | description    |
      | 2 jobs updated |
    Then Operator check 2 tags with name = "Failed"
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has "0" proof in proof_photos table
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" has "0" proof in proof_photos table

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario:Bulk Update PA Job - Fail Job - with proof
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[2].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page
    Then Operator check 2 route with id = "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator check 2 driver with name = "{KEY_LIST_OF_CREATED_ROUTES[1].driver.firstName}"
    Then Operator check 2 tags with name = "Routed"
    Given  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    And Operator clicks "Fail job" button on Pickup Jobs page
    And Operator click select fail reason on bulk fail modal for jobId = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    When Operator select from failure drop down number = "1", failure reason = "Ninja Point - Delivery Parcel Damaged"
    When Operator upload Fail proof photo on pickup appointment job
    When Operator click proceed fail on pickup appointment job
    And Operator click select fail reason on bulk fail modal for jobId = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}"
    When Operator select from failure drop down number = "1", failure reason = "Ninja Point - Delivery Parcel Damaged"
    When Operator upload Fail proof photo on pickup appointment job
    When Operator click proceed fail on pickup appointment job
    When Operator click on Submit button on bulk fail modal
    Then Operator verify notification is displayed with message = "Bulk fail job successful" and description below:
      | description    |
      | 2 jobs updated |
    Then Operator check 2 tags with name = "Failed"
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has "1" proof in proof_photos table
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" has "1" proof in proof_photos table


  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario:Bulk Update PA Job - Fail Job - Apply to all
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[2].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page
    Then Operator check 2 route with id = "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator check 2 driver with name = "{KEY_LIST_OF_CREATED_ROUTES[1].driver.firstName}"
    Then Operator check 2 tags with name = "Routed"
    Given  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    And Operator clicks "Fail job" button on Pickup Jobs page
    And Operator click select fail reason on bulk fail modal for jobId = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    When Operator select from failure drop down number = "1", failure reason = "Ninja Point - Delivery Parcel Damaged"
    When Operator click proceed fail on pickup appointment job
    And Operator click apply fail reason for all in bulk fail modal for jobId = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    When Operator click on Submit button on bulk fail modal
    Then Operator verify notification is displayed with message = "Bulk fail job successful" and description below:
      | description    |
      | 2 jobs updated |
    Then Operator check 2 tags with name = "Failed"
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" has "0" proof in proof_photos table
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" status = "FAILED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" has "0" proof in proof_photos table

  @deletePickupJob @DeleteShipperAddressCommonV2 @RT
  Scenario:Bulk Update PA Job - Fail Job - Ready for Routing
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page
    Then Operator check 2 tags with name = "Ready for Routing"
    Given  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    And Operator clicks "Fail job" button on Pickup Jobs page
    And Operator check Error message is shown in fail modal for jobId = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    And Operator check Error message is shown in fail modal for jobId = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}"
    When Operator check Submit button disabled on bulk fail modal