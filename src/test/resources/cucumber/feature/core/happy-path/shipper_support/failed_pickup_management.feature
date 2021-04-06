@core
Feature: Failed Pickup Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Reschedule Failed Return Pickup on Next Day (uid:7f6c074b-0582-4068-8fb6-2b12dc2d8755)
  @JP May 8 2018
  Old Title : Reschedule Failed Pickup
  Update by Zuhri 15/Des/2017
    Given Shipper creates a "Return" order
    And Operator creates a driver route
    And Operator adds order to "pickup transaction" route
    And Driver starts the route
    And Driver "fail" the "pickup waypoint" from driver app
    Then Verify that order status/granular_status is "Pickup fail/Pickup fail"
    When Operator goes to "Failed Pickup Management" page
    And Operator filters "tracking id (of failed pickup transaction)" field
    And Operator clicks on "'Reschedule Next Day' button on 'Action' column"
    Then Verify that success toast message is displayed with message = "'Order Rescheduling Success, Success to reschedule $total orders'"
    And Verify that "failed pickup transactions have been rescheduled" successfully
    Then VERIFY_RESCHEDULE_ORDER "Pending/Pending Pickup" "Pickup" "true"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Cancel Failed Pickup of Multiple Return Orders (uid:05ae10a8-6a3e-49f8-9359-bfd3fc62cb02)
  Created By Zuhri 2017/12/15
    Given Shipper is subscribed to "Cancelled" Webhook
    And Shipper creates multiple "Return" orders
    And Operator creates a driver route
    And Operator adds order to "pickup transactions" route
    And Driver starts the route
    And Driver "fail" the "pickup waypoints for all orders" from driver app
    Then Verify that order status/granular_status is "Pickup fail/Pickup fail"
    When UI_FAILED_PICKUP_MANAGEMENT "false" "true"
    Then VERIFY_CANCEL_ORDER "false" "true" "false" "false" "false" "false" "false" "Pickup Fail"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Reschedule Multiple Failed Pickups of Return Orders on Specific Date (uid:fa267dff-e29e-485d-93b4-3e04d307cb48)
  Created By Zuhri 2017/12/15
    Given Shipper creates multiple "Return" orders
    And Operator creates a driver route
    And Operator adds order to "pickup transactions" route
    And Driver starts the route
    And Driver "fail" the "pickup waypoints for all orders" from driver app
    Then Verify that order status/granular_status is "Pickup fail/Pickup fail"
    When UI_FAILED_PICKUP_MANAGEMENT "true" "true"
    Then VERIFY_RESCHEDULE_ORDER "Pending/Pending Pickup" "Pickup" "false"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op