@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @EditPricingProfiles @Corporate

Feature: Corporate Shipper

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator go to menu Shipper -> All Shippers
    And DB Operator deletes "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}" shipper's pricing profiles

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Corporate Sub Shipper - Edit Discount (uid:6d3ff955-f76f-4e97-99f3-42392917000e)
    Given Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 3.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 7.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 1.2 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | discount | 1.2 |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Corporate Shipper - Edit Discount - Corporate Sub Shipper who Reference Pricing Profile from Parent is exists (uid:dbd624e8-a0f7-4fed-a8af-34db8d14b184)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 3.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 7.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 1.2 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | discount | 1.2 |
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    Then Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Corporate Shipper - Edit Pricing Script ID - Corporate Sub Shipper who Reference Pricing Profile from Parent is exists (uid:d83486a9-6fca-42d4-aa8f-010e2a93bc56)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 3.0                                         |
      | comments          | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 7.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    Then Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Corporate Shipper - Edit Discount - Corporate Sub Shipper who has their own Pricing Profile exists (uid:d979aa96-eeef-44a1-8bc1-15b947adbcff)
    Given Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 3.0                                         |
      | comments          | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 5.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 1.2 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | discount | 1.2 |
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator gets pricing profile values
    And Operator verifies the pricing profile details are like below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 3.0                                         |
      | comments          | This is a test pricing script               |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Corporate Shipper - Edit Pricing Script ID - Corporate Sub Shipper who has their own Pricing Profile exists (uid:e8ec1a31-551e-4942-865c-2f2b8cefae5d)
    Given Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 1.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 3.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator gets pricing profile values
    And Operator verifies the pricing profile details are like below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 1.0                                             |
      | comments          | This is a test pricing script                   |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile for Corporate Sub Shipper who has their own Pending Pricing Profile - Corporate Shipper has Pending Pricing Profile (uid:236faff3-3caf-4368-ac77-de99f73cd683)
    Given Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 7.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 5.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 3.0                                         |
      | comments          | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 1.2 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | discount | 1.2 |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile for Corporate Sub Shipper who Reference Parent's Pending Pricing Profile (uid:03a6d3ae-8eb1-40a9-a54c-6ef39cb90251)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 3.0                                         |
      | comments          | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 7.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    Then Operator verifies that Add New Pricing Profile Button is displayed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op