@MileZero @CorporateHQ @WithSg
Feature: B2B Management

  @LaunchBrowser @ShouldAlwaysRun @DeleteCorporateSubShipper
  Scenario: Go to master shipper details page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"

  @CloseNewWindows
  Scenario: Toggled on corporate document service type for existing non corporate shipper (uid:a3d3b780-8ba9-4986-b7b4-df18058bf687)
    Given Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    When Operator go to "Basic Settings" tab on Edit Shipper page
    And Operator set service type "Corporate Document" to "Yes" on edit shipper page
    Then Operator verifies toast "Only corporate shippers are allowed to have Corporate Document as their service type" displayed on edit shipper page
    And DB Shipper verifies available service types for created shipper not contains "Corporate Document"

  @CloseNewWindows
  Scenario: Modify corporate document service type for existing corporate shipper (uid:d9ed9844-bf0d-48fe-b413-0bb466350c64)
    Given Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    When Operator go to "Basic Settings" tab on Edit Shipper page
    And Operator set service type "Corporate Document" to "Yes" on edit shipper page
    Then DB Shipper verifies available service types for created shipper contains "Corporate Document"

  @DeleteCorporateSubShipper @CloseNewWindows
  Scenario: Create subshippers with corporate document toggle off in subshipper default settings (uid:4f1c30a2-a098-4052-a566-eceb420268c6)
    Given Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    When Operator go to "Basic Settings" tab on Edit Shipper page
    And Operator set service type "Corporate Document" to "Yes" on edit shipper page
    And Operator go to "Sub shippers Default Setting" tab on Edit Shipper page
    And Operator set service type "Corporate Document" to "No" on Sub shippers Default Setting tab edit shipper page
    And Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created
    When API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And Operator Edit Shipper Page of created b2b sub shipper
    Then Operator verifies Basic Settings on Edit Shipper page:
      | corporateDocument | false |

  @DeleteCorporateSubShipper @CloseNewWindows
  Scenario: Create subshippers with corporate document toggle on in subshipper default settings (uid:37171044-0ff6-4f2c-971a-be047be99931)
    Given Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    When Operator go to "Basic Settings" tab on Edit Shipper page
    And Operator set service type "Corporate Document" to "Yes" on edit shipper page
    When Operator go to "Sub shippers Default Setting" tab on Edit Shipper page
    And Operator set service type "Corporate Document" to "Yes" on Sub shippers Default Setting tab edit shipper page
    And Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created
    When API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And Operator Edit Shipper Page of created b2b sub shipper
    Then Operator verifies Basic Settings on Edit Shipper page:
      | corporateDocument | true |

  @CloseNewWindows
  Scenario: Create non corporate shipper with corporate document service type toggled on (uid:2c406974-2fe8-4918-bb4a-50c17d3aff9c)
    Given Operator go to menu Shipper -> All Shippers
    When Operator fail create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | false                 |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | isCorporateDocument          | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    Then Operator verifies toast "Only corporate shippers are allowed to have Corporate Document as their service type" displayed on edit shipper page

  @DeleteShipper @CloseNewWindows
  Scenario: Create corporate shipper - with corporate document toggle on (uid:f174038b-25be-42e5-bae7-9cab0b1622eb)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Corporate HQ          |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | isCorporateDocument          | false                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And DB Shipper verifies available service types for created shipper not contains "Corporate Document"

  @DeleteShipper @CloseNewWindows
  Scenario: Create corporate shipper - with corporate document toggle off (uid:b7064dfd-0100-45c2-a038-95e4b995dd1a)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Corporate HQ          |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | isCorporateDocument          | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And DB Shipper verifies available service types for created shipper contains "Corporate Document"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op