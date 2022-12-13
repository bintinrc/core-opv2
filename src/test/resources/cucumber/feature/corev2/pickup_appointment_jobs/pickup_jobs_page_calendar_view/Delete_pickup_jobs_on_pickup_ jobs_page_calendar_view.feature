@CWF
Feature: Delete pickup jobs on pickup jobs page calendar view

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @RT @CreatPickupJob
  Scenario:Delete Pickup Jobs on Pickup Jobs Page Calendar View - Enabled - Ready For Routing
    Given API Operator create new appointment pickup job using data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{normal-shipper-pickup-appointment-1-address_id}}, "pickupService":{ "level":"Standard"}, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When Operator goes to Pickup Jobs Page
    And Operator click on Create or edit job button on this top right corner of the page
    And Operator select shipper id or name = "{normal-shipper-pickup-appointment-1-id}" in Shipper ID or Name field
    And Operator select address = "{normal-shipper-pickup-appointment-1-address}" in Shipper Address field
    Then Operator verify there is Delete button in job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}"
    Then Operator verify there is Edit button in job with id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}"
    When Operator click on delete button for pickup job id = "{KEY_LIST_OF_PICKUP_JOB_IDS[1]}"
    Then Operator verify Delete dialog displays data below:
      | shipperName    | {normal-shipper-pickup-appointment-1-name}    |
      | shipperAddress | {normal-shipper-pickup-appointment-1-address} |
      | readyBy        | 09:00                                         |
      | latestBy       | 12:00                                         |