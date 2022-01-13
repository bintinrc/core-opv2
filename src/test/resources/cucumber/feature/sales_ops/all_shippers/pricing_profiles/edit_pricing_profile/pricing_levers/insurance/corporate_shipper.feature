@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @UpdatePricingProfiles @Insurance @CorporateShipper
Feature: Edit Pricing Profiles - Corporate Shippers - Insurance

  Background: Login to Operator Portal V2
    # Using the same corporate shipper used in 'Create Pricing Profile' scenarios
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-sop-corp-v4-dummy-pricing-profile-ins-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-corp-v4-dummy-pricing-profile-ins-global-id}" shipper's pricing profiles

  Scenario: Edit Pending Pricing Profile - Corporate Shipper - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage - Corporate Sub Shipper who Reference Parent's Pricing Profile is Exists (uid:9039d1db-af3f-44f6-a851-87353eceefcf)
       #Add new pricing profile and verify - corporate shipper
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-ins-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page
    #Add new pricing profile, edit and verify - corporate shipper
    And Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-ins-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee     | 10 |
      | insurancePercentage | 10 |
      | insuranceThreshold  | 10 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | insuranceMinFee     | 10 |
      | insurancePercentage | 10 |
      | insuranceThreshold  | 10 |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    #Verify pricing profile is the same as parents ACTIVE pricing profile- corporate subshipper
    And Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-ins-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-ins-legacy-id}"

  Scenario: Edit Pending Pricing Profile - Corporate Shipper - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage - Corporate Sub Shipper who has their own Pricing Profile is Exists (uid:835aa273-b9be-45ef-ac50-835cdf12fab2)
    # create a pending pricing profile for corporate shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-ins-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-ins-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    # create a pending pricing profile for corporate sub shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{sub-shipper-sop-corp-v4-dummy-pricing-profile-ins-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{sub-shipper-sop-corp-v4-dummy-pricing-profile-ins-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
      # edit pending pricing profile for corporate shipper
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-ins-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee     | 40 |
      | insurancePercentage | 40 |
      | insuranceThreshold  | 40 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-ins-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | insuranceMinFee     | 40 |
      | insurancePercentage | 40 |
      | insuranceThreshold  | 40 |
    #Verify existing pricing profile is not changed- corporate subshipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-ins-legacy-id}"
    And Operator gets pricing profile values
    And Operator verifies the pricing profile details are like below:
      | insuranceMinFee     | 2   |
      | insurancePercentage | 0.6 |
      | insuranceThreshold  | 25  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
