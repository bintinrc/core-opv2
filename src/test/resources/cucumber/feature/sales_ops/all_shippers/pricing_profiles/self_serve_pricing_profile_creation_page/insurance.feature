@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @SelfServePricingProfile
Feature: INSURANCE

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to this URL "{upload-self_serve-promo-url}"

  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - Failed Create Pricing Profiles with Insurance Settings - Upload pricing profile error (uid:c67ef533-9e92-4aff-a988-d9aa2ee2222b)
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 3              | 4           | {empty}              | 20                | 10                  | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | {empty}             | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 3              | 4           | 1.5                  | {empty}           | 10                  | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 100000000000.00     | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 3              | 4           | 1.5                  | -20               | 10                  | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 3              | 4           | -1.5                 | 20                | 10                  | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | -10                 | LEGACY               |
    Then Operator verifies error message "File is invalid" in Upload Self Serve Promo Page
    Then Operator clicks Download Errors CSV on Upload Self Serve Promo Page
    Then Operator verify Download Errors CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | column               | description                                                            |
      | 2   | {KEY_LEGACY_SHIPPER_ID} | insurance_percentage | insurance_percentage should not be blank                               |
      | 3   | {KEY_LEGACY_SHIPPER_ID} | insurance_threshold  | insurance_threshold should not be blank                                |
      | 4   | {KEY_LEGACY_SHIPPER_ID} | insurance_min_fee    | insurance_min_fee should not be blank                                  |
      | 5   | {KEY_LEGACY_SHIPPER_ID} | insurance_threshold  | insurance_threshold is invalid format. Value cannot exceed 10 figures. |
      | 6   | {KEY_LEGACY_SHIPPER_ID} | insurance_min_fee    | insurance_min_fee is invalid format. Negative value is not allowed.    |
      | 7   | {KEY_LEGACY_SHIPPER_ID} | insurance_percentage | insurance_percentage is invalid format. Negative value is not allowed. |
      | 8   | {KEY_LEGACY_SHIPPER_ID} | insurance_threshold  | insurance_threshold is invalid format. Negative value is not allowed.  |
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"


  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - Failed Create Pricing Profiles with Insurance Settings - Pricing profile validation error (uid:a071e5e4-8e7c-453c-9699-2e63d8a723ad)
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 3              | 4           | 200                  | 20                | 10                  | LEGACY               |
    Then Operator clicks submit button on the Upload Self Serve Promo Page
    Then Operator verifies that error toast is displayed on Upload Self Serve Promo Page:
      | top    | Network Request Error                                      |
      | bottom | Insurance percentage cannot be negative or more than 100%. |
    Then Operator clicks Download Error Upload Pricing Profile CSV on Upload Self Serve Promo Page
    Then Operator verify Download Error Upload Pricing Profile CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | global_id        | message                                                    | reason           |
      | 2   | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | Insurance percentage cannot be negative or more than 100%. | Validation Error |
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"
