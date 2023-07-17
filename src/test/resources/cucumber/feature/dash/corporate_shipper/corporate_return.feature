@MileZero @CorporateHQ @WithSg
Feature: B2B Corporate Return

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2 go to menu all shipper
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Toggled on corporate return service type for existing non corporate shipper (uid:e9a2a143-77d6-4ed6-82c1-c9cab7cd8c9b)
    Given Operator edits shipper "{prepaid-legacy-id}"
    And Operator set service type "Corporate Return" to "Yes" on edit shipper page
    Then Operator verifies toast "Only corporate shippers are allowed to have Corporate Return as their service type" displayed on edit shipper page
    And DB Shipper verifies available service types for shipper id "{prepaid-id}" not contains "Corporate Return"

  Scenario: Modify corporate return service type for corporate shipper (uid:fa7cf145-2a6b-4b56-959e-13ef1c9fd794)
    Given Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    When Operator set service type "Corporate Return" to "No" on edit shipper page
    Then DB Shipper verifies available service types for shipper id "{postpaid-corporate-hq-id}" not contains "Corporate Return"
    And Operator set service type "Corporate Return" to "Yes" on edit shipper page
    And DB Shipper verifies available service types for shipper id "{postpaid-corporate-hq-id}" contains "Corporate Return"

  @CloseNewWindows
  Scenario: Create non corporate shipper with corporate return service type toggled on (uid:b91633f4-a580-44d2-a425-bfec890190f8)
    Given Operator go to menu Shipper -> All Shippers
    When Operator fail create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | isCorporateReturn            | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    Then Operator verifies toast "Only corporate shippers are allowed to have Corporate Return as their service type" displayed on edit shipper page

  @DeleteShipper @CloseNewWindows
  Scenario: Create corporate shipper with corporate return service type toggled off (uid:dfdb5a83-779e-421a-b8a8-4ffeec167bdf)
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
      | isCorporateReturn            | false                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And DB Shipper verifies available service types for created shipper not contains "Corporate Return"

  @DeleteShipper @CloseNewWindows
  Scenario: Create corporate shipper with corporate return service type toggled on (uid:fce9b9ec-ee6a-42bc-a17d-4809979d009a)
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
      | isCorporateReturn            | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And DB Shipper verifies available service types for created shipper contains "Corporate Return"

  @CloseNewWindows
  Scenario: Inheritance corporate return service - parent toggled off (uid:c39cd56e-7151-4fbb-970f-8e45927b387c)
    Given Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    And Operator set service type "Corporate Return" to "Yes" on edit shipper page
    And DB Shipper verifies available service types for shipper id "{postpaid-corporate-hq-id}" contains "Corporate Return"
    When Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created
    And Operator click edit action button for newly created corporate sub shipper
    And Operator verifies corporate sub shipper details page is displayed
    And Operator set shipper on this page as newly created shipper
    And DB Shipper verifies available service types for created shipper not contains "Corporate Return"

  @CloseNewWindows
  Scenario: Inheritance corporate return service - parent toggled on (uid:ddcbb6b2-2ca0-4566-a742-b39e81eddf75)
    Given Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    And Operator set service type "Corporate Return" to "No" on edit shipper page
    And DB Shipper verifies available service types for shipper id "{postpaid-corporate-hq-id}" contains "Corporate Return"
    When Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    And Operator verifies corporate sub shipper is created
    And Operator click edit action button for newly created corporate sub shipper
    Then Operator verifies corporate sub shipper details page is displayed
    And Operator set shipper on this page as newly created shipper
    And DB Shipper verifies available service types for created shipper not contains "Corporate Return"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
