@OperatorV2 @CoreV2 @PickupAppointment @SearchResultTable @tableFiltersPAMJobsSearch @CWF
Feature: filter on search result table column

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Filter table column - by Job ID
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
    When Operator check 1 Column with value = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" in PAM search table
    When Operator check 1 Column with value = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" in PAM search table
    When Operator search for job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" in pickup jobs table
    When Operator check 1 Column with value = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" in PAM search table
    When Operator check 0 Column with value = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" in PAM search table
    When Operator search for job id = "00000000" in pickup jobs table
    When Operator check 0 Column with value = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" in PAM search table
    When Operator check 0 Column with value = "{KEY_CONTROL_CREATED_PA_JOBS[2].id}" in PAM search table


  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Filter table column - by Shipper ID
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
    When Operator check 1 Column with value = "{normal-shipper-pickup-appointment-1-id}" in PAM search table
    When Operator check 1 Column with value = "{premium-shipper-pickup-appointment-1-id}" in PAM search table
    When Operator search for shipper id = "{normal-shipper-pickup-appointment-1-id}" in pickup jobs table
    When Operator check 1 Column with value = "{normal-shipper-pickup-appointment-1-id}" in PAM search table
    When Operator check 0 Column with value = "{premium-shipper-pickup-appointment-1-id}" in PAM search table
    When Operator search for shipper id = "00000000" in pickup jobs table
    When Operator check 0 Column with value = "{normal-shipper-pickup-appointment-1-id}" in PAM search table
    When Operator check 0 Column with value = "{premium-shipper-pickup-appointment-1-id}" in PAM search table


  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Filter table column - by Shipper name & contract
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
    When Operator check 1 Column with value = "{normal-shipper-pickup-appointment-1-name}" in PAM search table
    When Operator check 1 Column with value = "{premium-shipper-pickup-appointment-1-name}" in PAM search table
    When Operator search for shipper name = "{normal-shipper-pickup-appointment-1-name}" in pickup jobs table
    When Operator check 1 Column with value = "{normal-shipper-pickup-appointment-1-name}" in PAM search table
    When Operator check 0 Column with value = "{premium-shipper-pickup-appointment-1-name}" in PAM search table
    When Operator search for shipper name = "00000000" in pickup jobs table
    When Operator check 0 Column with value = "{normal-shipper-pickup-appointment-1-name}" in PAM search table
    When Operator check 0 Column with value = "{premium-shipper-pickup-appointment-1-name}" in PAM search table

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Filter table column - by Pickup address
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
    When Operator check 1 Column with value = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in PAM search table
    When Operator check 1 Column with value = "{KEY_LIST_OF_CREATED_ADDRESSES[2].address1}" in PAM search table
    When Operator search for address name = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator check 1 Column with value = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in PAM search table
    When Operator check 0 Column with value = "{KEY_LIST_OF_CREATED_ADDRESSES[2].address1}" in PAM search table
    When Operator search for address name = "00000000" in pickup jobs table
    When Operator check 0 Column with value = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in PAM search table
    When Operator check 0 Column with value = "{KEY_LIST_OF_CREATED_ADDRESSES[2].address1}" in PAM search table

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Filter table column - by Ready by
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-2-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-2-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator pare date time to string "{KEY_CONTROL_CREATED_PA_JOBS[1].pickupReadyDatetime}"
    When Operator pare date time to string "{KEY_CONTROL_CREATED_PA_JOBS[2].pickupReadyDatetime}"
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator check 2 Column with value = "{KEY_FORMATTED_DATE_TIME[1]}" in PAM search table
    When Operator check 2 Column with value = "{KEY_FORMATTED_DATE_TIME[2]}" in PAM search table
    When Operator search for ready time = "{KEY_FORMATTED_DATE_TIME[1]}" in pickup jobs table
    When Operator check 2 Column with value = "{KEY_FORMATTED_DATE_TIME[1]}" in PAM search table
    When Operator check 0 Column with value = "{KEY_FORMATTED_DATE_TIME[2]}" in PAM search table
    When Operator search for ready time = "00000000" in pickup jobs table
    When Operator check 0 Column with value = "{KEY_FORMATTED_DATE_TIME[1]}" in PAM search table
    When Operator check 0 Column with value = "{KEY_FORMATTED_DATE_TIME[2]}" in PAM search table

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Filter table column - by Latest by
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-2-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-2-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator pare date time to string "{KEY_CONTROL_CREATED_PA_JOBS[1].pickupReadyDatetime}"
    When Operator pare date time to string "{KEY_CONTROL_CREATED_PA_JOBS[2].pickupReadyDatetime}"
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator check 2 Column with value = "{KEY_FORMATTED_DATE_TIME[1]}" in PAM search table
    When Operator check 2 Column with value = "{KEY_FORMATTED_DATE_TIME[2]}" in PAM search table
    When Operator search for latest time = "{KEY_FORMATTED_DATE_TIME[1]}" in pickup jobs table
    When Operator check 2 Column with value = "{KEY_FORMATTED_DATE_TIME[1]}" in PAM search table
    When Operator check 0 Column with value = "{KEY_FORMATTED_DATE_TIME[2]}" in PAM search table
    When Operator search for latest time = "00000000" in pickup jobs table
    When Operator check 0 Column with value = "{KEY_FORMATTED_DATE_TIME[1]}" in PAM search table
    When Operator check 0 Column with value = "{KEY_FORMATTED_DATE_TIME[2]}" in PAM search table

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario:Filter table column - by Job creation time
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-2-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-2-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator pare date time to string "{KEY_CONTROL_CREATED_PA_JOBS[1].pickupReadyDatetime}"
    When Operator pare date time to string "{KEY_CONTROL_CREATED_PA_JOBS[2].pickupReadyDatetime}"
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator check 2 Column with value = "{gradle-current-date-yyyy-MM-dd}" in PAM search table
    When Operator search for create time = "00000000" in pickup jobs table
    When Operator check 0 Column with value = "{gradle-current-date-yyyy-MM-dd}" in PAM search table


  @deletePickupJob @DeleteShipperAddressCommonV2 @RT
  Scenario:Filter table column - by Approx vol
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-3-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-3-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[2].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-2-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-2-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator pare date time to string "{KEY_CONTROL_CREATED_PA_JOBS[1].pickupReadyDatetime}"
    When Operator pare date time to string "{KEY_CONTROL_CREATED_PA_JOBS[2].pickupReadyDatetime}"
    When Operator goes to Pickup Jobs Page
    And  Operator clicks "Filter by job ID" button on Pickup Jobs page
    Then Operator verifies Filter Job button is disabled on Pickup job page
    Given Operator fills the pickup job ID list below:
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | {KEY_CONTROL_CREATED_PA_JOBS[2].id} |
    And  Operator clicks "Filter Jobs" button on Pickup Jobs page
    When Operator check 2 Column with value = "Less than 3 Parcels" in PAM search table
    When Operator search for approx vol = "00000000" in pickup jobs table
    When Operator check 0 Column with value = "Less than 3 Parcels" in PAM search table