@OperatorV2 @Shipper @OperatorV2Part2 @AllShippers @Saas
Feature: Pricing Profiles

  @LaunchBrowser @ShouldAlwaysRun @EnableClearCache
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipper @CloseNewWindows
  Scenario: Update an Existing Pricing Profile - with 0 Flat Discount
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
      | salespersonDiscountType | Flat                           |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discountValue | 0 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | discountValue | 0 is not a valid discount value |

  @DeleteShipper @CloseNewWindows @ResetCountry
  Scenario: Update an Existing Pricing Profile - with 0 Percentage Discount
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
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate       | {gradle-next-1-day-yyyy-MM-dd} |
      | pricingScript | {pricing-script-name-id}       |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName             | {KEY_CREATED_SHIPPER.name}     |
      | startDate               | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate                 | {gradle-next-1-day-yyyy-MM-dd} |
      | pricingScript           | {pricing-script-name-id}       |
      | salespersonDiscountType | Percentage                     |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discountValue | 0 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | discountValue | 0 is not a valid discount value |

  @DeleteShipper @CloseNewWindows
  Scenario: Update an Existing Pricing Profile - with none Flat Discount
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
      | salespersonDiscountType | Flat                           |
      | discountValue           | 10                             |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | startDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate       | {gradle-next-2-day-yyyy-MM-dd} |
      | discountValue | none                           |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName             | {KEY_CREATED_SHIPPER.name}     |
      | startDate               | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate                 | {gradle-next-2-day-yyyy-MM-dd} |
      | pricingScript           | {pricing-script-name}          |
      | salespersonDiscountType | Flat                           |
      | discountValue           | none                           |

  @DeleteShipper @CloseNewWindows @ResetCountry
  Scenario: Update an Existing Pricing Profile - with none Percentage Discount
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
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate       | {gradle-next-1-day-yyyy-MM-dd} |
      | pricingScript | {pricing-script-name-id}       |
      | discountValue | 10                             |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName             | {KEY_CREATED_SHIPPER.name}     |
      | startDate               | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate                 | {gradle-next-1-day-yyyy-MM-dd} |
      | pricingScript           | {pricing-script-name-id}       |
      | salespersonDiscountType | Percentage                     |
      | discountValue           | 10                             |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | startDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate       | {gradle-next-2-day-yyyy-MM-dd} |
      | pricingScript | {pricing-script-name-id-2}     |
      | discountValue | none                           |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName             | {KEY_CREATED_SHIPPER.name}     |
      | startDate               | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate                 | {gradle-next-2-day-yyyy-MM-dd} |
      | pricingScript           | {pricing-script-name-id-2}     |
      | salespersonDiscountType | Percentage                     |
      | discountValue           | none                           |

  @DeleteShipper @CloseNewWindows
  Scenario: Update an Existing Pricing Profile - with special characters Discount
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
      | salespersonDiscountType | Flat                           |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discountValue | $#^$^#@5 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | discountValue | Special character is not allowed |

  @DeleteShipper @CloseNewWindows
  Scenario: Update an Existing Pricing Profile - with 3-5 integer after decimal point
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
      | salespersonDiscountType | Flat                           |
      | discountValue           | 10                             |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | startDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate       | {gradle-next-2-day-yyyy-MM-dd} |
      | discountValue | 4.38656                        |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName             | {KEY_CREATED_SHIPPER.name}     |
      | startDate               | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate                 | {gradle-next-2-day-yyyy-MM-dd} |
      | pricingScript           | {pricing-script-name}          |
      | salespersonDiscountType | Flat                           |
      | discountValue           | 4.38656                        |

  @DeleteShipper @CloseNewWindows
  Scenario: Update an Existing Pricing Profile - with shipper discount within 6 digits Flat Discount
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
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate       | {gradle-next-1-day-yyyy-MM-dd} |
      | pricingScript | {pricing-script-name}          |
      | discountValue | 10                             |
      | comments      | This is a test pricing script  |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName             | {KEY_CREATED_SHIPPER.name}     |
      | startDate               | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate                 | {gradle-next-1-day-yyyy-MM-dd} |
      | pricingScript           | {pricing-script-name}          |
      | salespersonDiscountType | Flat                           |
      | discountValue           | 10                             |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-2-day-yyyy-MM-dd} |
      | discount  | 50000                          |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName             | {KEY_CREATED_SHIPPER.name}     |
      | startDate               | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate                 | {gradle-next-2-day-yyyy-MM-dd} |
      | pricingScript           | {pricing-script-name}          |
      | salespersonDiscountType | Flat                           |
      | discountValue           | 50000                          |

  @DeleteShipper @CloseNewWindows
  Scenario: Update an Existing Pricing Profile - with special characters Discount
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
      | salespersonDiscountType | Flat                           |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discountValue | 10000000 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | discountValue | Failed to update |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
