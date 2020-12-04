@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache  @PricingProfiles @CreatePricingProfiles
Feature: All Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add New Shipper Pricing Profile (uid:79bb423b-36d1-49a0-8b22-34972253afe7)
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
    Then Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 20                                              |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  Scenario: Create a new Shipper - Create Pricing Profile (uid:78dadc9d-16ea-429f-88ff-eb472bad435f)
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

  @CloseNewWindows
  Scenario: Create a new Shipper - Create Pricing Profile and Update it before Created (uid:15c1b8b1-546f-4f30-95f4-492b86e7bd7c)
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

  @CloseNewWindows
  Scenario: Create a new Shipper - Not Creating Pricing Profile (uid:5f2fdf58-bc27-4a5f-9961-9f2b0b06f820)
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

  @CloseNewWindows @DeletePricingProfile
  Scenario: Create a new Pricing Profile - with Flat Discount where Shipper has Active & Expired Pricing Profile (uid:0e077755-8ca3-41af-8c7e-a852ab0ad0f2)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-active-expired-pp-legacy-id}"
    Then Operator verifies that Pricing Script is "Active" and "Expired"
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 20.00                                           |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows
  Scenario: Create a new Pricing Profile - where Shipper has Pending Pricing Profile (uid:a2bc5de8-87ab-43b6-a538-1829e97eddd8)
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
    Then Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 20                                              |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Pending" and "Active"
    And Operator edits the created shipper
    And Operator verifies that Edit Pending Profile is displayed

  @CloseNewWindows
  Scenario: Create a new Pricing Profile - with 0 Flat Discount (uid:e5ba2876-828e-4340-9208-d294ea2052b1)
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
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 0                                               |
      | errorMessage      | 0 is not a valid discount value                 |


  @CloseNewWindows
  Scenario: Create a new Pricing Profile - with none Flat Discount (uid:3895c1e8-58b5-4625-9175-788c133a4b92)
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
    Then Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows
  Scenario: Create a new Pricing Profile - with special characters Discount (uid:4dde3d48-2513-4c84-9b6c-4b848833d3eb)
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
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | $#^$^#@                                         |
      | errorMessage      | Special character is not allowed                |

  @CloseNewWindows
  Scenario: Create a new Pricing Profile - with 3-5 integer after decimal point (uid:30ed9502-76df-4695-8a33-f21d40dc9ad5)
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
    Then Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 20.54321                                        |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows
  Scenario: Create a new Pricing Profile - with shipper discount within 6 digits Flat Discount (uid:5e17e04a-7461-4546-9e3b-20dc2add40e6)
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
    Then Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 50000.00                                        |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows
  Scenario: Create a new Pricing Profile - with shipper discount over 6 digits Flat Discount  (uid:7e8428a0-4af4-4d08-b168-4837a8606f7d)
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
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 10000000                                        |
      | comments          | This is an invalid discount                     |
      | errorMessage      | Discounts cannot exceed 6 figures.              |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
