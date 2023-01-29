@OperatorV2 @CoreV2 @PickupAppointment @BulkUpdatePickupJobsRemoveRoute @CWF
Feature: bulk remove route on pickup jobs page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"


  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario:Bulk Update PA Job - Remove route - Routed
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
    And Operator clicks "Remove route" button on Pickup Jobs page
    And Operator click on submit button in bulk remove route modal
    Then Operator check 0 route with id = "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator check 0 driver with name = "{KEY_LIST_OF_CREATED_ROUTES[1].driver.firstName}"
    Then Operator check 0 tags with name = "Routed"
    Then Operator check 2 tags with name = "Ready for Routing"


  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario:Bulk Update PA Job - Remove route - In Progress
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
    Given API Driver - Driver login with username "{driver-username}" and "{driver-password}"
    When API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
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
    Then Operator check 2 tags with name = "In Progress"
    Given  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    And Operator clicks "Remove route" button on Pickup Jobs page
    And Operator click on submit button in bulk remove route modal
    Then Operator check 0 route with id = "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then Operator check 0 driver with name = "{KEY_LIST_OF_CREATED_ROUTES[1].driver.firstName}"
    Then Operator check 0 tags with name = "In Progress"
    Then Operator check 2 tags with name = "Ready for Routing"


  @deletePickupJob @DeleteShipperAddressCommonV2 @RT
  Scenario:Disabled Bulk Update PA Job - Remove route - Ready for Routing
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
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    And Operator check Remove route button is disabled on Pickup Jobs page
