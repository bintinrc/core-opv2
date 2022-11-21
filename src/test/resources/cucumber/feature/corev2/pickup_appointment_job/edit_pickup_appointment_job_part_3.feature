Feature: Edit Pickup Appointment Job Part 3

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @AddJobComment @DeletePickupJob
  Scenario: Edit pickup appointment job - add jobs comments (pickup instructions)
    Given API Operator create new appointment pickup job using data below:
      | createRouteRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |

    When Operator loads Shipper Address Configuration page Pickup Appointment
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
    Given API Operator create new appointment pickup job using data below:
      | createRouteRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}, "tagIds":[287], "pickupInstructions":"pickup instructions"} |

    When Operator loads Shipper Address Configuration page Pickup Appointment
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
    Given API Operator create new appointment pickup job using data below:
      | createRouteRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}, "tagIds":[287], "pickupInstructions":"pickup instructions"} |

    When Operator loads Shipper Address Configuration page Pickup Appointment
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