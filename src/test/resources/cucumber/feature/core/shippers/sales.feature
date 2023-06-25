@OperatorV2 @Core @Shippers @Sales
Feature: Sales

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Download Sample CSV File for Sales Person Creation on Sales Page (uid:3af61552-4ca9-4246-ba7a-1be3dc528dbc)
    Given Operator go to menu Shipper -> Sales
    When Operator download sample CSV file for "Sales Person Creation" on Sales page
    Then Operator verify sample CSV file for "Sales Person Creation" on Sales page is downloaded successfully

  @DeleteSalesPerson
  Scenario: Operator Successfully Creates Multiple Sales Persons by Uploading CSV Contains Multiple Sales Person on Sales Page (uid:bcbfc882-3e1e-4423-b9d8-3c8ad973c204)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Shipper -> Sales
    When Operator upload CSV contains multiple Sales Persons on Sales page using data below:
      | numberOfSalesPerson | 2 |
    When Operator refresh page
    Then Operator verifies all Sales Persons created successfully

  @DeleteSalesPerson
  Scenario: Operator Verifies All filters on Sales Page Works Fine (uid:550e3406-2ed8-4c41-9ffb-f73e4307384c)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create sales person:
      | code | DSP-{uniqueString}   |
      | name | Dummy-{uniqueString} |
    When Operator go to menu Shipper -> Sales
    Then Operator verifies all filters on Sales page works fine

  @DeleteSalesPerson
  Scenario: Operator Creates Sales Person by Uploading CSV With Duplicate Code (uid:5504e1c8-78c0-44aa-a30d-8eb3c7051d56)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create sales person:
      | code | DSP-{uniqueString}   |
      | name | Dummy-{uniqueString} |
    When Operator go to menu Shipper -> Sales
    And Operator upload CSV with following Sales Persons data on Sales page:
      | code                               | name                 |
      | {KEY_LIST_OF_SALES_PERSON[1].code} | Dummy-{uniqueString} |
    Then Operator verifies that Upload CSV dialog contains following error records:
      | 1.Sales {KEY_LIST_OF_SALES_PERSON[2].name}: The sales person with code - {KEY_LIST_OF_SALES_PERSON[2].code} already exists |
    And Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                            |
      | bottom | ^.*400 Unknown.*The sales person with code - {KEY_LIST_OF_SALES_PERSON[2].code} already exists.* |

  @DeleteSalesPerson
  Scenario: Operator Update a Sales Person (uid:735c72d2-e24a-4fde-81bb-817aad5c840f)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create sales person:
      | code | DSP-{uniqueString}   |
      | name | Dummy-{uniqueString} |
    When Operator go to menu Shipper -> Sales
    And Operator edit "{KEY_LIST_OF_SALES_PERSON[1].code}" sales person on Sales page using data below:
      | name | {KEY_LIST_OF_SALES_PERSON[1].name}EDITED |
    Then Operator verifies all sales persons parameters on Sales page

  @DeleteSalesPerson
  Scenario: Operator Delete an Exist Sales Person (uid:3a01d8f0-9275-4193-be30-f05d08e05fb7)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create sales person:
      | code | DSP-{uniqueString}   |
      | name | Dummy-{uniqueString} |
    When Operator go to menu Shipper -> Sales
    And Operator deletes "{KEY_LIST_OF_SALES_PERSON[1].code}" sales person on Sales page
    Then Operator verifies that success toast displayed:
      | top                | Deleted salesperson {KEY_LIST_OF_SALES_PERSON[1].name} ({KEY_LIST_OF_SALES_PERSON[1].code}) |
      | waitUntilInvisible | true                                                                                        |
    And Operator verifies "{KEY_LIST_OF_SALES_PERSON[1].code}" sales person was deleted on Sales page
