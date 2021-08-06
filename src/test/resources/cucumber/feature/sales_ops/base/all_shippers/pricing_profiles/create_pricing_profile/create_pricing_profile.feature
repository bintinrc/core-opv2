@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache  @PricingProfiles @CreatePricingProfiles @Basic
Feature: Create Pricing Profile

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


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
@nadeera
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
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 20                                              |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    Then Operator verifies that Pricing Script is "Pending" and "Active"
    And Operator edits the created shipper
    And Operator verifies that Edit Pending Profile is displayed

  Scenario: Add New Pricing Profile - Validate Start Date (uid:7ddd0223-4822-46c0-b483-aa43109921fc)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator verifies that Start Date is populated as today's date and is not editable

  Scenario: Create Pricing Profile with COD Settings and Insurance Settings (uid:e3e08035-2d35-459a-8398-7cf8dafd328d)
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
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | codMinFee           | 5.8                                         |
      | codPercentage       | 5                                           |
      | insuranceMinFee     | 10                                          |
      | insurancePercentage | 10                                          |
      | insuranceThreshold  | 10                                          |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  Scenario: Create Pricing Profile with Use Country Level COD and Insurance (uid:0bee7a3c-9c6c-4260-bd68-21d110d4c40e)
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
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
