@selenium
Feature: Pricing Template

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in dp administration

  Scenario: Operator create, update and delete rules on Pricing Template menu. (uid:0c1175e7-b5af-474c-b0a8-3b89ea786a59)
    Given op click navigation Pricing Template
    When op create new rules on Pricing Template
    Then new rules on Pricing Template created successfully
    When op update rules on Pricing Template
    Then rules on Pricing Template updated successfully
    When op delete rules on Pricing Template
    Then rules on Pricing Template deleted successfully

  Scenario: Operator do Run Test at selected Pricing Template. (uid:4918efb7-c16c-46a5-9ffa-20b2879c58c7)
    Given op click navigation Pricing Template
    Given op have two default rules "PT Cucumber Test 1" and "PT Cucumber Test 2"
    When op click Run Test on Operator V2 Portal using this Rules Check below:
      | deliveryType | EXPRESS   |
      | orderType    | NORMAL    |
      | timeslotType | DAY_NIGHT |
      | size         | L         |
      | weight       | 2.3       |
    Then op will find the cost equal to "134.9" and the comments equal to "OK"

  Scenario: Operator linking a Pricing Template to a Shipper. (uid:0800ac82-a359-4d5f-a666-12b6d3877540)
    Given op click navigation Pricing Template
    Given op have two default rules "PT Cucumber Test 1" and "PT Cucumber Test 2"
    When op linking Pricing Template "PT Cucumber Test 1" or "PT Cucumber Test 2" to shipper "Daniel Joi Partogi Hutapea"
    Then Pricing Template linked to the shipper successfully

  @closeBrowser
  Scenario: close browser