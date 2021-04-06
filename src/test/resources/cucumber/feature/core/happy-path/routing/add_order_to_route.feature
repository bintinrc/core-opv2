@core
Feature: Add Order To Route

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @JIRA-NV-7902 @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Add Order to a Route - Valid Tracking ID, No Prefix (uid:62260562-a35c-4918-bdbf-02f0f0c9b62f)
    Given Shipper creates a "Return" order
    And Operator creates a driver route
    And UI_ADD_ORDER_TO_ROUTE "false" "false" "pickup transaction"
    And VERIFY_ADD_TO_ROUTE "Routed" "true" "false"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op