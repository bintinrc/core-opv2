@CWF @ShouldAlwaysRun
Feature: Create Pickup Appointment Job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CreateNewPickupJobs @DeletePickupJob
  Scenario: Create new pickup jobs on Pickup Jobs page calendar view - is_pickup_appointment_enabled true
    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
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
      | timeRange | 09:00 - 12:00 |

    And Operator click on Submit button

    Then QA verify Job created modal displayed with following format
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | startTime      | 09:00                                         |
      | endTime        | 12:00                                         |
      | startDay       | {gradle-next-1-day-yyyy-MM-dd}                |
      | endDay         | {gradle-next-1-day-yyyy-MM-dd}                |
    And QA verify the new created Pickup Jobs is shown in the Calendar by date "{gradle-next-1-day-yyyy-MM-dd}"

    Then Operator load selection job by date range and shipper
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator get Job Id from Pickup Jobs page

    Then QA verify the 1 Job displayed on the Pickup Jobs page
    And QA verify Pickup Job created on control_qa_gl.pickup_appointment_jobs
      | globalShipperId | {normal-shipper-pickup-appointment-1-global-id} |
      | date            | {gradle-next-1-day-yyyy-MM-dd}                  |
      | status          | READY_FOR_ROUTING                               |

  @CreateNewPickupJobsOverlappingDateAndTime @DeletePickupJob
  Scenario: Create new pickup jobs on Pickup Jobs page calendar view - overlapping date and time
    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
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
      | timeRange | 09:00 - 12:00 |

    And Operator click on Submit button

    Then QA verify Job created modal displayed with following format
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | startTime      | 09:00                                         |
      | endTime        | 12:00                                         |
      | startDay       | {gradle-next-1-day-yyyy-MM-dd}                |
      | endDay         | {gradle-next-1-day-yyyy-MM-dd}                |
    And QA verify the new created Pickup Jobs is shown in the Calendar by date "{gradle-next-1-day-yyyy-MM-dd}"

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
      | timeRange | 09:00 - 12:00 |

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

  @CreateNewCustomisedPickupJobsPremiumShipper @DeletePickupJob
  Scenario: Create new Customised pickup jobs on Pickup Jobs page calendar view - Premium shipper
    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{premium-shipper-pickup-appointment-1-name}" in Shipper ID or Name field
    And Operator select address = "{premium-shipper-pickup-appointment-1-address}" in Shipper Address field

    And Get Pickup Jobs from Calendar

    Then Operator verify all jobs for selected shipper and address on the selected month are displayed in the Calendar
      | shipperId      | {premium-shipper-pickup-appointment-1-id}      |
      | shipperName    | {premium-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {premium-shipper-pickup-appointment-1-address} |
    And Operator verify Create button in displayed

    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator select time slot from Select time range field
      | timeRange | Customised time range |

    And Operator select customised time range from Select time range
      | readyBy  | 9:00  |
      | latestBy | 12:00 |
    And Operator click on Submit button

    Then QA verify Job created modal displayed with following format
      | shipperName    | {premium-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {premium-shipper-pickup-appointment-1-address} |
      | startTime      | 09:00                                          |
      | endTime        | 12:00                                          |
      | startDay       | {gradle-next-1-day-yyyy-MM-dd}                 |
      | endDay         | {gradle-next-1-day-yyyy-MM-dd}                 |
    And QA verify the new created Pickup Jobs is shown in the Calendar by date "{gradle-next-1-day-yyyy-MM-dd}"

    Then Operator load selection job by date range and shipper
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator get Job Id from Pickup Jobs page

    Then QA verify the 1 Job displayed on the Pickup Jobs page
    And QA verify Pickup Job created on control_qa_gl.pickup_appointment_jobs
      | globalShipperId | {premium-shipper-pickup-appointment-1-global-id} |
      | date            | {gradle-next-1-day-yyyy-MM-dd}                   |
      | status          | READY_FOR_ROUTING                                |

  @CreateNewCustomisedPickupJobsStandardShipper @DeletePickupJob
  Scenario: Create new Customised pickup jobs on Pickup Jobs page calendar view - Standard shipper
    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
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
      | timeRange | Customised time range |

    And Operator select customised time range from Select time range
      | readyBy  | 10:00  |
      | latestBy | 16:00 |
    And Operator click on Submit button

    Then QA verify Job created modal displayed with following format
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | startTime      | 10:00                                         |
      | endTime        | 16:00                                         |
      | startDay       | {gradle-current-date-yyyy-MM-dd}                |
      | endDay         | {gradle-current-date-yyyy-MM-dd}                |
    And QA verify error message shown on the modal and close by message body "Please check your request payload for validation errors."

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op