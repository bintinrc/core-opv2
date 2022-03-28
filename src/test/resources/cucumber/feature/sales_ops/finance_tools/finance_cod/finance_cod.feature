@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @FinanceCod

Feature: Finance COD

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @nadeera
  Scenario: Generate COD report
    Given Operator go to menu Finance Tools -> Finance COD
    When Operator generates success finance cod report using data below:
      | basedOn      | Route Date                         |
      | startDate    | {gradle-previous-2-day-yyyy-MM-dd} |
      | endDate      | {gradle-previous-2-day-yyyy-MM-dd} |
      | generateFile | International                      |
      | emailAddress | {order-billing-email}              |
