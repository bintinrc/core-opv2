@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsID @UploadPaymentsID
Feature: Upload Payments - ID

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  Scenario: Operator Download CSV Payment Template For Shipper ID
    Given Operator go to menu Finance Tools -> Upload Payments
    When  Operator clicks on Download Template CSV dropdown
    Then  Operator clicks on "Template Shipper ID" option
    And Operator verifies that downloaded csv file for "Template Shipper ID" is same as "{upload-payments-template-shipper-id-sample-csv}"


  Scenario: Operator Download CSV Payment Template For Netsuite ID
    Given Operator go to menu Finance Tools -> Upload Payments
    When  Operator clicks on Download Template CSV dropdown
    Then  Operator clicks on "Template Netsuite ID" option
    And Operator verifies that downloaded csv file for "Template Netsuite ID" is same as "{upload-payments-template-netsuite-id-sample-csv}"

