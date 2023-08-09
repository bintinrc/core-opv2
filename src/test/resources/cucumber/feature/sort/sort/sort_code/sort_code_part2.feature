@Sort @SortCodePart2
Feature: Sort Code

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Malaysia"

  @DeleteCreatedSortCodeCommonV2
  Scenario: Upload CSV with New Postcode and New Sort Code (uid:66eb9b8f-d4e2-4725-895e-8860261a53c9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Operator create a sort code using postcode "RANDOM"
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-new-postcode-new-sort-code-csv-file}"
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

  Scenario: Fail to Upload CSV with Invalid Postcode (uid:1ac226a7-430a-4dfb-9f97-91402cd1748e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-invalid-postcode-csv-file}"
    |invalid|invalid|
    Then Operator verifies that there will be an error toast "invalid_postcode" shown

  Scenario: Fail to Upload CSV with Invalid CSV Format (uid:74a59794-143a-4887-8949-fd10bc409331)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-invalid-format-csv-file}"
      |invalid|invalid|
    Then Operator verifies that there will be an error toast "invalid_format" shown

  Scenario: Upload CSV to Overwrite Existing Postcode and Existing Sort Code (uid:8d010fe1-0601-4c54-8424-3b77f5701063)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Operator create a sort code using postcode "RANDOM"
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-override-existed-postcode-existed-sort-code-csv-file}"
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

  Scenario: Upload CSV to Delete Existing Postcode and Existing Sort Code (uid:ecc0fefa-5e07-440b-bf09-8693e1d39a83)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Order - Operator create a sort code using postcode "RANDOM"
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-delete-newly-created-sort-code-csv-file}"
      | postcode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].postcode} |
      | sortCode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].sortCode} |
      | id       | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].id}       |
    Then Operator verifies that there will be success toast shown
    When Operator searches for Sort Code based on its "postcode"
      | postcode | {KEY_ORDER_LOST_OF_CREATED_SORT_CODES[1].postcode} |
    Then Operator verifies that the sort code is not found

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
