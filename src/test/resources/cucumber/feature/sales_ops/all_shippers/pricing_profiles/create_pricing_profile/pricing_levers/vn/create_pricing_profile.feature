@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesVN @CreatePricingProfilesVN
Feature: Create Pricing Profile - VN

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator changes the country to "Vietnam"

  @nadeera
  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Pricing Profile - RTS Charge, Discount - VN (uid:c8fb9448-d947-4e37-9fe0-345825368133)
    Given API Operator create new normal shipper
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all} |
      | type              | FLAT                                                |
      | discount          | 20                                                  |
      | rtsChargeType     | Discount                                            |
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
