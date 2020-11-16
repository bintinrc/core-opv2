@OperatorV2 @Shipper @OperatorV2Part2 @AllShippers @Saas @PricingProfiles @LaunchBrowser @ShouldAlwaysRun @EnableClearCache
Feature: Pricing Profiles

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Update an Existing Pricing Profile - with 0 Percentage Discount (uid:8fa73f4b-69a1-4ce0-927a-82b2be6ace0c)
    Given Operator changes the country to "Indonesia"
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
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate       | {gradle-next-1-day-yyyy-MM-dd} |
      | pricingScript | {pricing-script-name}          |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName             | {KEY_CREATED_SHIPPER.name}     |
      | startDate               | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate                 | {gradle-next-1-day-yyyy-MM-dd} |
      | pricingScript           | {pricing-script-name}          |
      | salespersonDiscountType | Percentage                     |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discountValue | 0 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | discountValue | 0 is not a valid discount value |

#  @nadeera
  @CloseNewWindows
  Scenario: Update an Existing Pricing Profile - with none Percentage Discount (uid:cdf6e3e4-da77-4867-bca0-ae734b97ad21)
    Given Operator changes the country to "Indonesia"
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
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate       | {gradle-next-1-day-yyyy-MM-dd} |
      | pricingScript | {pricing-script-name}          |
      | discountValue | 10                             |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName             | {KEY_CREATED_SHIPPER.name}     |
      | startDate               | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate                 | {gradle-next-1-day-yyyy-MM-dd} |
      | pricingScript           | {pricing-script-name}          |
      | salespersonDiscountType | Percentage                     |
      | discountValue           | 10                             |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | startDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate       | {gradle-next-2-day-yyyy-MM-dd} |
      | pricingScript | {pricing-script-name-2}        |
      | discountValue | none                           |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName             | {KEY_CREATED_SHIPPER.name}     |
      | startDate               | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate                 | {gradle-next-2-day-yyyy-MM-dd} |
      | pricingScript           | {pricing-script-name-2}        |
      | salespersonDiscountType | Percentage                     |
      | discountValue           | none                           |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
