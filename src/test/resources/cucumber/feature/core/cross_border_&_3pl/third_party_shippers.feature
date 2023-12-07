@OperatorV2 @Core @CrossBorderAnd3PL @ThirdPartyShippers
Feature: Third Party Shippers

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteThirdPartyShippersV2 @HighPriority
  Scenario: Operator Create New Third Party Shippers
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    Then Operator verify the new Third Party Shipper is created successfully

  @DeleteThirdPartyShippersV2 @MediumPriority
  Scenario: Operator Edit Third Party Shippers
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Core - Operator verify the "{KEY_CORE_CREATED_THIRD_PARTY_SHIPPER.name}" Third Party Shipper is searchable
    When Operator update the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is updated successfully

  @DeleteThirdPartyShippersV2 @MediumPriority
  Scenario: Operator Delete Third Party Shippers
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Core - Operator verify the "{KEY_CORE_CREATED_THIRD_PARTY_SHIPPER.name}" Third Party Shipper is searchable
    When Operator delete the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is deleted successfully

  @DeleteThirdPartyShippersV2 @MediumPriority
  Scenario: Operator Check All filters on Third Party Shippers Page Work Fine
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Core - Operator verify the "{KEY_CORE_CREATED_THIRD_PARTY_SHIPPER.name}" Third Party Shipper is searchable
    Then Operator check all filters on Third Party Shippers page work fine

  @DeleteThirdPartyShippersV2 @MediumPriority
  Scenario: Operator Download and Verify Third Party Shippers CSV File
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Core - Operator verify the "{KEY_CORE_CREATED_THIRD_PARTY_SHIPPER.name}" Third Party Shipper is searchable
    When Operator download Third Party Shippers CSV file
    Then Operator verify Third Party Shippers CSV file downloaded successfully
