@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesMY @UpdatePricingProfilesMY
Feature: Edit Pricing Profiles - MY

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator changes the country to "Malaysia"
    And API Operator create new 'normal' shipper
    # add active pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    # add pending pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25,"rts_charge":-2}} |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, From Discount to Surcharge - Values up to 2 Decimals - MY (uid:21981e16-37e6-4799-acec-cd6be19bff90)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeType  | Surcharge |
      | rtsChargeValue | 45.95     |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | rtsChargeType  | Surcharge |
      | rtsChargeValue | 45.95     |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op