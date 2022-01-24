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


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
