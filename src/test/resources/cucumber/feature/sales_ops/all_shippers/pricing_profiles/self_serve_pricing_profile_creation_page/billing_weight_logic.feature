@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @SelfServePricingProfile @mad
Feature: Billing Weight Logic

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to this URL "{upload-self_serve-promo-url}"


  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - Failed Create Pricing Profiles with Billing Weight Logic (uid:eb9203cd-6ab1-496f-961f-73652ccfc1e2)
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts    | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 10     | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | EMPTY                |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 10     | surcharge | 3              | 4           | 1.5                  | 20                | 1.5                 | INVALID              |
    Then Operator verifies toast message "File is invalid" in Upload Self Serve Promo Page
    Then Operator clicks Download Errors CSV on Upload Self Serve Promo Page
    Then Operator verify Download Errors CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | column                     | description                                                                                                                   |
      | 2   | {KEY_LEGACY_SHIPPER_ID} | billing_weight_logic       | "billing_weight_logic should be one of these values ""LEGACY"", ""STANDARD"", ""SHIPPER_GROSS_WEIGHT"", ""GROSS_WEIGHT"""     |
      | 3   | {KEY_LEGACY_SHIPPER_ID} | billing_weight_logic       | "billing_weight_logic should be one of these values ""LEGACY"", ""STANDARD"", ""SHIPPER_GROSS_WEIGHT"", ""GROSS_WEIGHT"""     |
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"


  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV With Billing Weight Logic (uid:80e22696-fa30-449c-bcf4-c14bd56e9f0b)
     # shipper 1
    Given API Operator create new 'normal' shipper
    # shipper 2
    Given API Operator create new 'normal' shipper
    # shipper 3
    Given API Operator create new 'normal' shipper
    # shipper 4
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id                                 | global_id                            | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LIST_OF_CREATED_SHIPPERS[1].legacyId} | {KEY_LIST_OF_CREATED_SHIPPERS[1].id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 20  | surcharge | 3              | 4           | 20                   | 20                | 10                  | LEGACY               |
      | {KEY_LIST_OF_CREATED_SHIPPERS[2].legacyId} | {KEY_LIST_OF_CREATED_SHIPPERS[2].id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 20  | discount  | 3              | 4           | 1.5                  | 20                | 1.5                 | GROSS_WEIGHT         |
      | {KEY_LIST_OF_CREATED_SHIPPERS[3].legacyId} | {KEY_LIST_OF_CREATED_SHIPPERS[3].id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 20  | surcharge | 3              | 4           | 20                   | 20                | 10                  | SHIPPER_GROSS_WEIGHT |
      | {KEY_LIST_OF_CREATED_SHIPPERS[4].legacyId} | {KEY_LIST_OF_CREATED_SHIPPERS[4].id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 20  | discount  | 3              | 4           | 1.5                  | 20                | 1.5                 | STANDARD             |
    And Operator waits for 1 seconds
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}"
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[2].id}"
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[3].id}"
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[4].id}"
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
