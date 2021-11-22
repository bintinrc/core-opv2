@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @UpdatePricingProfiles @Cod @CorporateShipper
Feature: Edit Pricing Profiles - Corporate Shippers - COD

  Background: Login to Operator Portal V2
    # Using the same corporate shipper used in 'Create Pricing Profile' scenarios
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-sop-corp-v4-dummy-pricing-profile-cod-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-corp-v4-dummy-pricing-profile-cod-global-id}" shipper's pricing profiles


  Scenario: Edit Pending Pricing Profile - Corporate Shipper - with 'Int' COD Min Fee and 'Int' COD Percentage - Corporate Sub Shipper who Reference Parent's Pricing Profile is Exists (uid:b22ccb61-e64c-4f85-8a2e-9c8cb5ddfe72)
       #Add new pricing profile and verify - corporate shipper
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | codMinFee         | 1.2                                         |
      | codPercentage     | 3                                           |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page
    #Add new pricing profile, edit and verify - corporate shipper
    And Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 1                                           |
      | codMinFee         | 5                                           |
      | codPercentage     | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee     | 10 |
      | codPercentage | 10 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | codMinFee     | 10 |
      | codPercentage | 10 |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    #Verify pricing profile is the same as parents ACTIVE pricing profile- corporate subshipper
    And Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"

  Scenario: Edit Pending Pricing Profile - Corporate Shipper - with 'Int' COD Min Fee and 'Int' COD Percentage - Corporate Sub Shipper who has their own Pricing Profile is Exists (uid:7cb8c1c8-7ca4-4a57-8931-29a58b9c8f9f)
    #Add new pricing profile and verify - corporate shipper
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | codMinFee         | 20                                          |
      | codPercentage     | 20                                          |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page
      #Add new pricing profile and verify - corporate sub shipper
    And Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 30                                          |
      | codMinFee         | 30                                          |
      | codPercentage     | 30                                          |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    #Add new pricing profile, edit and verify - corporate shipper
    And Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 40                                          |
      | codMinFee         | 40                                          |
      | codPercentage     | 40                                          |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee     | 40 |
      | codPercentage | 40 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    #Verify existing pricing profile is not changed- corporate subshipper
    And Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-cod-legacy-id}"
    And Operator gets pricing profile values
    And Operator verifies the pricing profile details are like below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 30                                          |
      | codMinFee         | 30                                          |
      | codPercentage     | 30                                          |
      | comments          | This is a test pricing script               |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
