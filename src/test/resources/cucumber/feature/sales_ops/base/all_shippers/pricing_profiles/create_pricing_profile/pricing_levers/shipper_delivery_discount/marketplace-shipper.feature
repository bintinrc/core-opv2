@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @CreatePricingProfiles @DeliveryDiscount
Feature: Marketplace Shipper

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator go to menu Shipper -> All Shippers
    And DB Operator deletes "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-global-id}" shipper's pricing profiles

  @CloseNewWindows
  Scenario: Create a new Marketplace Shipper - Create Pricing Profile (uid:bc736a20-01fe-40d6-8839-dc7dcdf4c5d7)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive                     | true                  |
      | shipperType                         | Marketplace           |
      | ocVersion                           | v4                    |
      | services                            | STANDARD              |
      | trackingType                        | Fixed                 |
      | isAllowCod                          | true                  |
      | isAllowCashPickup                   | true                  |
      | isPrepaid                           | true                  |
      | isAllowStagedOrders                 | true                  |
      | isMultiParcelShipper                | true                  |
      | isDisableDriverAppReschedule        | true                  |
      | pricingScriptName                   | {pricing-script-name} |
      | industryName                        | {industry-name}       |
      | salesPerson                         | {sales-person}        |
      | marketplace.ocVersion               | v4                    |
      | marketplace.selectedOcServices      | 3DAY                  |
      | marketplace.trackingType            | Dynamic               |
      | marketplace.premiumPickupDailyLimit | 2                     |
    And Operator edits the created shipper
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 2.00                                            |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows
  Scenario: Create Pricing Profile - Marketplace Shipper - with Int Flat Discount - Marketplace Sub Shipper has Reference Parent's Pricing Profile is Exists (uid:dfc8f16a-2241-49af-a093-2e8c68474b6d)
    Given Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 2                                               |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create Pricing Profile - Marketplace Shipper - with none Flat Discount - Marketplace Sub Shipper who has Reference Parent's Pricing Profile is Exists (uid:a5a265cd-55f7-44ce-9b50-ae07b4099275)
    Given Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | blank                                           |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create Pricing Profile - Marketplace Shipper - with Int Flat Discount - Marketplace Sub Shipper has their own Pricing Profile is Exists (uid:b5efa546-54c8-4aac-ab34-ae5bd433d7f3)
      #Add new pricing profile and verify - sub shipper
    Given Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 20                                              |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
      # Add new pricing profile - marketplace shipper
    When Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 50                                              |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page
     # Verify pricing profile is not changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator gets pricing profile values
    And Operator verifies the pricing profile details are like below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 20                                              |
      | comments          | This is a test pricing script                   |

  @CloseNewWindows
  Scenario: Create a new Marketplace Sub Shipper - Reference Pricing Profile from Marketplace (Parent) Shipper who has Active Pricing Profile (uid:5a025aea-6165-4a6e-87ba-897dbf1c3235)
    Given Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | blank                                           |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create a new Marketplace Sub Shipper - Reference Pricing Profile from Marketplace (Parent) Shipper who has Active and Expired Pricing Profile (uid:fd312c5f-362c-45c4-99f2-e69e126409a4)
    Given Operator edits shipper "{sub-shipper-sop-mktpl-active-exp-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    Then Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-mktpl-active-exp-v4-dummy-pricing-profile-delivery-discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create Pricing Profile - Marketplace Sub Shipper - with none Flat Discount (uid:686a4f19-8cde-454b-8141-ef7c1eb273a4)
    Given Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | blank                                           |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | blank                                           |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator verifies that Edit Pending Profile is displayed

  @CloseNewWindows
  Scenario: Create Pricing Profile - Marketplace Sub Shipper - with Int Flat Discount (uid:120c85d0-0ef0-460f-9fa8-eb932b43c9c8)
    Given Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 2.00                                            |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-3} - {pricing-script-name-3} |
      | type              | FLAT                                            |
      | discount          | 2.00                                            |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator verifies that Edit Pending Profile is displayed