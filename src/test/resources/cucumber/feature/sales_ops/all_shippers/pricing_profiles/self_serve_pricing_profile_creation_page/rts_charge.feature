@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @SelfServePricingProfile
Feature: RTS

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to this URL "{upload-self_serve-promo-url}"


  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - Failed Create Pricing Profiles with RTS Settings - Upload pricing profile error (uid:ffae0424-65cc-4acc-97c9-7199f1162d7f)
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts    | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100    | {empty}   | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 10@#%0 | surcharge | 3              | 4           | 1.5                  | 20                | 1.5                 | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100    | abc       | 4              | 4           | 1.5                  | 20                | 1.5                 | LEGACY               |
    Then Operator verifies toast message "File is invalid" in Upload Self Serve Promo Page
    Then Operator clicks Download Errors CSV on Upload Self Serve Promo Page
    Then Operator verify Download Errors CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | column         | description                                                                            |
      | 2   | {KEY_LEGACY_SHIPPER_ID} | rts_type       | rts_type not found or value is not as SURCHARGE/DISCOUNT when rts_type is provided     |
      | 3   | {KEY_LEGACY_SHIPPER_ID} | rts            | "rts is not a number or not a ""[country default]"" value"                                 |
      | 4   | {KEY_LEGACY_SHIPPER_ID} | rts_type       | rts_type not found or value is not as SURCHARGE/DISCOUNT when rts_type is provided     |
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"

  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - Failed Create Pricing Profiles with RTS Settings - Pricing profile validation error (uid:b8de150b-5e7b-4ba3-973c-da130160c42a)
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 120 | surcharge | 3              | 4           | 20                   | 20                | 10                  | LEGACY               |
    Then Operator verifies toast message "Validate file successfully" in Upload Self Serve Promo Page
    Then Operator clicks submit button on the Upload Self Serve Promo Page
    Then Operator verifies that error toast is displayed on Upload Self Serve Promo Page:
      | top    | Network Request Error                                |
      | bottom | RTS Charge must be in between -100% and 100%.        |
    Then Operator clicks Download Error Upload Pricing Profile CSV on Upload Self Serve Promo Page
    Then Operator verify Download Error Upload Pricing Profile CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | global_id        | message                                              | reason           |
      | 2   | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | RTS Charge must be in between -100% and 100%.        | Validation Error |
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"

  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - RTS Charge, Surcharge and RTS Charge, Discount (uid:11269b06-3bb8-4595-bdda-65a4ebe027f9)
     # shipper 1
    Given API Operator create new 'normal' shipper
    # shipper 2
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id                                 | global_id                            | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LIST_OF_CREATED_SHIPPERS[1].legacyId} | {KEY_LIST_OF_CREATED_SHIPPERS[1].id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 20  | surcharge | 3              | 4           | 20                   | 20                | 10                  | LEGACY               |
      | {KEY_LIST_OF_CREATED_SHIPPERS[2].legacyId} | {KEY_LIST_OF_CREATED_SHIPPERS[2].id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 20  | discount  | 3              | 4           | 1.5                  | 20                | 1.5                 | LEGACY               |
    And Operator waits for 1 seconds
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}"
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[2].id}"
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
