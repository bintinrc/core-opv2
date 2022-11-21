@PickupAppointment @JobPage @Edit @Part3
Feature: Edit Pickup Appointment Job Part 3

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @AddJobComment @DeletePickupJob
  Scenario: Edit pickup appointment job - add jobs comments (pickup instructions)
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
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    Then QA verify there is Delete button in that particular job tag
    And QA verify there is Edit button in that particular job tag

    When Operator click on Edit button

    Then Operator verify the particular job tag in the Calendar changes from grey to black with white text
      | date  | {gradle-next-1-day-yyyy-MM-dd} |
      | color | rgb(255, 255, 255)             |
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
      | date  | {gradle-next-1-day-yyyy-MM-dd} |
      | color | rgb(255, 255, 255)             |
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
  Scenario: Edit pickup appointment job - remove jobs comments (pickup instructions)
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
    And Operator add pickup instructions = "pickup instructions" in Comment Field

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
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    Then QA verify there is Delete button in that particular job tag
    And QA verify there is Edit button in that particular job tag

    When Operator click on Edit button

    Then Operator verify the particular job tag in the Calendar changes from grey to black with white text
      | date  | {gradle-next-1-day-yyyy-MM-dd} |
      | color | rgb(255, 255, 255)             |
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

  @CancelEditing @DeletePickupJob
  Scenario: Edit pickup appointment job - cancel editing
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
    And Operator add pickup instructions = "pickup instructions" in Comment Field

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
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    Then QA verify there is Delete button in that particular job tag
    And QA verify there is Edit button in that particular job tag

    When Operator click on Edit button

    Then Operator verify the particular job tag in the Calendar changes from grey to black with white text
      | date  | {gradle-next-1-day-yyyy-MM-dd} |
      | color | rgb(255, 255, 255)             |
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


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op