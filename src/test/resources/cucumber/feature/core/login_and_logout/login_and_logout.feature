@OperatorV2Disabled @Core @LoginLogout
Feature: Login and Logout

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Login into Operator Portal (uid:50b7456f-2e25-448e-9eb5-4246e6e9a642)
    Given Operator is in Operator Portal V2 login page
    When Operator click login button
    When Operator login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then Operator verify he is in main page

  Scenario: Operator Logout from Operator Portal (uid:3d7d60e8-aa8d-4339-85ac-4128ff58760d)
    When Operator click logout button
    Then Operator back in the login page

