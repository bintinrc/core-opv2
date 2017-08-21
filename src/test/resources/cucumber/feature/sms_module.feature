@sms-module @selenium
Feature: Sms Module

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator send sms valid data (uid:231d6a7a-d613-4abb-b734-4f7135e888d7)
    Given op click custom navigation SMS Module in Mass Communications and url sms
    Then op upload sms campaign csv file
      | tracking_id              | name                 | email            | job                |
      | NVSGQANV7000000917       | Sim Sze Kiat         | qa@ninjavan.co   |	Dev             |
    When op compose sms with data : Sim Sze Kiat, NVSGQANV7000000917
    Then op send sms

  @KillBrowser
  Scenario: Kill Browser


  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator send sms invalid data (uid:4601d827-7a33-4127-92e2-5774fed0c2b0)
    Given op click custom navigation SMS Module in Mass Communications and url sms
    Then op upload sms campaign csv file
      | tracking_id              | name                 | email            | job                |
      | SOMERANDOMTRACKID        | Sim Sze Kiat         | qa@ninjavan.co   |	Dev             |
    Then op continue on invalid dialog
    Then op verify sms module page resetted

  @KillBrowser
  Scenario: Kill Browser


  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Check sent sms history (uid:9af02fed-a582-4313-b501-e7e4074b0d46)
    Given op click custom navigation SMS Module in Mass Communications and url sms
    Then op upload sms campaign csv file
        | tracking_id              | name                 | email            | job              |
        | NVSGQANV7000000917       | Sim Sze Kiat         | qa@ninjavan.co   |	Dev             |
    When op compose sms with data : Sim Sze Kiat, NVSGQANV7000000917
    Then op send sms
    Then op wait for sms to be processed
    Then op verify that sms sent to phone number NVSGQANV7000000917 and tracking id +6588698632

  @KillBrowser
  Scenario: Kill Browser


  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Check sms history with invalid tracking id (uid:b9f8f867-c428-4d7a-96d9-b1c597571c60)
    Given op click custom navigation SMS Module in Mass Communications and url sms
    Then op verify that tracking id SOMERANDOMTRACKINGID is invalid

  @KillBrowser
  Scenario: Kill Browser


  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator using url shortener on sms editor (uid:9ba5f071-f569-41d4-81e5-92316cc34bd3)
    Given op click custom navigation SMS Module in Mass Communications and url sms
    Then op upload sms campaign csv file
      | tracking_id              | name                 | email            | job                |
      | NVSGQANV7000000917       | Sim Sze Kiat         | qa@ninjavan.co   |	Dev             |
    Then op compose sms using url shortener
    Then op verify sms preview using shortened url

  @KillBrowser
  Scenario: Kill Browser
