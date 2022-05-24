@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesVN @UpdatePricingProfilesVN
Feature: Edit Pricing Profiles - VN

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator changes the country to "Vietnam"


  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, From Surcharge to Discount - VN (uid:8211af8c-4f6e-444c-a71f-d95429497f0a)
    Given API Operator create new 'normal' shipper
    # add active pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    # add pending pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25,"rts_charge":2}} |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeType  | Discount |
      | rtsChargeValue | 20       |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | rtsChargeType  | Discount |
      | rtsChargeValue | 20       |

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Edit Pending Pricing Profile With billing_weight_logic = SHIPPER_GROSS_WEIGHT - Normal Shipper - VN (uid:a51593e8-d528-443a-8918-f70a5daf1281)
    And API Operator create new 'normal' shipper
    # add active pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    # add pending pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25,"rts_charge":-2,"billing_weight_logic" : "SHIPPER_GROSS_WEIGHT"}} |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
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
