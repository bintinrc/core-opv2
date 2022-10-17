@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @SelfServePricingProfile
Feature: Shipper Delivery Discount

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to this URL "{upload-self_serve-promo-url}"


  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Not Include salesperson_discount and discount_type value (uid:985562d2-874d-4295-bf3a-16c56433e3dd)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | {empty}              | {empty}       | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
    And Operator waits for 1 seconds
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"
    Then Operator verifies shipper discount details is null
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Failed Create Pricing Profiles with Discount - Upload pricing profile error (uid:04dea1d9-d257-4582-8a17-356b9baa7dc4)
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | {empty}       | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | INVALID       | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10000000.00          | FLAT          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | -5                   | FLAT          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
    Then Operator verifies error message "File is invalid" in Upload Self Serve Promo Page
    Then Operator clicks Download Errors CSV on Upload Self Serve Promo Page
    Then Operator verify Download Errors CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | column               | description                                                                                      |
      | 2   | {KEY_LEGACY_SHIPPER_ID} | discount_type        | discount_type not found or value is not as FLAT/PERCENTAGE when salesperson_discount is provided |
      | 3   | {KEY_LEGACY_SHIPPER_ID} | discount_type        | discount_type not found or value is not as FLAT/PERCENTAGE when salesperson_discount is provided |
      | 4   | {KEY_LEGACY_SHIPPER_ID} | salesperson_discount | salesperson_discount has value greater than 6 figures. Discounts cannot exceed 6 figures.        |
      | 5   | {KEY_LEGACY_SHIPPER_ID} | salesperson_discount | salesperson_discount has invalid salesperson_discount value                                      |
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"


  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - Failed Create Pricing Profiles with Discount - Pricing profile validation error (uid:9fe6419d-e010-472b-a308-dc3f40d19e9a)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | percentage    | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
    Then Operator clicks submit button on the Upload Self Serve Promo Page
    Then Operator verifies that error toast is displayed on Upload Self Serve Promo Page:
      | top    | Network Request Error                                          |
      | bottom | Discount type (PERCENTAGE) is not applicable for (sg) country. |


  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing with Profiles CSV - Success Create Pricing Profiles - Input Salesperson Discount 0 (uid:a3ac1d57-fb6d-4f43-8851-c35aa0df6449)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 0                    | flat          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
    And Operator waits for 1 seconds
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"
    Then Operator verifies shipper discount details is null
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database