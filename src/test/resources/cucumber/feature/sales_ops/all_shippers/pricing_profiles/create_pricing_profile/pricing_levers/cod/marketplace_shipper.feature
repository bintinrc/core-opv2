@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @Cod @CreatePricingProfiles @Marketplace
Feature:  Create Pricing Profile - Marketplace Shippers - COD

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-sop-mktpl-v4-dummy-pricing-profile-cod-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-cod-global-id}" shipper's pricing profiles


  Scenario: Create Pricing Profile - Marketplace Shipper - with 'Int' COD Min Fee and 'Int' COD Percentage - Marketplace Sub Shipper who has their own Pricing Profile is Exists (uid:d1fa0980-1864-4484-89c0-5e4569050c6a)
    Given Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-cod-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | codMinFee         | 1                                           |
      | codPercentage     | 3                                           |
      | comments          | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
  # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-cod-legacy-id}"


  Scenario: Create Pricing Profile - Marketplace Shipper - with 'Int' COD Min Fee and 'Int' COD Percentage - Marketplace Sub Shipper who Reference Parent's Pricing Profile is Exists (uid:ec81df26-a10d-42d2-b5bc-0dc17c572026)
      #Add new pricing profile and verify - sub shipper
    Given Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | codMinFee         | 1.2                                         |
      | codPercentage     | 3                                           |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
      # Add new pricing profile - marketplace shipper
    When Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 50                                              |
      | codMinFee         | 50                                              |
      | codPercentage     | 50                                              |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page
     # Verify pricing profile is not changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator gets pricing profile values
    And Operator verifies the pricing profile details are like below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | codMinFee         | 1.2                                         |
      | codPercentage     | 3                                           |
      | comments          | This is a test pricing script               |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
