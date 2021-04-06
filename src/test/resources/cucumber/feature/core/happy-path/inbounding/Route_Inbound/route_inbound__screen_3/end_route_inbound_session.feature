@undecided @undecided @undecided
Feature: End Route Inbound Session

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: End a Route Inbound Session : Completed Scans (uid:f1af21ad-eed6-438b-93b3-85c0ad0dbe54)
    Given Route "is created with some transactions assigned and route inbound expected scans are completed"
      """
      NOTE:
      - Route Inbound Expected Scans directories: https://studio.cucumber.io/projects/208144/test-plan/folders/1581631
      """
    And Route "with expected cash inbounded are completed "
      """
      NOTE:
      - Inbound Cash On Delivery & Cash On Pickup directories: https://studio.cucumber.io/projects/208144/test-plan/folders/1581632
      """
    When UI_ROUTE_INBOUND_END_SESSION "true"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op