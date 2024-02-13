@OperatorV2 @Core @ShipperSupport @BlockedDates
Feature: Blocked Dates

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Operator Add Blocked Date
    Given API Lighthouse - Operator delete block pickup date for "{date: 1 days next, yyyy-MM-dd}"
    And Operator go to menu Shipper Support -> Blocked Dates
    When Operator adds Blocked Date for "{date: 1 days next, yyyy-MM-dd}"
    Then Operator verifies success toast "Blocked Dates Updated." is displayed
    Then Operator verifies new Blocked Date is added successfully

  @MediumPriority
  Scenario: Operator Remove Blocked Date
    Given API Lighthouse - Operator block pickup date for "{date: 2 days next, yyyy-MM-dd}"
    And Operator go to menu Shipper Support -> Blocked Dates
    When Operator removes Blocked Date for "{date: 2 days next, yyyy-MM-dd}"
    Then Operator verifies success toast "Blocked Dates Updated." is displayed
    Then Operator verifies Blocked Date is removed successfully

  @MediumPriority
  Scenario:Operator Undo Changes for Blocked Date
    Given API Lighthouse - Operator block pickup date for "{date: 2 days next, yyyy-MM-dd}"
    And Operator go to menu Shipper Support -> Blocked Dates
    When Operator removes Blocked Date for "{date: 2 days next, yyyy-MM-dd}"
    Then Operator verifies success toast "Blocked Dates Updated." is displayed
    When Operator clicks on "Undo Changes" button in toast message
    Then Operator verifies Blocked Date is still blocked
    Given API Lighthouse - Operator delete block pickup date for "{date: 1 days next, yyyy-MM-dd}"
    When Operator adds Blocked Date for "{date: 1 days next, yyyy-MM-dd}"
    Then Operator verifies success toast "Blocked Dates Updated." is displayed
    When Operator clicks on "Undo Changes" button in toast message
    Then Operator verifies Blocked Date is not added