@core
Feature: Route Logs

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Edit Details of a Single Route on Route Logs Page (uid:2a2ab038-88aa-45be-b2a4-f651da5023e7)
  Updated by Ian Gumilang at 10 November 2017
    Given Route "is created"
    When Operator goes to "Route Logs" page
    And Operator type in "the created route_id in the Route ID field"
    And Operator clicks "Search" button
    Then Verify that Operator is redirected to "list of route logs" page
    And Verify that "the route_id search" result is shown correctly
    When Operator clicks "Edit Details" button
    And Operator fills in "updated Route Date, Route Tags, Hub, Assigned Driver, Vehicle, and Comments" details
    And Operator clicks "'Save Changes'" button
    Then Verify that success toast message is displayed with message = "'1 Route(s) Edited. Route $route_id'"
    And Verify that "Route Date, Route Tags, Hub, Assigned Driver, Vehicle, and Comments" is updated to "the new data"
    And Verify that in "core_qa_sg" / "route_logs"."datetime" is "updated"
    And Verify that in "core_qa_sg" / "route_logs"."hub_id" is "updated"
    And Verify that in "core_qa_sg" / "route_logs"."driver_id" is "updated"
    And Verify that in "core_qa_sg" / "route_logs"."vehicle" is "updated"
    And Verify that in "core_qa_sg" / "route_logs"."route_comments" is "updated"
    And Verify that in "route_qa_gl" / "route_tags"."tag_id" is "updated"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Archive Multiple Routes from Route Logs Page (uid:161bdba2-5816-446e-988d-56889e3103c9)
    Given Multiple "routes" are created "on certain dates"
    When UI_LOAD_ROUTE_LOGS_PAGE
    When Operator clicks on checkbox for selected "routes" from the list
    And Operator clicks on "'Apply Action > Archive Selected' "
    Then Verify that "'Archive Selected Routes'" modal is shown
    And Operator clicks "'Archive Routes'" button
    Then Verify that "progress pop up modal is shown with message 'updating X of $total items'"
    And Verify that success toast message is displayed with message = "'$total Route(s) Archived, Route $route_id'"
    And Verify that "status routes" is updated to "ARCHIVED in the list successfully"
    And VERIFY_ARCHIVE_ROUTE "false"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Merge Transactions of Multiple Routes from Route Logs Page (uid:647f207b-ca4b-4e6e-89d3-817f88d301a5)
    Given Multiple "routes" are created "with multiple transactions assigned"
    When UI_LOAD_ROUTE_LOGS_PAGE
    When Operator clicks on checkbox for selected "routes" from the list
    And Operator clicks on "'Apply Action > Merge Transactions Of Selected' "
    Then Verify that "'Merge Transactions within Selected Routes'" modal is shown
    And Operator clicks "'Merge Transactions'" button
    Then Verify that success toast message is displayed with message = "'Transactions within $total Routes Merged, Route $route_id'"
    And Verify that "all transactions.waypoint_id have the same waypoint_id"
    And Verify that "waypoints of routes have been merged in driver app" successfully

  @JIRA-DO-2194 @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Create a Single Route from Route Logs Page (uid:31070e4b-b30d-4323-8ea0-96be44488282)
  @JP
  Modified by TS at Aug 24th, 2018
    Given Operator goes to "Route Logs" page
    When Operator clicks "'+Create Route'" button
    Then Verify that "'Create Route'" modal is shown
    When Operator selects "Route Date" from selection menu
    And Operator select "Route Tags" from dropdown menu
    And Operator select "Zone" from dropdown menu
    And Operator select "Hub" from dropdown menu
    And Operator select "Assigned Driver" from dropdown menu
    And Operator select "Vehicle" from dropdown menu
    And Operator fills in "Comments" details
    And Operator clicks "'+ Create Route(S)'" button
    Then Verify that success toast message is displayed with message = "'$total Route(s) Created, $number.Route $route_id'"
    And Verify that "route has been created in the list" successfully
    And Verify that "created route" has correct details
    And Verify that new record in "core_qa_sg"/"route_logs" is created "with correct driver_id & hub_id (previously selected driver & hub)"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Unarchive Multiple Archived Routes from Route Logs Page (uid:613d5782-5aa0-4519-ac39-50a59ca0a208)
    Given Multiple "Routes" are created ""
    And Operator archives the route
    And UI_LOAD_ROUTE_LOGS_PAGE
    When Operator clicks on checkbox for selected "Routes" from the list
    And Operator clicks "Apply Action" button
    And Operator clicks on "Unarchive Selected"
    Then Verify that "confirmation for unarchiving routes" modal is shown
    When Operator clicks on "Unarchive Routes"
    And VERIFY_UNARCHIVE_V2 "false"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op