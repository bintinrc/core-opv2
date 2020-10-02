@OperatorV2 @Shipper @OperatorV2Part2 @AllShippers @Saas
Feature: All Shippers

  @LaunchBrowser @ShouldAlwaysRun @EnableClearCache
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @PricingProfile
  Scenario: Add New Shipper Pricing Profile (uid:e3bae772-87e8-4fbc-9698-c590871b4cdd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20                            |
      | comments          | This is a test pricing script |
    When DB Operator soft delete shipper by Legacy ID
    Then Operator verify the shipper is deleted successfully

  @PricingProfile
  Scenario: Edit Shipper Pricing Profile (uid:bbe028d2-f43d-4de1-a394-f53b68344aa5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20                            |
      | comments          | This is a test pricing script |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits the created shipper
    Then Operator edits the Pending Pricing Script
      | discount | 30                         |
      | comments | Edited test pricing script |
    When DB Operator soft delete shipper by Legacy ID
    Then Operator verify the shipper is deleted successfully

  @PricingProfile
  Scenario: Create a new Shipper - Pricing & Billing tab (uid:d86f2bd2-94ee-406c-b80e-224f54e00e0a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Active" and ""
    When DB Operator soft delete shipper by Legacy ID
    Then Operator verify the shipper is deleted successfully

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Shipper - Pricing & Billing tab - Update the Pricing Profile before Created (uid:74107efb-4c18-4468-9c0c-cf4f12f3d5fb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings and updates pricing script using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Active" and ""

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Shipper - Pricing & Billing tab - No Pricing Profile (uid:1d0199fc-6fb9-4d54-a32d-65b701799c7f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings and without Pricing profile using data below:
      | isShipperActive              | true            |
      | shipperType                  | Normal          |
      | ocVersion                    | v4              |
      | services                     | STANDARD        |
      | trackingType                 | Fixed           |
      | isAllowCod                   | true            |
      | isAllowCashPickup            | true            |
      | isPrepaid                    | true            |
      | isAllowStagedOrders          | true            |
      | isMultiParcelShipper         | true            |
      | isDisableDriverAppReschedule | true            |
      | industryName                 | {industry-name} |
      | salesPerson                  | {sales-person}  |

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with Flat Discount where Shipper has Active & Expired Pricing Profile (uid:72efc910-af1b-4145-bdd9-e486deb4284e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script |
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Active" and "Expired"
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20.00                         |
      | comments          | This is a test pricing script |
      | type              | FLAT                          |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script and shipper discount details
    And Operator verifies the pricing script and shipper discount details are correct

  @PricingProfile @DeleteShipper @CloseNewWindows @ResetCountry
  Scenario: Create a new Pricing Profile - with Percentage Discount where Shipper has Active & Expired Pricing Profile (uid:ad094f98-7e6f-4cf2-978e-b56b742695d7)
    Given Operator changes the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                     |
      | shipperType                  | Normal                   |
      | ocVersion                    | v4                       |
      | services                     | STANDARD                 |
      | trackingType                 | Fixed                    |
      | isAllowCod                   | true                     |
      | isAllowCashPickup            | true                     |
      | isPrepaid                    | true                     |
      | isAllowStagedOrders          | true                     |
      | isMultiParcelShipper         | true                     |
      | isDisableDriverAppReschedule | true                     |
      | pricingScriptName            | {pricing-script-name-id} |
      | industryName                 | {industry-name}          |
      | salesPerson                  | {sales-person-id}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2508 - PT Cucumber Test 2 |
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Active" and "Expired"
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2508 - PT Cucumber Test 2     |
      | discount          | 20.00                         |
      | comments          | This is a test pricing script |
      | type              | PERCENTAGE                    |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script and shipper discount details
    And Operator verifies the pricing script and shipper discount details are correct

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - where Shipper has Pending Pricing Profile (uid:dc2a9af8-d447-4eba-a6eb-3882d57aaeed)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20                            |
      | comments          | This is a test pricing script |
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Pending" and ""
    And Operator edits the created shipper
    And Operator verifies that Edit Pending Profile is displayed

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with 0 Flat Discount (uid:c6f6e5b0-d8c6-4489-83fe-b7ae021de5f7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds pricing script with invalid discount and verifies the error message
      | pricingScriptName | 2402 - New Script               |
      | discount          | 0                               |
      | errorMessage      | 0 is not a valid discount value |

  @PricingProfile @DeleteShipper @CloseNewWindows @ResetCountry
  Scenario: Create a new Pricing Profile - with 0 Percentage Discount (uid:81e2a66e-cc26-4a3a-ac56-1ea5b86f3614)
    Given Operator changes the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                     |
      | shipperType                  | Normal                   |
      | ocVersion                    | v4                       |
      | services                     | STANDARD                 |
      | trackingType                 | Fixed                    |
      | isAllowCod                   | true                     |
      | isAllowCashPickup            | true                     |
      | isPrepaid                    | true                     |
      | isAllowStagedOrders          | true                     |
      | isMultiParcelShipper         | true                     |
      | isDisableDriverAppReschedule | true                     |
      | pricingScriptName            | {pricing-script-name-id} |
      | industryName                 | {industry-name}          |
      | salesPerson                  | {sales-person-id}        |
    And Operator edits the created shipper
    Then Operator adds pricing script with invalid discount and verifies the error message
      | pricingScriptName | 2508 - PT Cucumber Test 2       |
      | discount          | 0                               |
      | errorMessage      | 0 is not a valid discount value |

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with none Flat Discount (uid:d4cf96cf-e1b2-421f-b5de-125d4af1b31f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | comments          | This is a test pricing script |
      | type              | FLAT                          |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script details
    And Operator verifies the pricing script details are correct
    When DB Operator soft delete shipper by Legacy ID
    Then Operator verify the shipper is deleted successfully

  @PricingProfile @DeleteShipper @CloseNewWindows @ResetCountry
  Scenario: Create a new Pricing Profile - with none Percentage Discount (uid:d948145c-704d-4a76-b6c5-fb18f9f1a853)
    Given Operator changes the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                     |
      | shipperType                  | Normal                   |
      | ocVersion                    | v4                       |
      | services                     | STANDARD                 |
      | trackingType                 | Fixed                    |
      | isAllowCod                   | true                     |
      | isAllowCashPickup            | true                     |
      | isPrepaid                    | true                     |
      | isAllowStagedOrders          | true                     |
      | isMultiParcelShipper         | true                     |
      | isDisableDriverAppReschedule | true                     |
      | pricingScriptName            | {pricing-script-name-id} |
      | industryName                 | {industry-name}          |
      | salesPerson                  | {sales-person-id}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2508 - PT Cucumber Test 2     |
      | comments          | This is a test pricing script |
      | type              | PERCENTAGE                    |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script details
    And Operator verifies the pricing script details are correct

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with special characters Discount (uid:4df9abce-e97a-4bf8-aef1-41a96c63ed76)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds pricing script with invalid discount and verifies the error message
      | pricingScriptName | 2402 - New Script                |
      | discount          | $#^$^#@                          |
      | errorMessage      | Special character is not allowed |

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with 3-5 integer after decimal point (uid:f3af5079-e704-4f9a-83d3-e4b79a463474)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20.54321                      |
      | comments          | This is a test pricing script |
      | type              | FLAT                          |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script and shipper discount details
    And Operator verifies the pricing script and shipper discount details are correct

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with shipper discount within 6 digits Flat Discount (uid:6b852274-7091-4f2f-8a3a-6fecda231d27)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 50000.00                      |
      | comments          | This is a test pricing script |
      | type              | FLAT                          |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script and shipper discount details
    And Operator verifies the pricing script and shipper discount details are correct

  @PricingProfile @DeleteShipper @CloseNewWindows
  Scenario: Create a new Pricing Profile - with shipper discount over 6 digits Flat Discount (uid:4e129004-7985-4226-a5eb-ebfa2465efe7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits the created shipper
    Then Operator adds pricing script with discount over 6 digits and verifies the error message
      | pricingScriptName | 2402 - New Script           |
      | discount          | 10000000                    |
      | comments          | This is an invalid discount |
      | errorMessage      | Failed to update            |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op