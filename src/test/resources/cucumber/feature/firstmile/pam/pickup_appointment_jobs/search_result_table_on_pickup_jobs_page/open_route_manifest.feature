@OperatorV2 @CoreV2 @PickupAppointment @SearchResultTable @OpenRouteManifest @CWF
Feature: open route manifest

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2 @RT
  Scenario: Open route manifest from PAM - Completed PA Job
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
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}    |
      | pickupAppointmentProofRequest | {"status":"completed","photo_urls":[]} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator search for "route id" = "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in pickup jobs table
    When Operator open Route Manifest of created route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" from Pickup Jobs page
    Then Operator verify waypoint at Route Manifest using data below:
      | status  | Success                                                                                                                                                                        |
      | address | {KEY_LIST_OF_CREATED_ADDRESSES[1].address1} {KEY_LIST_OF_CREATED_ADDRESSES[1].address2} {KEY_LIST_OF_CREATED_ADDRESSES[1].country} {KEY_LIST_OF_CREATED_ADDRESSES[1].postcode} |
    And Operator verifies route detail information below on Route Manifest page:
      | Route ID    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | Driver ID   | {driver-id}                        |
      | Driver Name | {driver-name}                      |

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Open route manifest from PAM - Failed PA Job
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
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                                                                   |
      | pickupAppointmentProofRequest | {"failure_reason_code_id": {failure-reason-code-id-1},"failure_reason_id": {failure-reason-id-1},"status": "failed","photo_urls": []} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator search for "route id" = "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in pickup jobs table
    When Operator open Route Manifest of created route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" from Pickup Jobs page
    Then Operator verify waypoint at Route Manifest using data below:
      | status  | Fail                                                                                                                                                                           |
      | address | {KEY_LIST_OF_CREATED_ADDRESSES[1].address1} {KEY_LIST_OF_CREATED_ADDRESSES[1].address2} {KEY_LIST_OF_CREATED_ADDRESSES[1].country} {KEY_LIST_OF_CREATED_ADDRESSES[1].postcode} |
    And Operator verifies route detail information below on Route Manifest page:
      | Route ID    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | Driver ID   | {driver-id}                        |
      | Driver Name | {driver-name}                      |

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Open route manifest from PAM - Cancelled PA Job
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
    And API Control - Operator delete pickup appointment job with job id "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator search for "route id" = "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in pickup jobs table
    When Operator open Route Manifest of created route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" from Pickup Jobs page
    Then Operator verify waypoint at Route Manifest using data below:
      | status  | Cancel                                                                                                                                                                         |
      | address | {KEY_LIST_OF_CREATED_ADDRESSES[1].address1} {KEY_LIST_OF_CREATED_ADDRESSES[1].address2} {KEY_LIST_OF_CREATED_ADDRESSES[1].country} {KEY_LIST_OF_CREATED_ADDRESSES[1].postcode} |
    And Operator verifies route detail information below on Route Manifest page:
      | Route ID    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | Driver ID   | {driver-id}                        |
      | Driver Name | {driver-name}                      |

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Open route manifest from PAM - Routed PA Job
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
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator search for "route id" = "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in pickup jobs table
    When Operator open Route Manifest of created route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" from Pickup Jobs page
    Then Operator verify waypoint at Route Manifest using data below:
      | status  | Pending                                                                                                                                                                        |
      | address | {KEY_LIST_OF_CREATED_ADDRESSES[1].address1} {KEY_LIST_OF_CREATED_ADDRESSES[1].address2} {KEY_LIST_OF_CREATED_ADDRESSES[1].country} {KEY_LIST_OF_CREATED_ADDRESSES[1].postcode} |
    And Operator verifies route detail information below on Route Manifest page:
      | Route ID    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | Driver ID   | {driver-id}                        |
      | Driver Name | {driver-name}                      |


  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Open route manifest from PAM - In Progress PA Job
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
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator search for "route id" = "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in pickup jobs table
    When Operator open Route Manifest of created route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" from Pickup Jobs page
    Then Operator verify waypoint at Route Manifest using data below:
      | status  | Pending                                                                                                                                                                        |
      | address | {KEY_LIST_OF_CREATED_ADDRESSES[1].address1} {KEY_LIST_OF_CREATED_ADDRESSES[1].address2} {KEY_LIST_OF_CREATED_ADDRESSES[1].country} {KEY_LIST_OF_CREATED_ADDRESSES[1].postcode} |
    And Operator verifies route detail information below on Route Manifest page:
      | Route ID    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | Driver ID   | {driver-id}                        |
      | Driver Name | {driver-name}                      |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op