@OperatorV2 @CoreV2 @PickupAppointment @EditPickupJobCalendarView2 @EditPACalendarViewPart2
Feature: Edit pickup jobs on Pickup Jobs page calendar view 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Edit pickup appointment job - add jobs tag
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in Shipper Address field
    And Operator click on edit button for pickup job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify Save button in disabled
    And Operator select Pickup job tag = "PRIOR" in Job Tags Field
    Then Operator verify Save button in enabled
    When Operator click Save button
    Then Operator verify notification is displayed with message = "Job updated" and description below:
      | description                    |
      | 09:00                          |
      | 12:00                          |
      | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator hover on job = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" edit button
    Then Operator check star icon on job = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" with status = "routed"
    Then Operator check tag = "PRIOR" is displayed on job
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "PRIOR" length = 1 in pickup_appointment_jobs_pickup_tags

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Edit pickup appointment job - add multiple jobs tag
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in Shipper Address field
    And Operator click on edit button for pickup job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify Save button in disabled
    And Operator select Pickup job tag = "PRIOR" in Job Tags Field
    And Operator select Pickup job tag = "DUPE1" in Job Tags Field
    Then Operator verify Save button in enabled
    When Operator click Save button
    Then Operator verify notification is displayed with message = "Job updated" and description below:
      | description                    |
      | 09:00                          |
      | 12:00                          |
      | {gradle-next-1-day-yyyy-MM-dd} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "PRIOR" length = 1 in pickup_appointment_jobs_pickup_tags
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "DUPE1" length = 1 in pickup_appointment_jobs_pickup_tags

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Edit pickup appointment job - update jobs tag
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    And DB Control - get pickup tag id for tag name = "DUPE1"
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"},"tagIds":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id}        |
      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in Shipper Address field
    And Operator click on edit button for pickup job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify Save button in disabled
    When Operator clear job tags input
    And Operator select Pickup job tag = "PRIOR" in Job Tags Field
    Then Operator verify Save button in enabled
    When Operator click Save button
    Then Operator verify notification is displayed with message = "Job updated" and description below:
      | description                    |
      | 09:00                          |
      | 12:00                          |
      | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator hover on job = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" edit button
    Then Operator check tag = "PRIOR" is displayed on job
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "PRIOR" length = 1 in pickup_appointment_jobs_pickup_tags

  @deletePickupJob @DeleteShipperAddressCommonV2 @ArchiveRouteCommonV2
  Scenario: Edit pickup appointment job - remove jobs tag
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    And DB Control - get pickup tag id for tag name = "PRIOR"
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"},"tagIds":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When API Control - Operator add tags pickup appointment job with data below:
      | jobId                        | {KEY_CONTROL_CREATED_PA_JOBS[1].id}        |
      | pickupAppointmentTagsRequest | {"tags":[{KEY_CONTROL_PICKUP_TAGS[1].id}]} |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                   |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":false} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in Shipper Address field
    And Operator click on edit button for pickup job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify Save button in disabled
    When Operator clear job tags input
    Then Operator verify Save button in enabled
    When Operator click Save button
    Then Operator verify notification is displayed with message = "Job updated" and description below:
      | description                    |
      | 09:00                          |
      | 12:00                          |
      | {gradle-next-1-day-yyyy-MM-dd} |
    Then DB Control - verify pickup appointment job with id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" and tag = "PRIOR" length = 0 in pickup_appointment_jobs_pickup_tags

  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Edit pickup appointment job - jobs timeslot - customised time premium shipper
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {premium-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                           |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{premium-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Premium"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{premium-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in Shipper Address field
    And Operator click on edit button for pickup job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify Save button in disabled
    When Operator clear pickup job Time Range input
    And Operator select time slot from Select time range field below:
      | timeRange | Customised time range |
    And Operator clear pickup job custom time Range input
    And Operator select Ready by and Latest by in Pickup Job create:
      | readyBy  | 09:00 |
      | latestBy | 19:00 |
    Then Operator verify Save button in enabled
    When Operator click Save button
    Then Operator verify notification is displayed with message = "Job updated" and description below:
      | description                    |
      | 09:00                          |
      | 19:00                          |
      | {gradle-next-1-day-yyyy-MM-dd} |
    When DB Control - get pickup jobs for shipper globalId = "{premium-shipper-pickup-appointment-1-global-id}" and address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" with status:
      | status            |
      | READY_FOR_ROUTING |
    When Operator get Pickup Jobs for date = "{gradle-next-1-day-yyyy-MM-dd}" from pickup jobs list = "KEY_CONTROL_PA_JOBS_IN_DB[1]"
    Then Operator check pickup jobs list = "KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT" size is = 1


  @deletePickupJob @DeleteShipperAddressCommonV2
  Scenario: Edit pickup appointment job - jobs timeslot - customised time standard shipper
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-0-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-0-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in Shipper Address field
    And Operator click on edit button for pickup job id = "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify Save button in disabled
    When Operator clear pickup job Time Range input
    And Operator select time slot from Select time range field below:
      | timeRange | Customised time range |
    And Operator clear pickup job custom time Range input
    And Operator select Ready by and Latest by in Pickup Job create:
      | readyBy  | 09:00 |
      | latestBy | 19:00 |
    Then Operator verify Save button in enabled
    When Operator click Save button
    Then Operator check Notification Error contains= "Invalid time window chosen for update"

  @CancelEditing @DeletePickupJob
  Scenario: Edit pickup appointment job - cancel editing
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}, "pickupInstructions":"pickup instructions"} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field
    Then QA verify there is Delete button in that particular job tag
    And QA verify there is Edit button in that particular job tag
    When Operator click on Edit button
    Then Operator verify the particular job tag in the Calendar changes from grey to black with white text
      | date   | {gradle-next-1-day-yyyy-MM-dd} |
      | status | ready-for-routing              |
      | color  | rgba(64, 64, 64, 1)            |
    And Operator verify the dialog displayed the editable data fields
      | startDay  | {gradle-next-1-day-dd/MM/yyyy} |
      | endDay    | {gradle-next-1-day-dd/MM/yyyy} |
      | timeRange | 09:00 - 12:00                  |
      | comments  | pickup instructions            |
    And Operator verify the Save button still disabled
    And Operator verify the Cancel button is enabled
    When Operator click on Cancel Button
    And QA verify Pickup Instructions created on control_qa_gl.pickup_appointment_jobs
      | globalShipperId | {normal-shipper-pickup-appointment-1-global-id} |
      | date            | {gradle-next-1-day-yyyy-MM-dd}                  |
      | status          | READY_FOR_ROUTING                               |
      | comment         | pickup instructions                             |
    And Operator verify the dialog shows the comment
      | date    | {gradle-next-1-day-yyyy-MM-dd} |
      | comment | pickup instructions            |

  @AddJobComment @DeletePickupJob
  Scenario: Edit pickup appointment job - add job comments (pickup instructions)
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field
    Then QA verify there is Delete button in that particular job tag
    And QA verify there is Edit button in that particular job tag
    When Operator click on Edit button
    Then Operator verify the particular job tag in the Calendar changes from grey to black with white text
      | date   | {gradle-next-1-day-yyyy-MM-dd} |
      | status | ready-for-routing              |
      | color  | rgba(64, 64, 64, 1)            |
    And Operator verify the dialog displayed the editable data fields
      | startDay  | {gradle-next-1-day-dd/MM/yyyy} |
      | endDay    | {gradle-next-1-day-dd/MM/yyyy} |
      | timeRange | 09:00 - 12:00                  |
    And Operator verify the Save button still disabled
    And Operator verify the Cancel button is enabled
    When Operator add pickup instructions = "pickup instructions" in Comment Field
    Then Operator verify the Save button is enabled
    When Operator click on Save Button
    Then QA verify successful message is displayed with the job's date and time
      | startDay  | {gradle-next-1-day-yyyy-MM-dd} |
      | timeRange | 09:00 - 12:00                  |
    And QA verify Pickup Instructions created on control_qa_gl.pickup_appointment_jobs
      | globalShipperId | {normal-shipper-pickup-appointment-1-global-id} |
      | date            | {gradle-next-1-day-yyyy-MM-dd}                  |
      | status          | READY_FOR_ROUTING                               |
      | comment         | pickup instructions                             |
    And Operator verify the dialog shows the comment
      | date    | {gradle-next-1-day-yyyy-MM-dd} |
      | comment | pickup instructions            |
    When Operator click on Edit button
    Then Operator verify the particular job tag in the Calendar changes from grey to black with white text
      | date   | {gradle-next-1-day-yyyy-MM-dd} |
      | status | ready-for-routing              |
      | color  | rgba(64, 64, 64, 1)            |
    And Operator verify the dialog displayed the editable data fields
      | startDay  | {gradle-next-1-day-dd/MM/yyyy} |
      | endDay    | {gradle-next-1-day-dd/MM/yyyy} |
      | timeRange | 09:00 - 12:00                  |
      | comments  | pickup instructions            |
    And Operator verify the Save button still disabled
    And Operator verify the Cancel button is enabled
    When Operator add pickup instructions = "test pickup instructions" in Comment Field
    Then Operator verify the Save button is enabled
    When Operator click on Save Button
    Then QA verify successful message is displayed with the job's date and time
      | startDay  | {gradle-next-1-day-yyyy-MM-dd} |
      | timeRange | 09:00 - 12:00                  |
    And QA verify Pickup Instructions created on control_qa_gl.pickup_appointment_jobs
      | globalShipperId | {normal-shipper-pickup-appointment-1-global-id} |
      | date            | {gradle-next-1-day-yyyy-MM-dd}                  |
      | status          | READY_FOR_ROUTING                               |
      | comment         | test pickup instructions                        |
    And Operator verify the dialog shows the comment
      | date    | {gradle-next-1-day-yyyy-MM-dd} |
      | comment | test pickup instructions       |

  @RemoveJobComment @DeletePickupJob
  Scenario: Edit pickup appointment job - remove job comments (pickup instructions)
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}, "tagIds":[287], "pickupInstructions":"pickup instructions"} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field
    Then QA verify there is Delete button in that particular job tag
    And QA verify there is Edit button in that particular job tag
    When Operator click on Edit button
    Then Operator verify the particular job tag in the Calendar changes from grey to black with white text
      | date   | {gradle-next-1-day-yyyy-MM-dd} |
      | status | ready-for-routing              |
      | color  | rgba(64, 64, 64, 1)            |
    And Operator verify the dialog displayed the editable data fields
      | startDay  | {gradle-next-1-day-dd/MM/yyyy} |
      | endDay    | {gradle-next-1-day-dd/MM/yyyy} |
      | timeRange | 09:00 - 12:00                  |
      | comments  | pickup instructions            |
    And Operator verify the Save button still disabled
    And Operator verify the Cancel button is enabled
    When Operator remove pickup instructions in Comment Field
    Then Operator verify the Save button is enabled
    When Operator click on Save Button
    Then QA verify successful message is displayed with the job's date and time
      | startDay  | {gradle-next-1-day-yyyy-MM-dd} |
      | timeRange | 09:00 - 12:00                  |
    And QA verify Pickup Instructions removed in control_qa_gl.pickup_appointment_jobs
      | globalShipperId | {normal-shipper-pickup-appointment-1-global-id} |
      | date            | {gradle-next-1-day-yyyy-MM-dd}                  |
      | status          | READY_FOR_ROUTING                               |
    And Operator verify the dialog shows the comment
      | date    | {gradle-next-1-day-yyyy-MM-dd} |
      | comment | -                              |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op