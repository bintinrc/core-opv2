@OperatorV2 @CoreV2 @PickupAppointment @PAJobsUpdateRoute
Feature: update route on pickup jobs page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Add route for single pickup job - Routed
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Edit PA job page
    And Operator clicks update route button on Edit PA job page
    Then Operator verifies update route successful message below on Edit PA job page:
      | Route updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" on Edit PA job page
    And Operator verifies PA job status is "Routed" on Edit PA job page

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Add route for single pickup job - In progress
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Driver "{driver-id}" Starts the route
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Edit PA job page
    And Operator clicks update route button on Edit PA job page
    Then Operator verifies update route successful message below on Edit PA job page:
      | Route updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Edit PA job page
    And Operator verifies PA job status is "In Progress" on Edit PA job page

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Update Route for Single Job - Routed
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects route "{KEY_LIST_OF_CREATED_ROUTES[2].id}" on Edit PA job page
    And Operator clicks update route button on Edit PA job page
    Then Operator verifies update route successful message below on Edit PA job page:
      | Route updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTES[2].id}" on Edit PA job page
    And Operator verifies PA job status is "Routed" on Edit PA job page

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Update Route for Single Job - In progress
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Driver "{driver-id}" Starts the route
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Driver "{driver-id}" Starts the route
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects route "{KEY_LIST_OF_CREATED_ROUTES[2].id}" on Edit PA job page
    And Operator clicks update route button on Edit PA job page
    Then Operator verifies update route successful message below on Edit PA job page:
      | Route updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTES[2].id}" on Edit PA job page
    And Operator verifies PA job status is "In Progress" on Edit PA job page

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Update Route for Single Job - Routed - Archived
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When API Operator archives routes:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects route "{KEY_LIST_OF_CREATED_ROUTES[2].id}" on Edit PA job page
    And Operator clicks update route button on Edit PA job page
    Then Operator verifies update route successful message below on Edit PA job page:
      | Route updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTES[2].id}" on Edit PA job page
    And Operator verifies PA job status is "Routed" on Edit PA job page

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Update Route for Single Job - In progress - Archived
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Driver "{driver-id}" Starts the route
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When API Operator archives routes:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Driver "{driver-id}" Starts the route
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects route "{KEY_LIST_OF_CREATED_ROUTES[2].id}" on Edit PA job page
    And Operator clicks update route button on Edit PA job page
    Then Operator verifies update route successful message below on Edit PA job page:
      | Route updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTES[2].id}" on Edit PA job page
    And Operator verifies PA job status is "In Progress" on Edit PA job page

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Update Route for Single Job - Start the route
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    Then Operator verifies PA job status is "Routed" on Edit PA job page
    When API Driver "{driver-id}" Starts the route
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Edit PA job page
    And Operator verifies PA job status is "In Progress" on Edit PA job page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op