@OperatorV2 @Shipper @OperatorV2Part2 @AllShippers @Saas @LaunchBrowser @ShouldAlwaysRun @EnableClearCache
Feature: All Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @PricingProfile
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
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20                            |
      | comments          | This is a test pricing script |

  @PricingProfile
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

  @PricingProfile  @CloseNewWindows
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

#  TODO
  @todo @PricingProfile  @CloseNewWindows
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

  # TODO : ask audia whether this is a viable option (having active and expired)
  @todo @PricingProfile  @CloseNewWindows
  Scenario: Create a new Pricing Profile - with Flat Discount where Shipper has Active & Expired Pricing Profile (uid:0e077755-8ca3-41af-8c7e-a852ab0ad0f2)
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
    And Operator save changes on Edit Shipper Page
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

  @todo # TODO : ask audia whether this is a viable option (having active and expired)
  Scenario: Create a new Pricing Profile - with Percentage Discount where Shipper has Active & Expired Pricing Profile (uid:bafe6400-ee59-4068-9e6d-fc3395ac7a8a)
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


  @PricingProfile  @CloseNewWindows
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
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | discount          | 20                            |
      | comments          | This is a test pricing script |
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Pending" and "Active"
    And Operator edits the created shipper
    And Operator verifies that Edit Pending Profile is displayed


  @PricingProfile  @CloseNewWindows
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
      | pricingScriptName | 2402 - New Script               |
      | discount          | 0                               |
      | errorMessage      | 0 is not a valid discount value |


  @PricingProfile  @CloseNewWindows @ResetCountry
  Scenario: Create a new Pricing Profile - with 0 Percentage Discount (uid:71f8c382-2c78-4ba7-b052-ada13861d606)
    Given Operator changes the country to "Indonesia"
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

  @PricingProfile  @CloseNewWindows
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
    Then Operator adds new Shipper's Pricing Script
      | pricingScriptName | 2402 - New Script             |
      | comments          | This is a test pricing script |
      | type              | FLAT                          |
    And Operator save changes on Edit Shipper Page
    Then DB Operator fetches pricing script details
    And Operator verifies the pricing script details are correct


  @todo @PricingProfile  @CloseNewWindows @ResetCountry
  Scenario: Create a new Pricing Profile - with none Percentage Discount (uid:67f49a74-87a8-4db8-b1a7-7787f4dd70e9)
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

  @PricingProfile  @CloseNewWindows
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
      | pricingScriptName | 2402 - New Script                |
      | discount          | $#^$^#@                          |
      | errorMessage      | Special character is not allowed |

  @PricingProfile  @CloseNewWindows
  Scenario: Create a new Pricing Profile - with 3-5 integer after decimal point (uid:30ed9502-76df-4695-8a33-f21d40dc9ad5)
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

  @PricingProfile  @CloseNewWindows
  Scenario: Create a new Pricing Profile - with shipper discount within 6 digits Flat Discount (uid:5e17e04a-7461-4546-9e3b-20dc2add40e6)
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

  @PricingProfile  @CloseNewWindows
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
    Then Operator adds pricing script with discount over 6 digits and verifies the error message
      | pricingScriptName | 2402 - New Script           |
      | discount          | 10000000                    |
      | comments          | This is an invalid discount |
      | errorMessage      | Failed to update            |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
