@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @FinanceCod

Feature: Generate COD Report - All Shippers

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Operator whitelist email "{qa-email-address}"
    Given operator marks gmail messages as read

  Scenario: Generate COD Report - Filter By Route Date - All Shippers
    Given Operator go to menu Finance Tools -> Finance COD
    When Operator generates success finance cod report using data below:
      | basedOn      | Route Date                         |
      | startDate    | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate      | {gradle-previous-1-day-yyyy-MM-dd} |
      | generateFile | All                                |
      | emailAddress | {qa-email-address}                 |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received finance cod email
    And Operator gets the finance cod report entries
    Then DB Operator verifies the count of entries for all cod orders by route date

  Scenario: Generate COD Report - Filter By Order Completed Date - All Shippers
    Given Operator go to menu Finance Tools -> Finance COD
    When Operator generates success finance cod report using data below:
      | basedOn      | Order Completed Date               |
      | startDate    | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate      | {gradle-previous-1-day-yyyy-MM-dd} |
      | generateFile | All                                |
      | emailAddress | {qa-email-address}                 |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received finance cod email
    And Operator gets the finance cod report entries
    Then DB Operator verifies the count of entries for all cod orders by completed local date