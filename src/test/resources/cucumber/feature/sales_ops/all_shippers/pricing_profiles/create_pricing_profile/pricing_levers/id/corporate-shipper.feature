@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesID @PricingLevers @CreatePricingProfilesID @CorporateID
Feature:  Corporate Shipper

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}" shipper's pricing profiles

  @CloseNewWindows @HappyPathID
  Scenario: Create Pricing Profile - Corporate Shipper - with none Percentage Discount - Corporate Sub Shipper has Reference Parent's Pricing Profile is Exists - ID (uid:a0b84f72-9fe9-4557-8853-d648a86ea55c)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | percentage                                  |
      | discount          | empty                                       |
      | comments          | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create Pricing Profile - Corporate Shipper - with Int Percentage Discount - Corporate Sub Shipper has Reference Parent's Pricing Profile is Exists - ID (uid:70ebb4d2-9b4c-4934-93ce-53b0037f74bd)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | percentage                                  |
      | discount          | 2.5                                         |
      | comments          | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
