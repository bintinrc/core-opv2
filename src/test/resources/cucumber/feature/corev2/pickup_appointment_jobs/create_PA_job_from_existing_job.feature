@OperatorV2 @CoreV2 @PickupAppointment @createJobFromExistingJob @CWF
Feature: Create pickup jobs from existing job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob
  Scenario:Create new pickup job from existing job on Pickup Jobs page - create/edit jobs button
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
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
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
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
      | timeSlot        | {date: 3 days next, yyyy-MM-dd} - {date: 3 days next, yyyy-MM-dd} 18:00 - 22:00 |

  @deletePickupJob @RT
  Scenario:Create new pickup job from existing job on Pickup Jobs page - create/edit jobs button - apply job tag
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
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
      | pickupTag         | PRIOR                           |
    And Operator clicks Submit button on Existing Upcoming Job page
    Then Operator verifies job created success following data below:
      | timeSlot        | {date: 3 days next, yyyy-MM-dd} - {date: 3 days next, yyyy-MM-dd} 18:00 - 22:00 |
      | pickupTag          | PRIOR                           |

  Scenario: Bulk select on Pickup Jobs page result table - display only selected
    When Operator goes to Pickup Jobs Page
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    And  Operator selects 1 rows on Pickup Jobs page
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Display only selected" button on Pickup Jobs page
    Then Operator verify the number of selected rows is "1"
  @deletePickupJob
  Scenario:Search pickup jobs by job ID on Pickup Jobs page - bulk valid ID
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{premium--shipper-pickup-appointment-1-address_id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}|
      |{KEY_CONTROL_CREATED_PA_JOB_IDS[2]}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Then Operator verify pickup job table on Pickup Jobs page:
      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]} |
      | {KEY_CONTROL_CREATED_PA_JOB_IDS[2]} |

  @deletePickupJob
  Scenario:Search pickup jobs and reservations by ID on Pickup Jobs page - empty ids
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}|
    And Operator clears the filter jobs list on Pickup Jobs Page
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Then Operator verifies error message below:
      | Filter Pickup Appointment Job ID failed\nTry again with valid Pickup Appointment Job IDs |

  Scenario:Search pickup jobs by job ID on Pickup Jobs page - invalid separation
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      |abcde|
    Then Operator verifies invalid pickup ID error message below on Pickup Jobs Page:
      | Reservation/Job ID is invalid. It should be only number |
    Then Operator verifies Filter Job button is disabled on Pickup job page

  @deletePickupJob
  Scenario:Search pickup jobs and reservations by ID on Pickup Jobs page - more than 1000 ids
  Given API Control - Operator create pickup appointment job with data below:
    | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
  When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fill more than 1000 pickup jobs Id on Pickup Jobs Page:
      |{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}|
    Then Operator verifies invalid pickup ID error message below on Pickup Jobs Page:
      | Reservation/Job IDs are more than 1000. Only max 1000 IDs will be processed |
    Then Operator verifies Filter Job button is disabled on Pickup job page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op