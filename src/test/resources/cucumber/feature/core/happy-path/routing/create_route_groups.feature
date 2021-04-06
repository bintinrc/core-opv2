@core
Feature: 1. Create Route Groups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path @JIRA-SHIP-2002
  Scenario: Operator Add Transaction to Route Group (uid:369cd974-fa30-4b93-96e9-4d5c5e82833b)
  Created by Ian Gumilang at 03 February 2017
    Given Shipper creates multiple "Parcel" orders
    And Operator global inbound the order
    And Shipper creates multiple "Return" orders
    When Operator goes to "Create Route Groups" page
    And Operator applies some filters based on "created transaction"
    And Operator select "Shipper filter" from dropdown menu
    And Operator select "Creation Date filter" from dropdown menu
    And Operator clicks switch "'Include Transactions'" toggle button
    And Operator adds "Transaction" field filter
    And Operator clicks "'Load Selection'" button
    And Operator clicks on checkbox for selected "Transaction > Delivery (for Parcel Order)" from the list
    And Operator clicks on checkbox for selected "Transaction > Pickup (for Return Order)" from the list
    And Operator clicks "'+Add To Route Group ($total)'" button
    Then Verify that "'Add to Route Group'" modal is shown
    When Operator select "'Create New Route Group'" from "Route Group" toggle menu
    And Operator fills in "route group name" details
    And Operator clicks "'Add Transactions/Reservations'" button
    Then Verify that success toast message is displayed with message = "'Added'"
    And Verify that "selected transaction has been added to route group" successfully
    When Operator goes to "Route Group Managements" page
    And Operator filters "created Route Group Name" field
    And Operator clicks on "'Edit Route Group' button"
    Then Verify that "Added Transactions" result is shown correctly

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op