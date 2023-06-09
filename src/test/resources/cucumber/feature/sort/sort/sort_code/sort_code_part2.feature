@Sort @SortCodePart2
Feature: Sort Code

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Malaysia"

  @DeleteCreatedSortCode
  Scenario: Upload CSV with New Postcode and New Sort Code (uid:66eb9b8f-d4e2-4725-895e-8860261a53c9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator has created a sort code
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-new-postcode-new-sort-code-csv-file}"
    Then Operator verifies that there will be success toast shown
    When Operator searches for Sort Code based on its "postcode"
    Then Operator verifies that the sort code details are right


  Scenario: Fail to Upload CSV with Invalid Postcode (uid:1ac226a7-430a-4dfb-9f97-91402cd1748e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-invalid-postcode-csv-file}"
    Then Operator verifies that there will be an error toast "invalid_postcode" shown

  Scenario: Fail to Upload CSV with Invalid CSV Format (uid:74a59794-143a-4887-8949-fd10bc409331)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-invalid-format-csv-file}"
    Then Operator verifies that there will be an error toast "invalid_format" shown

  @DeleteCreatedSortCode
  Scenario: Upload CSV to Overwrite Existing Postcode and Existing Sort Code (uid:8d010fe1-0601-4c54-8424-3b77f5701063)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator has created a sort code
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-override-existed-postcode-existed-sort-code-csv-file}"
    Then Operator verifies that there will be success toast shown
    When Operator searches for Sort Code based on its "postcode"
    Then Operator verifies that the sort code details are right

  Scenario: Upload CSV to Delete Existing Postcode and Existing Sort Code (uid:ecc0fefa-5e07-440b-bf09-8693e1d39a83)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator has created a sort code
    Given Operator go to menu Sort -> Sort Code
    Then Sort App Page is fully loaded
    When Operator uploads the CSV file with name "{sort-delete-newly-created-sort-code-csv-file}"
    Then Operator verifies that there will be success toast shown
    When Operator searches for Sort Code based on its "postcode"
    Then Operator verifies that the sort code is not found

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
