@OperatorV2 @Core @Shippers @Sales
Feature: Sales

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Download Sample CSV File for Sales Person Creation on Sales Page
    Given Operator go to menu Shipper -> Sales
    When Operator download sample CSV file for "Sales Person Creation" on Sales page
    Then Operator verify sample CSV file for "Sales Person Creation" on Sales page is downloaded successfully

  @DeleteCreatedSalesPerson
  Scenario: Operator Successfully Creates Multiple Sales Persons by Uploading CSV Contains Multiple Sales Person on Sales Page
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Shipper -> Sales
    When Operator upload CSV contains multiple Sales Persons on Sales page using data below:
      | numberOfSalesPerson | 2 |
    When Operator refresh page
    Then Operator verifies all Sales Persons created successfully

  @DeleteCreatedSalesPerson
  Scenario: Operator Verifies All filters on Sales Page Works Fine
    Given Operator go to menu Utilities -> QRCode Printing
    And API Core - Operator create sales person:
      | code | DSP-{uniqueString}   |
      | name | Dummy-{uniqueString} |
    When Operator go to menu Shipper -> Sales
    Then Operator verifies all filters on Sales page works fine

  @DeleteCreatedSalesPerson
  Scenario: Operator Creates Sales Person by Uploading CSV With Duplicate Code
    Given Operator go to menu Utilities -> QRCode Printing
    And API Core - Operator create sales person:
      | code | DSP-{uniqueString}   |
      | name | Dummy-{uniqueString} |
    When Operator go to menu Shipper -> Sales
    And Operator upload CSV with following Sales Persons data on Sales page:
      | code                               | name                 |
      | {KEY_CORE_LIST_OF_SALES_PERSON[1].code} | Dummy-{uniqueString} |
    Then Operator verifies that Upload CSV dialog contains following error records:
      | 1.Sales {KEY_CORE_LIST_OF_SALES_PERSON[2].name}: The sales person with code - {KEY_CORE_LIST_OF_SALES_PERSON[2].code} already exists |
    And Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                            |
      | bottom | ^.*400 Unknown.*The sales person with code - {KEY_CORE_LIST_OF_SALES_PERSON[2].code} already exists.* |

  @DeleteCreatedSalesPerson
  Scenario: Operator Update a Sales Person
    Given Operator go to menu Utilities -> QRCode Printing
    And API Core - Operator create sales person:
      | code | DSP-{uniqueString}   |
      | name | Dummy-{uniqueString} |
    When Operator go to menu Shipper -> Sales
    And Operator edit "{KEY_CORE_LIST_OF_SALES_PERSON[1].code}" sales person on Sales page using data below:
      | name | {KEY_CORE_LIST_OF_SALES_PERSON[1].name}EDITED |
    Then Operator verifies all sales persons parameters on Sales page

  @DeleteCreatedSalesPerson
  Scenario: Operator Delete an Exist Sales Person
    Given Operator go to menu Utilities -> QRCode Printing
    And API Core - Operator create sales person:
      | code | DSP-{uniqueString}   |
      | name | Dummy-{uniqueString} |
    When Operator go to menu Shipper -> Sales
    And Operator deletes "{KEY_CORE_LIST_OF_SALES_PERSON[1].code}" sales person on Sales page
    Then Operator verifies that success toast displayed:
      | top | Deleted salesperson {KEY_CORE_LIST_OF_SALES_PERSON[1].name} ({KEY_CORE_LIST_OF_SALES_PERSON[1].code}) |
    And Operator verifies "{KEY_CORE_LIST_OF_SALES_PERSON[1].code}" sales person was deleted on Sales page
