@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @SelfServePricingProfileTH
Feature: Self-Serve Pricing Profile Creation Page -TH

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to this URL "{upload-self_serve-promo-url}"


  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Success Create Pricing Profiles with All Pricing Levers - TH (uid:a4e4ee46-94a9-4ebf-99fe-1df2a59882e8)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | percentage    | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details in CSV are correct
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database