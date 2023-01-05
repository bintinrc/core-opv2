@OperatorV2 @CoreV2 @PickupAppointment @UpdateRoute
Feature: update route on pickup jobs page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddress @DeleteOrArchiveRoute
  Scenario:Add route for single pickup job - Routed
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id}|
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects route "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" on Edit PA job page
    And Operator clicks update route button on Edit PA job page
    Then Operator verifies update route successful message below on Edit PA job page:
    |Route updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" on Edit PA job page
    And Operator verifies PA job status is "Routed" on Edit PA job page

  @deletePickupJob @DeleteShipperAddress @DeleteOrArchiveRoute
  Scenario:Add route for single pickup job - In progress
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id}|
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    And API Operator start the route
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects route "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" on Edit PA job page
    And Operator clicks update route button on Edit PA job page
    Then Operator verifies update route successful message below on Edit PA job page:
      |Route updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTE_ID[1]}" on Edit PA job page
    And Operator verifies PA job status is "In Progress" on Edit PA job page

  @deletePickupJob @DeleteShipperAddress @DeleteOrArchiveRoute
  Scenario:Update Route for Single Job - Routed
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id}|
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Control - Operator add route to appointment pickup job using data below:
      | jobId     | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | routeId   | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | overwrite | false |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects route "{KEY_LIST_OF_CREATED_ROUTE_ID[2]}" on Edit PA job page
    And Operator clicks update route button on Edit PA job page
    Then Operator verifies update route successful message below on Edit PA job page:
      |Route updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTE_ID[2]}" on Edit PA job page
    And Operator verifies PA job status is "Routed" on Edit PA job page

  @deletePickupJob @DeleteShipperAddress @DeleteOrArchiveRoute
  Scenario:Update Route for Single Job - In progress
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id}|
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    And API Operator start the route
    When API Control - Operator add route to appointment pickup job using data below:
      | jobId     | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | routeId   | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | overwrite | false |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    And API Operator start the route
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects route "{KEY_LIST_OF_CREATED_ROUTE_ID[2]}" on Edit PA job page
    And Operator clicks update route button on Edit PA job page
    Then Operator verifies update route successful message below on Edit PA job page:
      |Route updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And Operator verifies current route is updated to "{KEY_LIST_OF_CREATED_ROUTE_ID[2]}" on Edit PA job page
    And Operator verifies PA job status is "In Progress" on Edit PA job page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op