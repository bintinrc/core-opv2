@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @Insurance @CreatePricingProfiles @Marketplace
Feature:  Create Pricing Profile - Marketplace Shippers - Insurance

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator go to menu Shipper -> All Shippers
    And DB Operator deletes "{shipper-sop-mktpl-v4-dummy-pricing-profile-ins-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-ins-global-id}" shipper's pricing profiles


  Scenario: Create Pricing Profile - Marketplace Shipper - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage - Marketplace Sub Shipper who Reference Parent's Pricing Profile is Exists (uid:942b3175-b0ff-4830-88be-22103cc72579)
    Given Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-ins-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-ins-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-ins-legacy-id}"

@nadeera
  Scenario: Create Pricing Profile - Marketplace Shipper - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage - Marketplace Sub Shipper who has their own Pricing Profile is Exists (uid:fcff8a4f-a805-4cdf-ad99-8b1bad56f105)
      #Add new pricing profile and verify - sub shipper
    Given Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-ins-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
      # Add new pricing profile - marketplace shipper
    When Operator edits shipper "{shipper-sop-mktpl-v4-dummy-pricing-profile-ins-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName   | {pricing-script-id-2} - {pricing-script-name-2} |
      | type                | FLAT                                            |
      | discount            | 50                                              |
      | insuranceMinFee     | 50                                              |
      | insurancePercentage | 50                                              |
      | insuranceThreshold  | 50                                              |
      | comments            | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page
     # Verify pricing profile is not changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-mktpl-v4-dummy-pricing-profile-ins-legacy-id}"
    And Operator gets pricing profile values
    And Operator verifies the pricing profile details are like below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |

