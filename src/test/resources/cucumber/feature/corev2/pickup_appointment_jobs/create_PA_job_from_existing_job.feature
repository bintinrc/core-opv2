@OperatorV2 @CoreV2 @PickupAppointment @createJobFromExistingJob
Feature: Create pickup jobs from existing job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob
  Scenario:Create new pickup job from existing job on Pickup Jobs page - create/edit jobs button
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    And  Operator clicks "Create / edit job" button on Pickup Jobs page
    Then Operator verifies Existing upcoming job page
    Given Operator creates new PA Job on Existing Upcoming Job page:
      | startDate      | {date: 3 days next, dd/MM/yyyy} |
      | endDate        | {date: 3 days next, dd/MM/yyyy} |
      | timeRange      | 18:00 - 22:00               |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | timeSlot        | {date: 3 days next, yyyy-MM-dd} - {date: 3 days next, yyyy-MM-dd} 18:00 - 22:00 |

  @deletePickupJob
  Scenario:Create new pickup job from existing job on Pickup Jobs page - create/edit jobs button - Apply existing time slots
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    And  Operator clicks "Create / edit job" button on Pickup Jobs page
    Then Operator verifies Existing upcoming job page
    Given Operator creates new PA Job on Existing Upcoming Job page:
      | startDate          | {date: 3 days next, dd/MM/yyyy} |
      | endDate            | {date: 3 days next, dd/MM/yyyy} |
      | useExistingTimeslot| true              |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | timeSlot        | {date: 3 days next, yyyy-MM-dd} - {date: 3 days next, yyyy-MM-dd} 09:00 - 12:00 |

  @deletePickupJob
  Scenario:Create new pickup job from existing job on Pickup Jobs page - create/edit jobs button - apply job tag
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    And  Operator clicks "Create / edit job" button on Pickup Jobs page
    Then Operator verifies Existing upcoming job page
    Given Operator creates new PA Job on Existing Upcoming Job page:
      | startDate      | {date: 3 days next, dd/MM/yyyy} |
      | endDate        | {date: 3 days next, dd/MM/yyyy} |
      | timeRange      | 18:00 - 22:00                   |
      | pickupTag         | DUPE1                           |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | timeSlot        | {date: 3 days next, yyyy-MM-dd} - {date: 3 days next, yyyy-MM-dd} 18:00 - 22:00 |
      | pickupTag          | DUPE1                           |

  @deletePickupJob
  Scenario:Create new pickup job from existing job on Pickup Jobs page - create/edit jobs button - premium shipper - overlaping date and time
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{premium-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 1 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 1 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    And  Operator clicks "Create / edit job" button on Pickup Jobs page
    Then Operator verifies Existing upcoming job page
    Given Operator creates new PA Job on Existing Upcoming Job page:
      | startDate      | {date: 1 days next, dd/MM/yyyy} |
      | endDate        | {date: 1 days next, dd/MM/yyyy} |
      | timeRange      | 09:00 - 12:00                   |
      | pickupTag      | DUPE1                           |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | timeSlot        | {date: 1 days next, yyyy-MM-dd} - {date: 1 days next, yyyy-MM-dd} 09:00 - 12:00 |
      | pickupTag          | DUPE1                           |

  @deletePickupJob
  Scenario:Create new pickup job from existing job on Pickup Jobs page - create/edit jobs button - premium shipper - match date and time with existing PA Job
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{premium-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    And  Operator clicks "Create / edit job" button on Pickup Jobs page
    Then Operator verifies Existing upcoming job page
    Given Operator creates new PA Job on Existing Upcoming Job page:
      | startDate      | {date: 3 days next, dd/MM/yyyy} |
      | endDate        | {date: 3 days next, dd/MM/yyyy} |
      | timeRange      | 09:00 - 12:00                   |
      | pickupTag      | DUPE1                           |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | timeSlot        | {date: 3 days next, yyyy-MM-dd} - {date: 3 days next, yyyy-MM-dd} 09:00 - 12:00 |
      | pickupTag          | DUPE1                           |

  @deletePickupJob
  Scenario:Create new pickup job from existing job on Pickup Jobs page - create/edit jobs button - standard shipper - overlaping date
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal--shipper-pickup-appointment-1-address-id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{date: 3 days next, yyyy-MM-dd}T09:00:00+08:00", "latest":"{date: 3 days next, yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOBS[1].id}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    And  Operator clicks "Create / edit job" button on Pickup Jobs page
    Then Operator verifies Existing upcoming job page
    Given Operator creates new PA Job on Existing Upcoming Job page:
      | startDate      | {date: 3 days next, dd/MM/yyyy} |
      | endDate        | {date: 3 days next, dd/MM/yyyy} |
      | timeRange      | 09:00 - 12:00                   |
      | pickupTag      | DUPE1                           |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | timeSlot        | {date: 3 days next, yyyy-MM-dd} - {date: 3 days next, yyyy-MM-dd} 09:00 - 12:00 |
      | pickupTag          | DUPE1                           |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op