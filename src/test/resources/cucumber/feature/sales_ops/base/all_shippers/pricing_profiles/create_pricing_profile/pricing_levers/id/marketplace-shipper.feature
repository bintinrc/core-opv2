@OperatorV2 @LaunchBrowser @PricingScriptsV2ID @SalesOpsID
Feature: Marketplace Shipper

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Indonesia"
    And Operator go to menu Shipper -> All Shippers
    And DB Operator deletes "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-global-id}" shipper's pricing profiles

  @CloseNewWindows
  Scenario: Create Pricing Profile - Marketplace Shipper - with none Percentage Discount - Marketplace Sub Shipper has Reference Parent's Pricing Profile is Exists - ID (uid:5e639445-c303-4926-bc31-8cf566143708)
    Given Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | PERCENTAGE                                  |
      | discount          | blank                                       |
      | comments          | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create Pricing Profile - Marketplace Shipper - with Int Percentage Discount - Marketplace Sub Shipper has Reference Parent's Pricing Profile is Exists - ID
    Given Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | PERCENTAGE                                  |
      | discount          | 2.5                                         |
      | comments          | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id}"