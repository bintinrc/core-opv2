@OperatorV2 @Core @ShipperSupport @BlockedDates @test
Feature: Blocked Dates

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Operator Add Blocked Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator adds Blocked Date
    Then Operator verifies success toast "Blocked Dates Updated." is displayed
    Then Operator verifies new Blocked Date is added successfully


  @MediumPriority
  Scenario: Operator Remove Blocked Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator removes Blocked Date
#    Then Operator verifies Blocked Date is removed successfully
