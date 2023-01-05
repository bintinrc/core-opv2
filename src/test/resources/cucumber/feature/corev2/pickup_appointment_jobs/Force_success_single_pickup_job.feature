@OperatorV2 @CoreV2 @PickupAppointment @ForceSuccessSinglePickupJob
Feature: Force Success Single Pickup Job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob
  Scenario:Force Success Single Pickup Job Routed With Photo
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
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
    When Operator upload Success proof photo on pickup appointment job
    When Operator click submit button on pickup success job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Success job successful          |
      | jobID               | {KEY_LIST_OF_PICKUP_JOB_IDS[1]} |
    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "COMPLETED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has "1" proof in proof_photos table

  @deletePickupJob
  Scenario:Force Success Single Pickup Job In Progress With Photo
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
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
    When Operator upload Success proof photo on pickup appointment job
    When Operator click submit button on pickup success job
    Then QA verify successful message is displayed with the jobID:
      | notificationMessage | Success job successful          |
      | jobID               | {KEY_LIST_OF_PICKUP_JOB_IDS[1]} |
    Then DB Control - verify pickup appointment job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" status = "COMPLETED" ,in pickup_appointment_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has proof in proof_jobs table
    Then DB Control - verify pickup appointment id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}" has "1" proof in proof_photos table

  @deletePickupJob
  Scenario:Force Success Single Pickup Job Routed With No Photo
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
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
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
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