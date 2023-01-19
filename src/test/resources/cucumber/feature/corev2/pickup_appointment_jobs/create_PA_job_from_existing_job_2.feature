@OperatorV2 @CoreV2 @PickupAppointment @createJobFromExistingJob2
Feature: Create pickup jobs from existing job part 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddress
  Scenario:Create new pickup job from existing job on Pickup Jobs page - create/edit jobs button - multiday date range
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    And  Operator clicks "Create / edit job" button on Pickup Jobs page
    Then Operator verifies Existing upcoming job page
    Given Operator creates new PA Job on Existing Upcoming Job page:
      | startDate | {date: 2 days next, dd/MM/yyyy} |
      | endDate   | {date: 3 days next, dd/MM/yyyy} |
      | timeRange | 18:00 - 22:00                   |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | timeSlot | {date: 2 days next, yyyy-MM-dd} - {gradle-next-3-day-yyyy-MM-dd} 18:00 - 22:00 |

  @deletePickupJob @DeleteShipperAddress
  Scenario:Create new pickup job from existing job on Pickup Jobs page - create/edit jobs button - bulk job
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 2 rows on Pickup Jobs page
    And  Operator clicks "Create / edit job" button on Pickup Jobs page
    Then Operator verifies Existing upcoming job page
    Given Operator creates new PA Job on Existing Upcoming Job page:
      | startDate | {date: 2 days next, dd/MM/yyyy} |
      | endDate   | {date: 3 days next, dd/MM/yyyy} |
      | timeRange | 18:00 - 22:00                   |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | timeSlot | {date: 2 days next, yyyy-MM-dd} - {gradle-next-3-day-yyyy-MM-dd} 18:00 - 22:00 |

  @deletePickupJob @DeleteShipperAddress
  Scenario:Create new pickup job from existing job on Pickup Jobs page - job drawer
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator clicks Create new job on Edit PA job page
    Then Operator verifies Existing upcoming job page
    Given Operator creates new PA Job on Existing Upcoming Job page:
      | startDate | {date: 1 days next, dd/MM/yyyy} |
      | endDate   | {date: 1 days next, dd/MM/yyyy} |
      | timeRange | 12:00 - 15:00                   |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | readyBy        | 12:00                          |
      | latestBy       | 15:00                          |
      | followingDates | {gradle-next-1-day-yyyy-MM-dd} |


  @deletePickupJob @DeleteShipperAddress
  Scenario:Create new pickup job from existing job on Pickup Jobs page - job drawer - single creation
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 2 rows on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator clicks Create new job on Edit PA job page
    Then Operator verifies Existing upcoming job page
    Given Operator creates new PA Job on Existing Upcoming Job page:
      | startDate | {date: 1 days next, dd/MM/yyyy} |
      | endDate   | {date: 1 days next, dd/MM/yyyy} |
      | timeRange | 12:00 - 15:00                   |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | readyBy        | 12:00                          |
      | latestBy       | 15:00                          |
      | followingDates | {gradle-next-1-day-yyyy-MM-dd} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op