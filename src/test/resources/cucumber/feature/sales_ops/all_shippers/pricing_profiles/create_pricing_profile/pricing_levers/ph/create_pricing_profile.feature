@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesPH @CreatePricingProfilesPH
Feature: Create Pricing Profile - PH

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Philippines"

  @DeleteNewlyCreatedShipper  @CloseNewWindows
  Scenario: Create Pricing Profile - RTS Charge, Surcharge - PH (uid:81710a5c-ed93-4792-ae50-14c6d461be97)
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

  @DeleteNewlyCreatedShipper  @CloseNewWindows
  Scenario: Create Pending Profile With Billing Weight Logic = GROSS_WEIGHT - Normal Shipper - PH (uid:a992ec1b-bf60-49ee-9546-0ccbf13856c5)


  @DeleteNewlyCreatedShipper  @CloseNewWindows
  Scenario: Create Pending Profile With Billing Weight Logic = SHIPPER_GROSS_WEIGHT - Normal Shipper - PH (uid:b5d222df-14b7-49af-ae92-2cf111d73930)

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Subshipper Pending Pricing Profile With Billing Weight Logic = GROSS_WEIGHT - Parent Shipper Has billing_weight_logic = SHIPPER_GROSS_WEIGHT - PH (uid:4e11d096-c1a1-4c5a-8e88-82b264f196cc)

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
