@OperatorV2 @CoreV2 @PickupAppointment @BulkUpdatePickupJobsTag @CWF
Feature: bulk tag on pickup jobs page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Bulk Update PA Job - Assign job tag - no tag
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
    Given  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    And Operator clicks "Assign job tag" button on Pickup Jobs page
    When  Operator select Pickup job tag = "DUPE1" in Job Tags Model
    Then Operator check 2 tags with name = "DUPE1"

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Bulk Update PA Job - Assign job tag - same tag
    Given DB Control - get pickup tag id for tag name = "{tag-name-1}"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id}        |
      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[2].id}        |
      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Then Operator check 2 tags with name = "{tag-name-1}"
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page
    Given  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    And Operator clicks "Assign job tag" button on Pickup Jobs page
    When  Operator select Pickup job tag = "{tag-name-1}" in Job Tags Model
    Then Operator check 2 tags with name = "{tag-name-1}"


  @deletePickupJob @DeleteShipperAddressCommonV2 @RT
  Scenario:Bulk Update PA Job - Assign job tag - with tag
    Given DB Control - get pickup tag id for tag name = "{tag-name-1}"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id}        |
      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[2].id}        |
      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    Then Operator check 2 tags with name = "{tag-name-1}"
    And  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And  Operator clicks "Select All Shown" button on Pickup Jobs page
    Then Operator verifies number of selected rows on Pickup Jobs page
    Given  Operator clicks "Bulk select dropdown" button on Pickup Jobs page
    And Operator clicks "Bulk Update dropdown" button on Pickup Jobs page
    And Operator clicks "Assign job tag" button on Pickup Jobs page
    When  Operator select Pickup job tag = "{tag-name-3}" in Job Tags Model
    Then Operator check 2 tags with name = "{tag-name-1}"
    Then Operator check 2 tags with name = "{tag-name-3}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op