Feature: Pricing Template

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in dp administrator

  Scenario: Operator create new rules on Pricing Template menu.
    Given op click navigation Pricing Template
    When op create new rules on Pricing Template
    Then new rules on Pricing Template created successfully

  Scenario: Operator delete rules on Pricing Template menu.
    Given op click navigation Pricing Template
    When op delete rules on Pricing Template
    Then rules on Pricing Template deleted successfully

  Scenario: op logout from operator portal
    Given op click navigation dp administrator
    When logout button is clicked
    Then op back in the login page
    Then close browser