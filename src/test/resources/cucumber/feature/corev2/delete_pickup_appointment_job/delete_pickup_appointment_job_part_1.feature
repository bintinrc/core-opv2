@PickupAppointment @JobPage @Delete @Part1
Feature: Delete Pickup Appointment Job Part 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePickupJobReadyForRouting
  Scenario: Delete pickup jobs on Pickup Jobs page calendar view - enabled - Ready for Routing
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |

    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    Then QA verify there is Delete button in that particular job tag
    And QA verify there is Edit button in that particular job tag

    When Operator click on Delete button
    Then QA verify Delete dialog displays the jobs information
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | readyBy        | 09:00                                         |
      | latestBy       | 12:00                                         |

    When Operator click on Submit button on Delete Job modal window
    Then QA verify successful message is displayed with the job's date and time
      | startDay            | {gradle-next-1-day-yyyy-MM-dd} |
      | timeRange           | 09:00:00 - 12:00               |
      | notificationMessage | Job deleted                    |
    And QA verify that particular job is removed from calendar on date "{gradle-next-1-day-yyyy-MM-dd}" with status "ready-for-routing"
    And DB Operator verifies Pickup Appointment Job have status "CANCELLED" in control_qa_gl.pickup_appointment_jobs

  @DeletePickupJobRouted
  Scenario: Delete pickup jobs on Pickup Jobs page calendar view - enabled - Routed
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    And API Operator add route to appointment pickup job using data below:
      | overwrite | false |

    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    Then QA verify there is Delete button in that particular job tag
    And QA verify there is Edit button in that particular job tag

    When Operator click on Delete button
    Then QA verify Delete dialog displays the jobs information
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | readyBy        | 09:00                                         |
      | latestBy       | 12:00                                         |

    When Operator click on Submit button on Delete Job modal window
    Then QA verify successful message is displayed with the job's date and time
      | startDay            | {gradle-next-1-day-yyyy-MM-dd} |
      | timeRange           | 09:00:00 - 12:00               |
      | notificationMessage | Job deleted                    |
    And QA verify that particular job is removed from calendar on date "{gradle-next-1-day-yyyy-MM-dd}" with status "routed"
    And DB Operator verifies Pickup Appointment Job have status "CANCELLED" in control_qa_gl.pickup_appointment_jobs

  @DeletePickupJobInProgress
  Scenario: Delete pickup jobs on Pickup Jobs page calendar view - enabled - In Progress
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address-id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    And API Operator start the route
    And API Operator add route to appointment pickup job using data below:
      | overwrite | false |

    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field

    Then QA verify there is Delete button in that particular job tag
    And QA verify there is Edit button in that particular job tag

    When Operator click on Delete button
    Then QA verify Delete dialog displays the jobs information
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | readyBy        | 09:00                                         |
      | latestBy       | 12:00                                         |

    When Operator click on Submit button on Delete Job modal window
    Then QA verify successful message is displayed with the job's date and time
      | startDay            | {gradle-next-1-day-yyyy-MM-dd} |
      | timeRange           | 09:00:00 - 12:00               |
      | notificationMessage | Job deleted                    |
    And QA verify that particular job is removed from calendar on date "{gradle-next-1-day-yyyy-MM-dd}" with status "in-progress"
    And DB Operator verifies Pickup Appointment Job have status "CANCELLED" in control_qa_gl.pickup_appointment_jobs

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op