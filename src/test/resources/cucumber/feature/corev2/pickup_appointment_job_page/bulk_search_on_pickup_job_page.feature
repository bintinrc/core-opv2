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




#    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
#    When Operator select the data range
#      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
#      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
#    When Operator click load selection on pickup jobs filter
#    When Operator click edit icon for Pickup job row
#    Then Operator check Fail button enabled in pickup job drawer
#    Then Operator check Success button enabled in pickup job drawer
#    When Operator click success button in pickup job drawer
#    When Operator upload proof photo on pickup appointment job
#    When Operator click submit button on pickup success job
#    Then QA verify successful message is displayed with the jobID:
#      | notificationMessage | Success job successful          |
#      | jobID               | {KEY_LIST_OF_PICKUP_JOB_IDS[1]} |
#    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "COMPLETED" ,in pickup_appointment_jobs table
#    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has proof in proof_jobs table
#    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has "1" proof in proof_photos table

  @deletePickupJob
  Scenario:Force Success Single Pickup Job In Progress With Photo
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
#    When API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
#    When API Operator start the route
#    When API Operator add route to appointment pickup job using data below:
#      | overwrite | false |
#    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "IN_PROGRESS" ,in pickup_appointment_jobs table
#    When Operator goes to Pickup Jobs Page
#    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
#    When Operator select the data range
#      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
#      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
#    When Operator select only In progress job status, on pickup jobs filter
#    When Operator click load selection on pickup jobs filter
#    When Operator click edit icon for Pickup job row
#    Then Operator check Fail button enabled in pickup job drawer
#    Then Operator check Success button enabled in pickup job drawer
#    When Operator click success button in pickup job drawer
#    When Operator upload proof photo on pickup appointment job
#    When Operator click submit button on pickup success job
#    Then QA verify successful message is displayed with the jobID:
#      | notificationMessage | Success job successful          |
#      | jobID               | {KEY_LIST_OF_PICKUP_JOB_IDS[1]} |
#    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "COMPLETED" ,in pickup_appointment_jobs table
#    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has proof in proof_jobs table
#    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has "1" proof in proof_photos table

  @deletePickupJob
  Scenario:Force Success Single Pickup Job Routed With No Photo
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Operator add route to appointment pickup job using data below:
      | overwrite | false |
    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "ROUTED" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator click load selection on pickup jobs filter
    When Operator click edit icon for Pickup job row
    Then Operator check Fail button enabled in pickup job drawer
    Then Operator check Success button enabled in pickup job drawer
    When Operator click success button in pickup job drawer
    When Operator click submit button on pickup success job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Success job successful          |
      | jobID               | {KEY_LIST_OF_PICKUP_JOB_IDS[1]} |
    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "COMPLETED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has no proof in proof_photos table

  @deletePickupJob
  Scenario:Force Success Single Pickup Job In Progress With no Photo
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Operator start the route
    When API Operator add route to appointment pickup job using data below:
      | overwrite | false |
    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "IN_PROGRESS" ,in pickup_appointment_jobs table
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator select only In progress job status, on pickup jobs filter
    When Operator click load selection on pickup jobs filter
    When Operator click edit icon for Pickup job row
    Then Operator check Fail button enabled in pickup job drawer
    Then Operator check Success button enabled in pickup job drawer
    When Operator click success button in pickup job drawer
    When Operator click submit button on pickup success job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Success job successful          |
      | jobID               | {KEY_LIST_OF_PICKUP_JOB_IDS[1]} |
    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "COMPLETED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has no proof in proof_photos table


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op