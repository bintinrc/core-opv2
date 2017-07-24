@sms-module @selenium
Feature: Sms Module

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator send sms valid data
    Given op click custom navigation SMS Module in Mass Communications and url sms
    Then op upload sms campaign csv file
      | tracking_id              | name                 | email            | job                |
      | NVSGQANV7000000917       | Sim Sze Kiat         | qa@ninjavan.co   |	Dev             |
    When op compose sms with data : Sim Sze Kiat, NVSGQANV7000000917
    Then op send sms


  Scenario: Operator send sms invalid data
    Given op click custom navigation SMS Module in Mass Communications and url sms
    Then op upload sms campaign csv file
      | tracking_id              | name                 | email            | job                |
      | SOMERANDOMTRACKID        | Sim Sze Kiat         | qa@ninjavan.co   |	Dev             |
    Then op continue on invalid dialog


  @KillBrowser
  Scenario: Kill Browser
