@Sort @SortCodePart1
Feature: Sort Code

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Malaysia"

  Scenario: View Postcode and Sort Code (uid:655fa977-9c89-441f-bc53-8bdec0efaeb4)
    Given Operator go to menu Sort -> Sort Code
    And Sort App Page is fully loaded
    Then Operator verifies that all the components in Sort Code Page are complete

  @DeleteCreatedSortCodeCommonV2
  Scenario: Search Postcode (uid:573e4cf7-ace9-4191-a205-b334171619b7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Operator create a sort code using postcode "RANDOM"
    Given Operator go to menu Sort -> Sort Code
    And Sort App Page is fully loaded
    When Operator searches for Sort Code based on its "postcode"
      | postcode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].postcode} |
    Then Operator verifies that the sort code details are right
      | postcode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].postcode} |
      | sortCode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].sortCode} |
      | id       | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].id}       |

  @DeleteCreatedSortCodeCommonV2
  Scenario: Search Sort Code (uid:3efb0ab7-a186-4c9e-9a43-1d3c1dc83d92)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Operator create a sort code using postcode "RANDOM"
    Given Operator go to menu Sort -> Sort Code
    And Sort App Page is fully loaded
    When Operator searches for Sort Code based on its "sort_code"
      | sortCode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].sortCode} |
    Then Operator verifies that the sort code details are right
      | postcode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].postcode} |
      | sortCode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].sortCode} |
      | id       | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].id}       |

  @DeleteCreatedSortCodeCommonV2
  Scenario: Download CSV (uid:63e3e1ea-7c71-4561-8ca5-26f835d632b6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Operator create a sort code using postcode "RANDOM"
    Given Operator go to menu Sort -> Sort Code
    And Sort App Page is fully loaded
    When Operator clicks on download button on the Sort Code Page
    Then Operator verifies that the details in the downloaded csv are right
      | postcode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].postcode} |
      | sortCode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].sortCode} |
      | id       | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].id}       |

  @DeleteCreatedSortCodeCommonV2
  Scenario: Upload CSV with Existing Postcode and Existing Sort Code (uid:4073b5f0-db5e-4ad9-be86-a92af4de4d79)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Operator create a sort code using postcode "RANDOM"
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-existed-postcode-existed-sort-code-csv-file}"
      | postcode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].postcode} |
      | sortCode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].sortCode} |
      | id       | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].id}       |
    Then Operator verifies that there will be success toast shown
    When Operator searches for Sort Code based on its "postcode"
      | postcode | {KEY_OF_UPLOADED_SORT_CODE.postcode} |
    Then Operator verifies that the sort code details are right
      | postcode | {KEY_OF_UPLOADED_SORT_CODE.postcode} |
      | sortCode | {KEY_OF_UPLOADED_SORT_CODE.sortCode} |
      | id       | {KEY_OF_UPLOADED_SORT_CODE.id}       |

  @DeleteCreatedSortCodeCommonV2
  Scenario: Upload CSV with Existing Postcode and New Sort Code (uid:383fdb26-93b7-4f6f-866f-4702431e9ebf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Operator create a sort code using postcode "RANDOM"
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-existed-postcode-new-sort-code-csv-file}"
      | postcode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].postcode} |
      | sortCode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].sortCode} |
      | id       | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].id}       |
    Then Operator verifies that there will be success toast shown
    When Operator searches for Sort Code based on its "postcode"
      | postcode | {KEY_OF_UPLOADED_SORT_CODE.postcode} |
    Then Operator verifies that the sort code details are right
      | postcode | {KEY_OF_UPLOADED_SORT_CODE.postcode} |
      | sortCode | {KEY_OF_UPLOADED_SORT_CODE.sortCode} |
      | id       | {KEY_OF_UPLOADED_SORT_CODE.id}       |

  Scenario: Upload CSV with New Postcode and Existing Sort Code (uid:23ab6d99-eca2-49b4-84cf-0557e9bfb44b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Operator create a sort code using postcode "RANDOM"
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-new-postcode-existed-sort-code-csv-file}"
      | postcode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].postcode} |
      | sortCode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].sortCode} |
      | id       | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].id}       |
    Then Operator verifies that there will be success toast shown
    When Operator searches for Sort Code based on its "postcode"
      | postcode | {KEY_OF_UPLOADED_SORT_CODE.postcode} |
    Then Operator verifies that the sort code details are right
      | postcode | {KEY_OF_UPLOADED_SORT_CODE.postcode} |
      | sortCode | {KEY_OF_UPLOADED_SORT_CODE.sortCode} |
      | id       | {KEY_OF_UPLOADED_SORT_CODE.id}       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
