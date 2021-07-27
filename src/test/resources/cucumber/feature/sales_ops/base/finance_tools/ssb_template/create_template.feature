@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @SSB @CreateTemplate

Feature: Create SSB Template

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
@nadeera
  Scenario: Create SSB Template
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
