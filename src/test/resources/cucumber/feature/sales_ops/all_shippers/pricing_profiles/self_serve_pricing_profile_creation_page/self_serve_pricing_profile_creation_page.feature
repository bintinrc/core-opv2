@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @SelfServePricingProfile
Feature: Self-Serve Pricing Profile Creation Page

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to this URL "{upload-self_serve-promo-url}"

  Scenario: Download CSV Template for Bulk Pricing Profiles (uid:eab97f5d-abf0-4db5-860e-08615faec2c2)
    Given Operator clicks Download Sample CSV Template button on the Upload Self Serve Promo Page
    Then Operator verify Sample CSV file on Upload Self Serve Promo Page is downloaded successfully with below data
      | shipper_id,global_id,pricing_script_id,effective_date,salesperson_discount,discount_type,rts,rts_type,cod_percentage,cod_min_fee,insurance_percentage,insurance_min_fee,insurance_threshold,billing_weight_logic |

  Scenario: Upload Pricing Profiles with CSV - Invalid Format (uid:f9bcb24b-e528-4225-a924-89ac5047c9cf)
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | pricing_script_id       |
      | {pricing-script-id-all} |
    Then Operator verifies toast message "File is invalid" in Upload Self Serve Promo Page
    Then Operator clicks Download Errors CSV on Upload Self Serve Promo Page
    Then Operator verify Download Errors CSV file on Upload Self Serve Promo Page contains "Missing header fields"

  Scenario: Upload Pricing Profiles with CSV - With Some Mandatory Fields Not Exist (uid:4354172a-4215-417f-9f41-715ee6102831)
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | flat          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
    Then Operator verifies toast message "File is invalid" in Upload Self Serve Promo Page
    Then Operator clicks Download Errors CSV on Upload Self Serve Promo Page
    Then Operator verify Download Errors CSV file on Upload Self Serve Promo Page contains "Missing header fields"

  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Shipper has existing pending profile (uid:996c2331-cf3a-4452-9118-7beb83e65dcc)
      # add pending pricing profile
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | flat          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
    Then Operator verifies toast message "Validate file successfully" in Upload Self Serve Promo Page
    Then Operator clicks submit button on the Upload Self Serve Promo Page
    Then Operator verifies that error toast is displayed on Upload Self Serve Promo Page:
      | top    | Network Request Error                                                                 |
      | bottom | {KEY_SHIPPER_ID} has a pending pricing profile with script id {pricing-script-id-all} |

  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Start Date with Today's Date (uid:5ce9053d-04cd-4f76-b4fc-fef082cb58e5)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date                 | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-current-date-d/M/yyyy} | 10.00                | flat          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
    Then Operator verifies toast message "File is invalid" in Upload Self Serve Promo Page
    Then Operator clicks Download Errors CSV on Upload Self Serve Promo Page
    Then Operator verify Download Errors CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:
      | row | shipper_id              | column         | description                                        |
      | 2   | {KEY_LEGACY_SHIPPER_ID} | effective_date | The effective date must be after the current date. |

  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - CSV file contains 2 rows that has same Shipper ID (uid:be64b64f-db89-4098-b4a5-72d8dd0d6ec4)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | flat          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 2.00                 | flat          | 200 | surcharge | 2              | 2           | 2                    | 2                 | 2                   | LEGACY               |
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details in CSV are correct
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Success Create Pricing Profiles with All Pricing Levers (uid:e15ef4a2-dd25-4d08-82eb-b682d4d16c47)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | flat          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details in CSV are correct
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database


  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Success Create Pricing Profiles with Default Pricing Levers (uid:155760b8-781c-4227-a181-d1d6a45a08d0)
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id              | global_id        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts               | rts_type  | cod_percentage    | cod_min_fee       | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LEGACY_SHIPPER_ID} | {KEY_SHIPPER_ID} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | flat          | [country default] | surcharge | [country default] | [country default] | [country default]    | [country default] | [country default]   | LEGACY               |
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_SHIPPER_ID}"
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details in CSV are correct
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Create Pricing Profiles with More Than 5 Shippers with Shipper that Has Invalid Pricing Profiles - Valid CSV File (uid:8c85d9e5-f4f4-4a55-b84a-702cc4a59d38)
    # shipper 1
    Given API Operator create new 'normal' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    # shipper 2 without pricing profile
    Given API Operator create new 'normal' shipper
    And Operator waits for 1 seconds
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator uploads csv file with below data:
      | shipper_id                                 | global_id                            | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts | rts_type  | cod_percentage | cod_min_fee | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_LIST_OF_CREATED_SHIPPERS[1].legacyId} | {KEY_LIST_OF_CREATED_SHIPPERS[1].id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | flat          | 100 | surcharge | 3              | 4           | 1.5                  | 20                | 10                  | LEGACY               |
      | {KEY_LIST_OF_CREATED_SHIPPERS[2].legacyId} | {KEY_LIST_OF_CREATED_SHIPPERS[2].id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 20.00                | flat          | 50  | surcharge | 200            | 2           | 2                    | 2                 | 2                   | LEGACY               |
    Then Operator clicks submit button on the Upload Self Serve Promo Page
    Then Operator verifies that error toast is displayed on Upload Self Serve Promo Page:
      | top    | Network Request Error                                |
      | bottom | COD percentage cannot be negative or more than 100%. |
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}"
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details in CSV are correct
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    Then DB Operator verifies there is no pricing profile added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_LIST_OF_CREATED_SHIPPERS[2].id}"

  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Marketplace Shipper with Sub-Shipper who has their own Pricing Profile - Success Create Pricing Profiles with All Pricing Levers (uid:f847764e-4e5d-4c8c-bfbe-36af37f1375d)
    Given API Operator create new 'marketplace' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    # create subshipper with own pricing profile
    And Operator waits for 1 seconds
    Given API operator create new marketplace seller for marketplace id "{KEY_SHIPPER_ID}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_MARKETPLACE_SUB_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25,"rts_charge":-2,"billing_weight_logic" : "SHIPPER_GROSS_WEIGHT"}} |
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id                             | global_id                        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts               | rts_type  | cod_percentage    | cod_min_fee       | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_MARKETPLACE_SUB_SHIPPER.legacyId} | {KEY_MARKETPLACE_SUB_SHIPPER.id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | flat          | [country default] | surcharge | [country default] | [country default] | [country default]    | [country default] | [country default]   | LEGACY               |
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_MARKETPLACE_SUB_SHIPPER.id}"
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details in CSV are correct
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Marketplace Shipper with Sub Shipper who Reference Parent's Pricing Profile - Success Create Pricing Profiles with All Pricing Levers (uid:c902b1ab-0804-4b91-bf8e-d9fd2714346a)
    Given API Operator create new 'marketplace' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    # create subshipper with linked pricing profile
    And Operator waits for 1 seconds
    Given API operator create new marketplace seller for marketplace id "{KEY_SHIPPER_ID}"
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id                             | global_id                        | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts               | rts_type  | cod_percentage    | cod_min_fee       | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_MARKETPLACE_SUB_SHIPPER.legacyId} | {KEY_MARKETPLACE_SUB_SHIPPER.id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | flat          | [country default] | surcharge | [country default] | [country default] | [country default]    | [country default] | [country default]   | LEGACY               |
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_MARKETPLACE_SUB_SHIPPER.id}"
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details in CSV are correct
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Corporate Shipper with Sub Shipper who has their own Pricing Profile - Success Create Pricing Profiles with All Pricing Levers (uid:04e29975-57c4-456f-a0e3-e7cb6f8e219b)
    Given API Operator create new 'corporate' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    # create corporate subshipper with own pricing profile
    And Operator waits for 1 seconds
    Given API operator create new corporate branch for corporate shipper id "{KEY_SHIPPER_ID}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CORPORATE_BRANCH.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25,"rts_charge":-2,"billing_weight_logic" : "SHIPPER_GROSS_WEIGHT"}} |
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id                      | global_id                 | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts               | rts_type  | cod_percentage    | cod_min_fee       | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_CORPORATE_BRANCH.legacyId} | {KEY_CORPORATE_BRANCH.id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | flat          | [country default] | surcharge | [country default] | [country default] | [country default]    | [country default] | [country default]   | LEGACY               |
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_CORPORATE_BRANCH.id}"
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details in CSV are correct
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database


  @DeleteNewlyCreatedShipper
  Scenario: Upload Pricing Profiles with CSV - Corporate Shipper with Sub Shipper who Reference Parent's Pricing Profile - Success Create Pricing Profiles with All Pricing Levers (uid:cc54b789-a311-4c92-8616-12d3909c6971)
    Given API Operator create new 'corporate' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    # create corporate subshipper with linked pricing profile
    And Operator waits for 1 seconds
    Given API operator create new corporate branch for corporate shipper id "{KEY_SHIPPER_ID}"
    And Operator waits for 1 seconds
    Given Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page
    And Operator successfully uploads csv file with below data:
      | shipper_id                      | global_id                 | pricing_script_id       | effective_date               | salesperson_discount | discount_type | rts               | rts_type  | cod_percentage    | cod_min_fee       | insurance_percentage | insurance_min_fee | insurance_threshold | billing_weight_logic |
      | {KEY_CORPORATE_BRANCH.legacyId} | {KEY_CORPORATE_BRANCH.id} | {pricing-script-id-all} | {gradle-next-1-day-d/M/yyyy} | 10.00                | flat          | [country default] | surcharge | [country default] | [country default] | [country default]    | [country default] | [country default]   | LEGACY               |
    Then DB Operator verifies new pricing profile is added to script_engine_qa_gl.pricing_profiles table for shipper "{KEY_CORPORATE_BRANCH.id}"
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details in CSV are correct
    Then DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
