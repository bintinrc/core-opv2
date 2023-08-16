@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesTH @CreatePricingProfilesTH
Feature: Create Pricing Profile - TH

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator changes the country to "Thailand"

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Pricing Profile - RTS Charge, Surcharge - TH (uid:fc7e368e-9e64-45a1-9815-989e26584ce2)
    Given API Operator create new 'normal' shipper
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all} |
      | type              | PERCENTAGE                                          |
      | discount          | 20                                                  |
      | rtsChargeType     | Surcharge                                           |
      | rtsChargeValue    | 30                                                  |
      | comments          | This is a test pricing script                       |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Pending Profile With Billing Weight Logic = GROSS_WEIGHT - Normal Shipper - TH (uid:495a6579-5bbe-4c65-84e8-1c54dba57de0)
    Given API Operator create new 'normal' shipper
    # add active pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    # add pending pricing profile
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    When Operator adds new Shipper's Pricing Profile
      | startDate          | {gradle-next-2-day-yyyy-MM-dd}                      |
      | pricingScriptName  | {pricing-script-id-all} - {pricing-script-name-all} |
      | type               | PERCENTAGE                                          |
      | comments           | This is a test pricing script                       |
      | billingWeightLogic | Gross weight only                                   |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Pending Profile With Billing Weight Logic = SHIPPER_GROSS_WEIGHT - Normal Shipper - TH (uid:b833eaa7-c6a6-439d-8062-a64517d5baf5)
    Given API Operator create new 'normal' shipper
    # add active pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    # add pending pricing profile
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    When Operator adds new Shipper's Pricing Profile
      | startDate          | {gradle-next-2-day-yyyy-MM-dd}                      |
      | pricingScriptName  | {pricing-script-id-all} - {pricing-script-name-all} |
      | type               | PERCENTAGE                                          |
      | comments           | This is a test pricing script                       |
      | billingWeightLogic | Shipper submitted gross weight only                 |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Subshipper Pending Pricing Profile With Billing Weight Logic = STANDARD - Parent Shipper Has billing_weight_logic = GROSS_WEIGHT - TH (uid:c0da810b-70ea-434e-9bbe-e48d05fdedc3)
    Given API Operator create new 'marketplace' shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all},"billing_weight_logic": "GROSS_WEIGHT"} |
    Given API operator create new marketplace seller for marketplace id "{KEY_SHIPPER_ID}"
      # add pending pricing profile for the subshipper
    And Operator edits shipper "{KEY_MARKETPLACE_SUB_SHIPPER.legacyId}"
    When Operator adds new Shipper's Pricing Profile
      | startDate          | {gradle-next-2-day-yyyy-MM-dd}                      |
      | pricingScriptName  | {pricing-script-id-all} - {pricing-script-name-all} |
      | type               | PERCENTAGE                                          |
      | comments           | This is a test pricing script                       |
      | billingWeightLogic | Shipper submitted gross weight only                 |
    Then Operator waits for 2 seconds
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database



  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
