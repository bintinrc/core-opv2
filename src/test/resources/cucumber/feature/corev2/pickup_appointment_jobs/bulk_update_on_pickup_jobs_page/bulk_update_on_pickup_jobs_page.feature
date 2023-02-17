@OperatorV2 @CoreV2 @PickupAppointment @BulkUpdatePickupJobs
Feature: Pickup Appointment Job - Bulk update on pickup jobs page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  Scenario: Bulk select on Pickup Jobs page result table - select all shown
    When Operator goes to Pickup Jobs Page
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page

  Scenario: Bulk select on Pickup Jobs page result table - select all shown filtered
    When Operator goes to Pickup Jobs Page
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    And Operator filters on the table with values below:
      | status | Ready for Routing |
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page
    And Operator filters on the table with values below:
      | status | Clear All |
    Then Operator verify number of selected row is not updated


  Scenario: Bulk select on Pickup Jobs page result table - clear selection
    When Operator goes to Pickup Jobs Page
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page
    Given  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Clear Selection" button on Pickup Jobs page
    Then Operator verify the number of selected rows is "0"


  Scenario: Bulk select on Pickup Jobs page result table - display only selected
    When Operator goes to Pickup Jobs Page
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Display only selected" button on Pickup Jobs page
    Then Operator verify the number of selected rows is "1"

  @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario:Disabled Bulk Update PA Job - Terminated status - Cancelled
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
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    Then Operator verifies Bulk Update button is "enable" on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    Then Operator verifies the status of Bulk Update options below on Pickup Jobs page
      | Route ID     | disable |
      | Success job  | disable |
      | Remove route | disable |
      | Fail job     | disable |

  @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario:Disabled Bulk Update PA Job - Terminated status - Completed
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
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    Then Operator verifies Bulk Update button is "enable" on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    Then Operator verifies the status of Bulk Update options below on Pickup Jobs page
      | Route ID     | disable |
      | Success job  | disable |
      | Remove route | disable |
      | Fail job     | disable |

  @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario:Disabled Bulk Update PA Job - Terminated status - Failed
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
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    Then Operator verifies Bulk Update button is "enable" on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    Then Operator verifies the status of Bulk Update options below on Pickup Jobs page
      | Route ID     | disable |
      | Success job  | disable |
      | Remove route | disable |
      | Fail job     | disable |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op