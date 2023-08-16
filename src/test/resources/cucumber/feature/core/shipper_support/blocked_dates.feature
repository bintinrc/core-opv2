@OperatorV2 @Core @ShipperSupport @BlockedDates
Feature: Blocked Dates

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Add Blocked Date (uid:29f8048f-8c86-41af-8f00-70563b9c43bd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator adds Blocked Date
    Then Operator verifies new Blocked Date is added successfully

  Scenario: Operator Remove Blocked Date (uid:adfebb12-5118-44ba-88a1-8b163c97e0db)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator removes Blocked Date
    Then Operator verifies Blocked Date is removed successfully
