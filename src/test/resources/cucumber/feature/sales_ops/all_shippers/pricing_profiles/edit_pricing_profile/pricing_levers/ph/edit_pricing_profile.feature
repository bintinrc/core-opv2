@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesPH @UpdatePricingProfilesPH
Feature: Edit Pricing Profiles - PH

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Philippines"
    And API Operator create new normal shipper
    # add active pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    # add pending pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25,"rts_charge":2}} |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, From Surcharge to Discount - PH (uid:869dbdc2-aa0e-446f-8e3f-01ef99ff8e78)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeType  | Discount |
      | rtsChargeValue | 20       |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | rtsChargeType  | Discount |
      | rtsChargeValue | 20       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
