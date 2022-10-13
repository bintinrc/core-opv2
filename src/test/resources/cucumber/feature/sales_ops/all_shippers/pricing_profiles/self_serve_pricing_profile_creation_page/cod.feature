@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @SelfServePricingProfile
Feature: COD

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to this URL "{upload-self_serve-promo-url}"

  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - Failed Create Pricing Profiles with COD Settings - Upload pricing profile error (uid:757f8f1f-b614-435b-b4c2-11a371ab53d9)
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 3              | {empty}     | 1.5                  | 20                | 10                  | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | {empty}        | 4           | 1.5                  | 20                | 1.5                 | LEGACY               |
    Then Operator verifies error message "File is invalid" in Upload Self Serve Promo Page
    Then Operator clicks Download Errors CSV on Upload Self Serve Promo Page
    Then Operator verify Download Errors CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | column         | description                        |
      | 1   | {KEY_LEGACY_SHIPPER_ID} | cod_min_fee    | cod_min_fee should not be blank    |
      | 2   | {KEY_LEGACY_SHIPPER_ID} | cod_percentage | cod_percentage should not be blank |
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"

  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - Failed Create Pricing Profiles with COD Settings - Pricing profile validation error - Input more than 100% for COD Percentage (uid:682af54e-968c-45f9-a2cd-9743eadd22e4)
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 300            | 4           | 20                   | 20                | 10                  | LEGACY               |
    Then Operator clicks submit button on the Upload Self Serve Promo Page
    Then Operator verifies that error toast is displayed on Upload Self Serve Promo Page:
      | top    | Network Request Error                                |
      | bottom | COD percentage cannot be negative or more than 100%. |
    Then Operator clicks Download Error Upload Pricing Profile CSV on Upload Self Serve Promo Page
    Then Operator verify Download Error Upload Pricing Profile CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | global_id        | message                                              | reason           |
      | 1   | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | COD percentage cannot be negative or more than 100%. | Validation Error |
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"

  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - Failed Create Pricing Profiles with COD Settings - Pricing profile validation error - Input negative value for COD Percentage (uid:eabed97a-a51c-43f0-9f93-586bcc750e3d)
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | -3             | 4           | 20                   | 20                | 10                  | LEGACY               |
    Then Operator clicks submit button on the Upload Self Serve Promo Page
    Then Operator verifies that error toast is displayed on Upload Self Serve Promo Page:
      | top    | Network Request Error                                |
      | bottom | COD percentage cannot be negative or more than 100%. |
    Then Operator clicks Download Error Upload Pricing Profile CSV on Upload Self Serve Promo Page
    Then Operator verify Download Error Upload Pricing Profile CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | global_id        | message                                              | reason           |
      | 1   | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | COD percentage cannot be negative or more than 100%. | Validation Error |
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"

  @DeleteNewlyCreatedShipper
  Scenario: Upload Bulk Pricing Profiles CSV - Failed Create Pricing Profiles with COD Settings - Pricing profile validation error - Input negative value for COD Min Fee (uid:9d0ef10f-f03c-4fe0-8d2d-5b54d2cdc1e9)
    Given API Operator create new 'normal' shipper
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | FLAT          | 100 | surcharge | 3              | -4          | 20                   | 20                | 10                  | LEGACY               |
    Then Operator clicks submit button on the Upload Self Serve Promo Page
    Then Operator verifies that error toast is displayed on Upload Self Serve Promo Page:
      | top    | Network Request Error               |
      | bottom | COD minimum fee cannot be negative. |
    Then Operator clicks Download Error Upload Pricing Profile CSV on Upload Self Serve Promo Page
    Then Operator verify Download Error Upload Pricing Profile CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | global_id        | message                             | reason           |
      | 1   | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | COD minimum fee cannot be negative. | Validation Error |
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"
