
Feature: Create Pickup Appointment Job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CreateNewPickupJobs
  Scenario: Create new pickup jobs on Pickup Jobs page calendar view - is_pickup_appointment_enabled true
    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator click on Create/edit job button on this top right corner of the page
    And Operator select shipper id/name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID/Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    And Get Pickup Jobs from Calendar

    Then Operator verify all jobs for selected shipper and address on the selected month are displayed in the Calendar
      | shipperId      | {normal-shipper-pickup-appointment-1-id}      |
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
    And Operator verify Create button in displayed

    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator select time slot from Select time range field
      | startTime | 09:00 |
      | endTime   | 12:00 |

    And Operator click on Submit button

    Then QA verify Job created modal displayed with following format
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | startTime      | 09:00                                         |
      | endTime        | 12:00                                         |
      | startDay       | {gradle-next-1-day-yyyy-MM-dd}                |
      | endDay         | {gradle-next-1-day-yyyy-MM-dd}                |
    And QA verify the new created Pickup Jobs is shown in the Calendar

    Then Operator load selection job by date range and shipper
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator get Job Id from Pickup Jobs page

    Then QA verify the 1 Job displayed on the Pickup Jobs page
    And QA verify Pickup Job created on control_qa_gl.pickup_appointment_jobs
      | globalShipperId | {normal-shipper-pickup-appointment-1-global-id} |
      | date            | {gradle-next-1-day-yyyy-MM-dd}                  |
      | status          | READY_FOR_ROUTING                               |

    Then API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And Operator load selection job by date range and shipper
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Complete Pickup Job With Route Id

  @CreateNewPickupJobsOverlappingDateAndTime
  Scenario: Create new pickup jobs on Pickup Jobs page calendar view - overlapping date and time
    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator click on Create/edit job button on this top right corner of the page
    And Operator select shipper id/name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID/Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    And Get Pickup Jobs from Calendar

    Then Operator verify all jobs for selected shipper and address on the selected month are displayed in the Calendar
      | shipperId      | {normal-shipper-pickup-appointment-1-id}      |
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
    And Operator verify Create button in displayed

    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator select time slot from Select time range field
      | startTime | 09:00 |
      | endTime   | 12:00 |

    And Operator click on Submit button

    Then QA verify Job created modal displayed with following format
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | startTime      | 09:00                                         |
      | endTime        | 12:00                                         |
      | startDay       | {gradle-next-1-day-yyyy-MM-dd}                |
      | endDay         | {gradle-next-1-day-yyyy-MM-dd}                |
    And QA verify the new created Pickup Jobs is shown in the Calendar

    And Get Pickup Jobs from Calendar

    Then Operator verify all jobs for selected shipper and address on the selected month are displayed in the Calendar
      | shipperId      | {normal-shipper-pickup-appointment-1-id}      |
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
    And Operator verify Create button in displayed

    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator select time slot from Select time range field
      | startTime | 09:00 |
      | endTime   | 12:00 |

    And Operator click on Submit button

    Then QA verify Job created modal displayed with following format
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | startTime      | 09:00                                         |
      | endTime        | 12:00                                         |
      | startDay       | {gradle-next-1-day-yyyy-MM-dd}                |
      | endDay         | {gradle-next-1-day-yyyy-MM-dd}                |
    And QA verify the new created Pickup Jobs is not shown in the Calendar

    Then Operator load selection job by date range and shipper
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator get Job Id from Pickup Jobs page

    Then QA verify the 1 Job displayed on the Pickup Jobs page
    And QA verify Pickup Job created on control_qa_gl.pickup_appointment_jobs
      | globalShipperId | {normal-shipper-pickup-appointment-1-global-id} |
      | date            | {gradle-next-1-day-yyyy-MM-dd}                  |
      | status          | READY_FOR_ROUTING                               |

    Then API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And Operator load selection job by date range and shipper
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Complete Pickup Job With Route Id

  @CreateNewCustomisedPickupJobsPremiumShipper
  Scenario: Create new Customised pickup jobs on Pickup Jobs page calendar view - Premium shipper
    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator click on Create/edit job button on this top right corner of the page
    And Operator select shipper id/name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID/Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    And Get Pickup Jobs from Calendar

    Then Operator verify all jobs for selected shipper and address on the selected month are displayed in the Calendar
      | shipperId      | {normal-shipper-pickup-appointment-1-id}      |
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
    And Operator verify Create button in displayed

    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator select time slot from Select time range field
      | startTime | customised |
      | endTime   | time       |

    And Operator select customised time range from Select time range
      | startTime | 9:00  |
      | endTime   | 12:00 |
    And Operator click on Submit button

    Then QA verify Job created modal displayed with following format
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | startTime      | 09:00                                         |
      | endTime        | 12:00                                         |
      | startDay       | {gradle-next-1-day-yyyy-MM-dd}                |
      | endDay         | {gradle-next-1-day-yyyy-MM-dd}                |
    And QA verify the new created Pickup Jobs is shown in the Calendar

    Then Operator load selection job by date range and shipper
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator get Job Id from Pickup Jobs page

    Then QA verify the 1 Job displayed on the Pickup Jobs page
    And QA verify Pickup Job created on control_qa_gl.pickup_appointment_jobs
      | globalShipperId | {normal-shipper-pickup-appointment-1-global-id} |
      | date            | {gradle-next-1-day-yyyy-MM-dd}                  |
      | status          | READY_FOR_ROUTING                               |

    Then API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And Operator load selection job by date range and shipper
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Complete Pickup Job With Route Id

  @CreateNewCustomisedPickupJobsStandardShipper
  Scenario: Create new Customised pickup jobs on Pickup Jobs page calendar view - Standard shipper
    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator click on Create/edit job button on this top right corner of the page
    And Operator select shipper id/name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID/Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    And Get Pickup Jobs from Calendar

    Then Operator verify all jobs for selected shipper and address on the selected month are displayed in the Calendar
      | shipperId      | {normal-shipper-pickup-appointment-1-id}      |
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
    And Operator verify Create button in displayed

    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator select time slot from Select time range field
      | startTime | customised |
      | endTime   | time       |

    And Operator select customised time range from Select time range
      | startTime | 9:00  |
      | endTime   | 12:00 |
    And Operator click on Submit button

    Then QA verify Job created modal displayed with following format
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | startTime      | 09:00                                         |
      | endTime        | 12:00                                         |
      | startDay       | {gradle-next-1-day-yyyy-MM-dd}                |
      | endDay         | {gradle-next-1-day-yyyy-MM-dd}                |
    And QA verify error message shown on the modal and close by message body "Please check your request payload for validation errors."
    And QA verify the new created Pickup Jobs is not shown in the Calendar

    Then API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And Operator load selection job by date range and shipper
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Complete Pickup Job With Route Id

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op