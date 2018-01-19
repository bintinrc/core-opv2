#todo : add tag @selenium after done with scenario
@PaymentProcessing
Feature: Sample 01

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"
    Given op go to Operator V2 Indonesia
    Given Operator go to menu Ninja Check Out -> Payment Processing

  Scenario: Search Payment Request

  @KillBrowser
  Scenario: Kill Browser
