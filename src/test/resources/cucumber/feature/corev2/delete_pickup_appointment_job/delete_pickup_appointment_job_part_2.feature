@PickupAppointment @JobPage @Delete @Part2
Feature: Delete Pickup Appointment Job Part 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePickupJobCompleted
  Scenario: Delete pickup jobs on Pickup Jobs page calendar view - disabled - Completed
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    And API Operator add route to appointment pickup job using data below:
      | overwrite | false |
    And API Operator complete appointment pickup job

    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    Then QA verify the jobs with status "completed" displayed in the Calendar on the date "{gradle-next-1-day-yyyy-MM-dd}" as well
    And Operator verify the particular job tag in the Calendar changes from grey to black with white text
      | date   | {gradle-next-1-day-yyyy-MM-dd} |
      | status | completed                      |
      | color  | rgb(199, 255, 233)             |
    And QA verify there is no Delete button in that particular job tag
    And QA verify there is no Edit button in that particular job tag

  @DeletePickupJobFailed
  Scenario: Delete pickup jobs on Pickup Jobs page calendar view - disabled - Failed
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    And API Operator add route to appointment pickup job using data below:
      | overwrite | false |
    And API Operator failed appointment pickup job using data below:
      | failureReasonCodeId | 9    |
      | failureReasonId     | 1476 |

    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    Then QA verify the jobs with status "failed" displayed in the Calendar on the date "{gradle-next-1-day-yyyy-MM-dd}" as well
    And Operator verify the particular job tag in the Calendar changes from grey to black with white text
      | date   | {gradle-next-1-day-yyyy-MM-dd} |
      | status | failed                         |
      | color  | rgb(255, 209, 211)             |
    And QA verify there is no Delete button in that particular job tag
    And QA verify there is no Edit button in that particular job tag

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op