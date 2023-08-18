@OperatorV2 @Core @CrossBorderAnd3PL @ThirdPartyShippers
Feature: Third Party Shippers

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteThirdPartyShippers
  Scenario: Operator Create New Third Party Shippers (uid:8520ed52-5815-47ce-a05d-0d16bfc31554)
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    Then Operator verify the new Third Party Shipper is created successfully

  @DeleteThirdPartyShippers
  Scenario: Operator Edit Third Party Shippers (uid:116cfb8a-378c-4895-96f7-f41e61f7250c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Operator gets data of created Third Party shipper
    When Operator update the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is updated successfully

  @DeleteThirdPartyShippers
  Scenario: Operator Delete Third Party Shippers (uid:378d6ded-86d1-4908-b91c-ec17dd4b8e72)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Operator gets data of created Third Party shipper
    When Operator delete the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is deleted successfully

  @DeleteThirdPartyShippers
  Scenario: Operator Check All filters on Third Party Shippers Page Work Fine (uid:f31a95b7-9035-4007-9c5a-071eab9f8f48)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Operator gets data of created Third Party shipper
    Then Operator check all filters on Third Party Shippers page work fine

  @DeleteThirdPartyShippers
  Scenario: Operator Download and Verify Third Party Shippers CSV File (uid:36f3ee26-728e-40c5-93c3-5af312c81dd7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    And API Operator gets data of created Third Party shipper
    When Operator download Third Party Shippers CSV file
    Then Operator verify Third Party Shippers CSV file downloaded successfully
