@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @UpdatePricingProfiles @Basic @NormalShipper
Feature: Edit Pricing Profile - Normal Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-v4-dummy-pricing-profile-basic-global-id}" shipper's pricing profiles
    # add active pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-basic-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id}} |
    And Operator waits for 1 seconds
      # add pending pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-basic-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-basic-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Edit Pricing Script ID (uid:f7f04ae2-65ba-45a8-8627-79f732fae1a2)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Edit Start Date / End Date (uid:86101231-638d-4d38-917d-79dbb1b1d07d)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | startDate | {gradle-next-3-day-yyyy-MM-dd}  |
      | endDate   | {gradle-next-10-day-yyyy-MM-dd} |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | startDate | {gradle-next-3-day-yyyy-MM-dd}  |
      | endDate   | {gradle-next-10-day-yyyy-MM-dd} |

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Edit Pending Pricing Profile With billing_weight_logic = Standard - Normal Shipper
    And API Operator create new 'normal' shipper
    # add active pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    # add pending pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25,"rts_charge":-2,"billing_weight_logic" : "STANDARD"}} |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee | 10 |
    And Operator verifies that Billing Weight Logic is not available in the Edit Pricing Profile dialog
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Edit Subshipper Pending Pricing Profile With billing_weight_logic = SHIPPER_GROSS_WEIGHT - Parent Has billing_weight_logic = Standard (uid:3deb28ae-e5e3-438e-8b15-c7b2a51ade23)
    Given API Operator create new 'marketplace' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    Given API operator create new marketplace seller for marketplace id "{KEY_SHIPPER_ID}"
      # add pending pricing profile for the subshipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_MARKETPLACE_SUB_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25,"rts_charge":-2,"billing_weight_logic" : "SHIPPER_GROSS_WEIGHT"}} |
    And Operator edits shipper "{KEY_MARKETPLACE_SUB_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee | 10 |
    And Operator verifies that Billing Weight Logic is not available in the Edit Pricing Profile dialog
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
