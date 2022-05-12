@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesTH @UpdatePricingProfilesTH
Feature: Edit Pricing Profiles - TH

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator changes the country to "Thailand"
    And API Operator create new 'normal' shipper
    # add active pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
     # add pending pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25,"rts_charge":2}} |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, From Discount to Surcharge - Values up to 2 Decimals - TH (uid:32fa923d-d424-49a1-a7c7-fa65399a5230)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeType  | Discount |
      | rtsChargeValue | 20.25    |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | rtsChargeType  | Discount |
      | rtsChargeValue | 20.25    |

  Scenario: Edit Subshipper Pending Pricing Profile With billing_weight_logic = Standard - Parent Has billing_weight_logic = Standard - TH (uid:411f5789-6fa5-4560-986f-da0d2bfb2ff9)
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

    Given API Operator create new 'marketplace' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    Given API operator create new marketplace seller for marketplace id "{KEY_SHIPPER_ID}"
      # add pending pricing profile for the subshipper
    And Operator edits shipper "{KEY_MARKETPLACE_SUB_SHIPPER.legacyId}"
    When Operator adds new Shipper's Pricing Profile
      | startDate          | {gradle-next-2-day-yyyy-MM-dd}                      |
      | pricingScriptName  | {pricing-script-id-all} - {pricing-script-name-all} |
      | type               | PERCENTAGE                                          |
      | comments           | This is a test pricing script                       |
      | billingWeightLogic | Shipper submitted weight only                       |
    Then Operator waits for 2 seconds
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
