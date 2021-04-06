@undecided @undecided
Feature: Route Inbound Expected Scans

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Route Inbound Expected Scans : Pending Deliveries (uid:0e3a4e5a-775d-4207-8e4a-4c1caefc19f6)
    Given Shipper creates multiple "Parcel" orders
    And Operator global inbound the order
    And Operator creates a driver route
    And Operator adds order to "delivery transaction" route
    And Operator merges the transaction waypoints
    And Verify that order status/granular_status is "Transit/Arrived at Sorting Hub"
    When UI_VIEW_EXPECTED_SCANS "Pending Deliveries" "true"

  @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Route Inbound Expected Scans : Failed Deliveries (Valid) (uid:9e2bccf1-a567-49a7-9983-450174817f86)
    Given Shipper creates multiple "Parcel" orders
    And Operator global inbound the order
    And Operator creates a driver route
    And Operator adds order to "delivery transaction" route
    And Driver "fail" the "delivery transaction by choosing failure reason : 'Failure due to customer/shipper : Customer requested change of delivery date/time'" from driver app
    And Operator merges the transaction waypoints
    And Verify that order status/granular_status is "Delivery Fail/Pending Reschedule"
    When UI_VIEW_EXPECTED_SCANS "Failed Deliveries (Valid)" "true"

  @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Route Inbound Expected Scans : Return Pickups (uid:53fb7536-821f-4047-a6ee-3b6b2012991e)
    Given Shipper creates multiple "Return" orders
    And Operator creates a driver route
    And Operator adds order to "pickup transaction" route
    And Driver "success" the "pickup transaction by scanning all orders" from driver app
    And Operator merges the transaction waypoints
    And Verify that order status/granular_status is "Transit/En-route to Sorting Hub"
    When UI_VIEW_EXPECTED_SCANS "C2C / Return Pickups" "true"

  @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Route Inbound Expected Scans : Reservation Pickups (uid:9071e77a-2715-4a17-9538-b3cd77461819)
    Given Shipper creates a reservation
    And Operator creates a driver route
    And Operator adds reservation to route
    And Driver "success" the "reservation by scanning orders" from driver app
    And Verify that order status/granular_status is "Transit/En-route to Sorting Hub"
    When UI_VIEW_EXPECTED_SCANS "Reservation Pickups" "false"

  @category-core @happy-path @step-done @coverage-auto @coverage-operator-auto
  Scenario: Route Inbound Expected Scans : Pending Return Pickups (uid:db8ca6ec-0e6f-4b52-bd17-2c100e463665)
    Given Shipper creates a "Return" order
    And Operator creates a driver route
    And Operator adds order to "pickup transaction" route
    When UI_VIEW_EXPECTED_SCANS "Pending C2C / Return Pickups" "true"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op