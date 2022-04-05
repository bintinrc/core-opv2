@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @FinanceCod

Feature: Finance COD

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Generate COD Report - More Than 60 Days Range - Completed Date (uid:a27f6d86-1f06-4ec0-909f-5e8091d4e6be)
    Given Operator go to menu Finance Tools -> Finance COD
    When Operator selects Finance COD Report data as below
      | basedOn      | Order Completed Date                |
      | startDate    | {gradle-previous-61-day-yyyy-MM-dd} |
      | endDate      | {gradle-previous-1-day-yyyy-MM-dd}  |
      | emailAddress | {order-billing-email}               |
    Then Operator verifies error message "Maximum range allowed is 60 days. Current selection is 61 days."

  Scenario: Generate COD Report - More Than 60 Days Range - Route Date (uid:cde07c7e-08c8-4718-b2d8-97ac2cf406ac)
    Given Operator go to menu Finance Tools -> Finance COD
    When Operator selects Finance COD Report data as below
      | basedOn      | Route Date                          |
      | startDate    | {gradle-previous-61-day-yyyy-MM-dd} |
      | endDate      | {gradle-previous-1-day-yyyy-MM-dd}  |
      | emailAddress | {order-billing-email}               |
    Then Operator verifies error message "Maximum range allowed is 60 days. Current selection is 61 days."

  Scenario Outline: Generate COD Report - Invalid Email - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Finance Tools -> Finance COD
    When Operator selects Finance COD Report data as below
      | basedOn      | Route Date                         |
      | startDate    | {gradle-previous-1-day-yyyy-MM-dd} |
      | endDate      | {gradle-previous-1-day-yyyy-MM-dd} |
      | emailAddress | <input_email>                      |
    Then Operator verifies error message "Please only enter @ninjavan.co email(s)."
    Examples:
      | input_email     | dataset_name         | hiptest-uid                              |
      | invalidemail.co | Invalid Email Format | uid:c9a478ad-e73c-4f80-995b-72d834ca11f2 |
      | test@gmail.com  | Non Ninja Van Email  | uid:3b70ffe1-0de4-4769-8cf5-3ae542eefa52 |
