@OperatorV2 @CoreV2 @PickupAppointment @PAJobsUpdateTags
Feature: update tags on pickup jobs page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddress
  Scenario: Add jobs tag for single PA Job on pickup job page
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects tag "{tag-name-1}" on Edit PA job page
    And Operator clicks update tags button on Edit PA job page
    Then Operator verifies update tags successful message below on Edit PA job page:
      | Job tags updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "{tag-name-1}" length = 1 in pickup_appointment_jobs_pickup_tags

  @deletePickupJob @DeleteShipperAddress
  Scenario: Remove a job tag for single PA Job on pickup job page
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    And DB Control - get pickup tag id for tag name = "{tag-name-1}"
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"},"tagIds":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id}        |
      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator remove tag "{tag-name-1}" on Edit PA job page
    And Operator clicks update tags button on Edit PA job page
    Then Operator verifies update tags successful message below on Edit PA job page:
      | Job tags updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "{tag-name-1}" length = 0 in pickup_appointment_jobs_pickup_tags

  @deletePickupJob @DeleteShipperAddress
  Scenario: Update jobs tag for single PA Job on pickup job page
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    And DB Control - get pickup tag id for tag name = "{tag-name-1}"
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"},"tagIds":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id}        |
      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator remove tag "{tag-name-1}" on Edit PA job page
    And Operator selects tag "{tag-name-2}" on Edit PA job page
    And Operator clicks update tags button on Edit PA job page
    Then Operator verifies update tags successful message below on Edit PA job page:
      | Job tags updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "{tag-name-2}" length = 1 in pickup_appointment_jobs_pickup_tags

  @deletePickupJob @DeleteShipperAddress
  Scenario: Add multiple jobs tag for single PA Job on pickup job page
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator selects tag "{tag-name-1}" on Edit PA job page
    And Operator selects tag "{tag-name-2}" on Edit PA job page
    And Operator clicks update tags button on Edit PA job page
    Then Operator verifies update tags successful message below on Edit PA job page:
      | Job tags updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "{tag-name-1}" length = 1 in pickup_appointment_jobs_pickup_tags
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "{tag-name-2}" length = 1 in pickup_appointment_jobs_pickup_tags

  @deletePickupJob @DeleteShipperAddress
  Scenario: Remove all job tags for single PA Job on pickup job page
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    And DB Control - get pickup tag id for tag name = "{tag-name-1}"
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"},"tagIds":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id}        |
      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | pickupAppointmentTagsRequest | {"tags":[{tag-id-2}]}               |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator remove tag "{tag-name-1}" on Edit PA job page
    And Operator remove tag "{tag-name-2}" on Edit PA job page
    And Operator clicks update tags button on Edit PA job page
    Then Operator verifies update tags successful message below on Edit PA job page:
      | Job tags updated successfully\nJob {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "{tag-name-1}" length = 0 in pickup_appointment_jobs_pickup_tags
    And DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "{tag-name-2}" length = 0 in pickup_appointment_jobs_pickup_tags

  @deletePickupJob @DeleteShipperAddress
  Scenario: Update same jobs tag for single PA Job on pickup job page
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"},"tagIds":[{tag-id-1}]} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | pickupAppointmentTagsRequest | {"tags":[{tag-id-1}]}               |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Given Operator clicks edit PA job on Pickup Jobs Page
    And Operator remove tag "{tag-name-1}" on Edit PA job page
    Then Operator verifies button update jobs tag is "enable" on Edit PA job page
    When Operator selects tag "{tag-name-1}" on Edit PA job page
    Then Operator verifies button update jobs tag is "disable" on Edit PA job page


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op