@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @UpdatePricingProfiles @Rts @NormalShipper
Feature: Pricing Levers - RTS Charge

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-v4-dummy-pricing-profile-rts-2-global-id}" shipper's pricing profiles
      # create a pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-rts-2-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, From Surcharge to Discount (uid:0533c03b-3345-4592-8aab-47afc28c4d40)
    # add pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-rts-2-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"rts_charge":2}} |
    # edit pending pricing profile for shipper
    When Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeType | Discount |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | rtsChargeType | Discount |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, From Discount to Surcharge - Values up to 2 Decimals (uid:41ba5c04-44ef-460d-91c8-5e3ba15fa107)
       # add pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-rts-2-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"rts_charge":-2}} |
    # edit pending pricing profile for shipper
    When Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeType | Surcharge |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | rtsChargeType | Surcharge |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, Surcharge - Value is 0 (uid:15777477-35cf-400f-99cf-e0687a46ea6a)
    # add pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-rts-2-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"rts_charge":2}} |
    # edit pending pricing profile for shipper
    When Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeValue | 0 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | rtsChargeValue | 0 |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, Surcharge - Value is bigger than 100 (uid:799cb579-988b-4e78-abd7-506a7634aeb9)
    # add pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-rts-2-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"rts_charge":2}} |
    # edit pending pricing profile for shipper
    When Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeValue | 150 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Cannot be more than 100% |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, Discount - Values more than 2 decimals (uid:2f00f5ad-a555-4e2e-bd4c-640ec7079160)
    # add pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-rts-2-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"rts_charge":2}} |
    # edit pending pricing profile for shipper
    When Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeType  | Discount |
      | rtsChargeValue | 45.9549  |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Please provide only 2 decimal places. |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, Discount - Value is bigger than 100 (uid:7ea8629a-2477-4da3-b673-e8b15e1b3623)
    # add pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-rts-2-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"rts_charge":2}} |
    # edit pending pricing profile for shipper
    When Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeType  | Discount |
      | rtsChargeValue | 150      |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Cannot be more than 100% |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - RTS Charge, Discount - NULL (uid:3936848a-79d7-450e-9ad7-af7b305f6eff)
    # add pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-rts-2-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"rts_charge":2}} |
    # edit pending pricing profile for shipper
    When Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeType  | Discount |
      | rtsChargeValue | none     |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | This field is required. |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - From RTS Surcharge to RTS Country Default (uid:c0db78c9-9a46-4740-849e-de5a24478a0f)
    # add pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-rts-2-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"rts_charge":2}} |
    # edit pending pricing profile for shipper
    When Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | isDefaultRts | true |
    Then Operator verifies country default text is displayed like below
      | rtsCharge | Use Country Default: 0% RTS Fee |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | isDefaultRts | true |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - From RTS Country Default to RTS Discount (uid:03ed3871-2c63-427d-ab56-87c623e9bc18)
    # add pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-rts-2-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id}} |
    # edit pending pricing profile for shipper
    When Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | rtsChargeType  | Discount |
      | rtsChargeValue | 10       |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | rtsChargeType  | Discount |
      | rtsChargeValue | 10       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op