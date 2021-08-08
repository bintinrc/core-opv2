@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @SSB @CreateTemplate

Feature: Create SSB Template

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

@DeleteSsbTemplate
Scenario: Create SSB Template
  Given Operator go to menu Finance Tools -> SSB Template
  When SSB Template page is loaded
  And Operator clicks Create Template button
  And SSB Report Template Editor page is loaded
  And Operator creates template with below data successfully
    | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}             |
    | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss} |
    | selectHeaders       | Legacy Shipper ID                                                |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op