@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @Cod @CreatePricingProfiles @Corporate
Feature:  Create Pricing Profile - Corporate Shippers - COD

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-sop-corp-v4-dummy-pricing-profile-cod-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-corp-v4-dummy-pricing-profile-cod-global-id}" shipper's pricing profiles

  Scenario: Create Pricing Profile - Corporate Shipper - with 'Int' COD Min Fee and 'Int' COD Percentage - Corporate Sub Shipper who Reference Parent's Pricing Profile is Exists (uid:40ca4247-a8b7-44a6-b64a-75624eeb39a7)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | codMinFee         | 1.2                                         |
      | codPercentage     | 3                                           |
      | comments          | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
      # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"

  Scenario: Create Pricing Profile - Corporate Shipper - with 'Int' COD Min Fee and 'Int' COD Percentage - Corporate Sub Shipper who has their own Pricing Profile is Exists (uid:2f635c7a-245f-4c1c-903b-715b30b535f0)
    # Add new pricing profile and verify - sub shipper
    Given Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
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
      # Add new pricing profile and verify - coprorate shipper
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 50                                              |
      | codMinFee         | 50                                              |
      | codPercentage     | 50                                              |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
      # Verify pricing profile is not changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
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
