@OperatorV2 @CoreV2 @PickupAppointment @CreatePickupJobCalenderView @CWF
Feature: Create pickup jobs on Pickup Jobs page calendar view

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob
  Scenario:Create new pickup jobs on Pickup Jobs page calendar view - is_pickup_appointment_enabled true - mandatory field
    Given Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field
    Then Operator verify Create button in disabled
    When DB Control - get pickup jobs for shipper globalId = "{normal-shipper-pickup-appointment-1-global-id}" with status:
      | status            |
      | READY_FOR_ROUTING |
      | ROUTED            |
      | IN_PROGRESS       |
    When Operator get Pickup Jobs for date = "{gradle-next-1-day-yyyy-MM-dd}" from pickup jobs list = "KEY_CONTROL_PA_JOBS_IN_DB[1]"
    Then Operator check pickup jobs list = "KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT" size is = 0
    When Operator select the data range below:
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator select time slot from Select time range field below:
      | timeRange | 09:00 - 12:00 |
    Then Operator verify Create button in enabled
    When Operator click Create button
    Then Operator verify Job Created dialog displays data below:
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | readyBy        | 09:00                                         |
      | latestBy       | 12:00                                         |
      | jobTags        |                                               |
    When DB Control - get pickup jobs for shipper globalId = "{normal-shipper-pickup-appointment-1-global-id}" with status:
      | status            |
      | READY_FOR_ROUTING |
      | ROUTED            |
      | IN_PROGRESS       |
    When Operator get Pickup Jobs for date = "{gradle-next-1-day-yyyy-MM-dd}" from pickup jobs list = "KEY_CONTROL_PA_JOBS_IN_DB[2]"
    Then Operator check pickup jobs list = "KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT" size is = 1
    Then Operator verify there is Delete button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT[1].id}"
    Then Operator verify there is Edit button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT[1].id}"

  @deletePickupJob
  Scenario:Create new pickup jobs on Pickup Jobs page calendar view - is_pickup_appointment_enabled true - all field
    Given Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field
    Then Operator verify Create button in disabled
    When DB Control - get pickup jobs for shipper globalId = "{normal-shipper-pickup-appointment-1-global-id}" with status:
      | status            |
      | READY_FOR_ROUTING |
      | ROUTED            |
      | IN_PROGRESS       |
    When Operator get Pickup Jobs for date = "{gradle-next-1-day-yyyy-MM-dd}" from pickup jobs list = "KEY_CONTROL_PA_JOBS_IN_DB[1]"
    Then Operator check pickup jobs list = "KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT" size is = 0
    When Operator select the data range below:
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator select time slot from Select time range field below:
      | timeRange | 09:00 - 12:00 |
    And Operator select Pickup job tag = "DUPE1" in Job Tags Field
    Then Operator verify Create button in enabled
    When Operator click Create button
    Then Operator verify Job Created dialog displays data below:
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | readyBy        | 09:00                                         |
      | latestBy       | 12:00                                         |
      | jobTags        | DUPE1                                         |
    When DB Control - get pickup jobs for shipper globalId = "{normal-shipper-pickup-appointment-1-global-id}" with status:
      | status            |
      | READY_FOR_ROUTING |
      | ROUTED            |
      | IN_PROGRESS       |
    When Operator get Pickup Jobs for date = "{gradle-next-1-day-yyyy-MM-dd}" from pickup jobs list = "KEY_CONTROL_PA_JOBS_IN_DB[2]"
    Then Operator check pickup jobs list = "KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT" size is = 1
    Then Operator verify there is Delete button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT[1].id}"
    Then Operator verify there is Edit button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT[1].id}"


  @deletePickupJob
  Scenario:Create new Customised pickup jobs on Pickup Jobs page calendar view - Standard shipper
    Given Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field
    Then Operator verify Create button in disabled
    When DB Control - get pickup jobs for shipper globalId = "{normal-shipper-pickup-appointment-1-global-id}" with status:
      | status            |
      | READY_FOR_ROUTING |
      | ROUTED            |
      | IN_PROGRESS       |
    When Operator get Pickup Jobs for date = "{gradle-next-1-day-yyyy-MM-dd}" from pickup jobs list = "KEY_CONTROL_PA_JOBS_IN_DB[1]"
    Then Operator check pickup jobs list = "KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT" size is = 0
    When Operator select the data range below:
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator select time slot from Select time range field below:
      | timeRange | Customised time range |
    And Operator select Ready by and Latest by in Pickup Job create:
      | readyBy  | 09:00 |
      | latestBy | 12:00 |
    And Operator select Pickup job tag = "DUPE1" in Job Tags Field
    And Operator add comment to pickup job = "job created by automation"
    Then Operator verify Create button in enabled
    When Operator click Create button
    Then Operator verify Job Created dialog displays data below:
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | readyBy        | 09:00                                         |
      | latestBy       | 12:00                                         |
      | jobTags        | DUPE1                                         |
    When DB Control - get pickup jobs for shipper globalId = "{normal-shipper-pickup-appointment-1-global-id}" with status:
      | status            |
      | READY_FOR_ROUTING |
      | ROUTED            |
      | IN_PROGRESS       |
    When Operator get Pickup Jobs for date = "{gradle-next-1-day-yyyy-MM-dd}" from pickup jobs list = "KEY_CONTROL_PA_JOBS_IN_DB[2]"
    Then Operator check pickup jobs list = "KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT" size is = 1
    Then Operator verify there is Delete button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT[1].id}"
    Then Operator verify there is Edit button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT[1].id}"


  @deletePickupJob
  Scenario:Create new Customised pickup jobs on Pickup Jobs page calendar view - Premium shipper - success
    Given Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{premium-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{premium-shipper-pickup-appointment-1-address}" in Shipper Address field
    Then Operator verify Create button in disabled
    When DB Control - get pickup jobs for shipper globalId = "{premium-shipper-pickup-appointment-1-global-id}" with status:
      | status            |
      | READY_FOR_ROUTING |
      | ROUTED            |
      | IN_PROGRESS       |
    When Operator get Pickup Jobs for date = "{gradle-next-3-day-yyyy-MM-dd}" from pickup jobs list = "KEY_CONTROL_PA_JOBS_IN_DB[1]"
    Then Operator check pickup jobs list = "KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT" size is = 0
    When Operator select the data range below:
      | startDay | {gradle-next-3-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-3-day-yyyy-MM-dd} |
    And Operator select time slot from Select time range field below:
      | timeRange | Customised time range |
    And Operator select Ready by and Latest by in Pickup Job create:
      | readyBy  | 09:00 |
      | latestBy | 12:00 |
    And Operator select Pickup job tag = "DUPE1" in Job Tags Field
    And Operator add comment to pickup job = "job created by automation"
    Then Operator verify Create button in enabled
    When Operator click Create button
    Then Operator verify Job Created dialog displays data below:
      | shipperName    | {premium-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {premium-shipper-pickup-appointment-1-address} |
      | readyBy        | 09:00                                         |
      | latestBy       | 12:00                                         |
      | jobTags        | DUPE1                                         |
    When DB Control - get pickup jobs for shipper globalId = "{premium-shipper-pickup-appointment-1-global-id}" with status:
      | status            |
      | READY_FOR_ROUTING |
      | ROUTED            |
      | IN_PROGRESS       |
    When Operator get Pickup Jobs for date = "{gradle-next-3-day-yyyy-MM-dd}" from pickup jobs list = "KEY_CONTROL_PA_JOBS_IN_DB[2]"
    Then Operator check pickup jobs list = "KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT" size is = 1
    Then Operator verify there is Delete button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT[1].id}"
    Then Operator verify there is Edit button in job with id = "{KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT[1].id}"