@OperatorV2 @Core @CrossBorderAnd3PL @ThirdPartyShippers
Feature: Third Party Shippers

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteThirdPartyShippers
  Scenario: Operator Create New Third Party Shippers
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    Then Operator verify the new Third Party Shipper is created successfully

  @DeleteThirdPartyShippers
  Scenario: Operator Edit Third Party Shippers
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Operator gets data of created Third Party shipper
    When Operator update the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is updated successfully

  @DeleteThirdPartyShippers
  Scenario: Operator Delete Third Party Shippers
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Operator gets data of created Third Party shipper
    When Operator delete the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is deleted successfully

  @DeleteThirdPartyShippers
  Scenario: Operator Check All filters on Third Party Shippers Page Work Fine
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Operator gets data of created Third Party shipper
    Then Operator check all filters on Third Party Shippers page work fine

  @DeleteThirdPartyShippers
  Scenario: Operator Download and Verify Third Party Shippers CSV File
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Operator gets data of created Third Party shipper
    When Operator download Third Party Shippers CSV file
    Then Operator verify Third Party Shippers CSV file downloaded successfully
