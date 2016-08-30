@selenium
Feature: Pricing Scripts

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in dp administration

  Scenario: Operator create, update and delete script on Pricing Scripts menu. (uid:0c1175e7-b5af-474c-b0a8-3b89ea786a59)
    Given op click navigation Pricing Scripts
    When op create new script on Pricing Scripts
    Then new script on Pricing Scripts created successfully
    When op update script on Pricing Scripts
    Then script on Pricing Scripts updated successfully
    When op delete script on Pricing Scripts
    Then script on Pricing Scripts deleted successfully

  Scenario: Operator do Run Test at selected Pricing Scripts. (uid:4918efb7-c16c-46a5-9ffa-20b2879c58c7)
    Given op click navigation Pricing Scripts
    Given op have two default script "Script Cucumber Test 1" and "Script Cucumber Test 2"
    When op click Run Test on Operator V2 Portal using this Script Check below:
      | deliveryType | EXPRESS   |
      | orderType    | NORMAL    |
      | timeslotType | DAY_NIGHT |
      | size         | L         |
      | weight       | 2.3       |
    Then op will find the cost equal to "134.9" and the comments equal to "OK"

  Scenario: Operator linking a Pricing Scripts to a Shipper. (uid:0800ac82-a359-4d5f-a666-12b6d3877540)
    Given op click navigation Pricing Scripts
    Given op have two default script "Script Cucumber Test 1" and "Script Cucumber Test 2"
    When op linking Pricing Scripts "Script Cucumber Test 1" or "Script Cucumber Test 2" to shipper "Pricing Script Link Shipper"
    Then Pricing Scripts linked to the shipper successfully

  @closeBrowser
  Scenario: close browser