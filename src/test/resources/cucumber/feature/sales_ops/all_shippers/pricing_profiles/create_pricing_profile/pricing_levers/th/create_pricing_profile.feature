@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesTH @CreatePricingProfilesTH
Feature: Create Pricing Profile - TH

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator changes the country to "Thailand"


  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Pricing Profile - RTS Charge, Surcharge - TH (uid:fc7e368e-9e64-45a1-9815-989e26584ce2)
    Given API Operator create new normal shipper
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
