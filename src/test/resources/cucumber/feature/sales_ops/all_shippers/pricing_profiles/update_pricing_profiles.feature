@OperatorV2 @Shipper @OperatorV2Part2 @AllShippers @Saas @PricingProfiles
Feature: Pricing Profiles

  @LaunchBrowser @ShouldAlwaysRun @EnableClearCache
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipper @CloseNewWindows
  Scenario: Update an Existing Pricing Profile - with 0 Flat Discount (uid:7764257b-02ad-41d6-99df-1a52e9c7f01f)
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
  Scenario: Update an Existing Pricing Profile - with 0 Percentage Discount (uid:8fa73f4b-69a1-4ce0-927a-82b2be6ace0c)
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
  Scenario: Update an Existing Pricing Profile - with none Flat Discount (uid:df20d395-ed05-4890-a5c9-a9d287fd9251)
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
  Scenario: Update an Existing Pricing Profile - with none Percentage Discount (uid:cdf6e3e4-da77-4867-bca0-ae734b97ad21)
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
  Scenario: Update an Existing Pricing Profile - with special characters Discount (uid:35faef0b-1dc5-41d3-8c25-e623af2fbbde)
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
  Scenario: Update an Existing Pricing Profile - with 3-5 integer after decimal point (uid:ed2da24e-c989-435f-9202-1fe5e69d9b30)
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
  Scenario: Update an Existing Pricing Profile - with shipper discount within 6 digits Flat Discount (uid:0fd13d01-2339-4358-b177-c5e463da15af)
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
  Scenario: Update an Existing Pricing Profile - with shipper discount over 6 digits Flat Discount (uid:aaa6dc52-ffc5-42ec-8f64-80ebd4eb23cf)
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

  @DeleteShipper @CloseNewWindows
  Scenario: Pricing Profile for TH (without Discount Value) - Create new Pricing Profile (uid:f350a950-3a1b-4814-83a9-6f84e5f41d32)
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
      | endDate       | {gradle-next-2-day-yyyy-MM-dd} |
      | pricingScript | {pricing-script-name}          |
      | comments      | new Pricing Profile            |
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
      | comments                | new Pricing Profile            |

  @DeleteShipper @CloseNewWindows
  Scenario: Pricing Profile for TH (without Discount Value) - Update an Existing Pending Profile
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
      | comments      | new Pricing Profile            |
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | startDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate       | {gradle-next-2-day-yyyy-MM-dd} |
      | discountValue | none                           |
      | comments      | updated Pricing Profile        |
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

  @PricingProfile
  Scenario: Edit Shipper Pricing Profile (uid:f350a950-3a1b-4814-83a9-6f84e5f41d32)
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
