@CWF @ShouldAlwaysRun
Feature: Create Pickup Appointment Job

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

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
      | startDay | {gradle-current-date-yyyy-MM-dd} |
      | endDay   | {gradle-current-date-yyyy-MM-dd} |
    And Operator select time slot from Select time range field
      | startTime | 09:00 |
      | endTime   | 12:00 |

    And Operator click on Submit button

    Then QA verify Job created modal displayed with following format
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | startTime      | 09:00                                         |
      | endTime        | 12:00                                         |
      | startDay       | {gradle-current-date-yyyy-MM-dd}              |
      | endDay         | {gradle-current-date-yyyy-MM-dd}              |
    And QA verify the new created Pickup Jobs is shown in the Calendar
#    And QA verify Pickup Job created on control_qa_gl.puckup_pickup_appointment_jobs


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op