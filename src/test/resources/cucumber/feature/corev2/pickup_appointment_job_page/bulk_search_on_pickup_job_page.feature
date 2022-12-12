@OperatorV2 @CoreV2 @PickupAppointment @ForceSuccessSinglePickupJob
Feature: Force Success Single Pickup Job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob
  Scenario:Force Search pickup jobs by job ID on Pickup Jobs page - single valid ID
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}|
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Then Operator verify pickup job table on Pickup Jobs page:
      | {KEY_CONTROL_CREATED_PA_JOB_IDS[1]} |

  @deletePickupJob
  Scenario:Search pickup jobs by job ID on Pickup Jobs page - bulk valid ID
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{premium--shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Premium"}, "pickupTimeslot":{ "ready":"{gradle-next-2-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-2-day-yyyy-MM-dd}T12:00:00+08:00"}} |
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
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      |{KEY_CONTROL_CREATED_PA_JOB_IDS[1]}|
    And Operator clears the filter jobs list on Pickup Jobs Page
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Then Operator verifies error message below:
      | Filter Pickup Appointment Job ID failed\nTry again with valid Pickup Appointment Job IDs |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op