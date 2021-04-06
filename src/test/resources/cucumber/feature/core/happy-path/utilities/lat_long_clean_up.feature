@NOT_AUTOMATED_OPV2
Feature: Lat/Long Clean Up

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @core @category-core @coverage-operator-auto @coverage-auto @step-done @happy-path
  Scenario: Operator Update Waypoint Details on Lat/Long Cleanup Page (uid:95f9adf5-dd68-4499-985f-bf84ce18c707)
    Given Order "has been created"
    When Operator goes to "Lat/Long Cleanup" page
    And Operator clicks "'Edit Waypoint Details'" button
    Then Verify that "'Edit Waypoint Details'" modal is shown
    When Operator fills in "waypoint ID of created order" details
    Then Verify that "Waypoint Details" is shown on modal
    When Operator fills in "new Waypoint" details
    And Operator clicks "'Save Changes'" button
    Then Verify that success toast message is displayed with message = "'Waypoint updated successfully'"
    And Verify that "waypoint details have been updated" successfully
    And Verify that in "core_qa_sg" / "waypoints"."(address1, address2, latitude, longitude, postcode, country, city)" is "updated with current waypoint details"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op