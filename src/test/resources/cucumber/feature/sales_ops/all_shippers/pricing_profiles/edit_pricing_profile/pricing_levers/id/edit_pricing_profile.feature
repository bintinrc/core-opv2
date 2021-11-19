@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesID @UpdatePricingProfilesID
Feature: Edit Pricing Profiles - ID

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Indonesia"
    And API Operator create new normal shipper
    # add active pricing profile
    And API operator adds new basic pricing profile with pricing script id "{pricing-script-id}" to created shipper
    # add pending pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page


  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with 0 Percentage Discount - ID (uid:8fa73f4b-69a1-4ce0-927a-82b2be6ace0c)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 0 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | 0 is not a valid discount value |

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with none Percentage Discount - ID (uid:cdf6e3e4-da77-4867-bca0-ae734b97ad21)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | none |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | type     | Percentage |
      | discount | none       |

  @DeleteNewlyCreatedShipper
  Scenario: Edit Pending Pricing Profile - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage - ID (uid:9f2e8e1f-de51-4475-806a-c63e021f729d)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee     | 23 |
      | insurancePercentage | 35 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | insuranceMinFee     | 23 |
      | insurancePercentage | 35 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
