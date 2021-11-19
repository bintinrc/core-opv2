@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @UpdatePricingProfiles @Basic
Feature: Edit Pricing Profile - Normal Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-v4-dummy-pricing-profile-basic-global-id}" shipper's pricing profiles
    And API Operator create new normal shipper
    # add active pricing profile
    And API operator adds new basic pricing profile with pricing script id "{pricing-script-id}" to created shipper
    # add pending pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Edit Pricing Script ID (uid:f7f04ae2-65ba-45a8-8627-79f732fae1a2)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Edit Start Date / End Date (uid:86101231-638d-4d38-917d-79dbb1b1d07d)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | startDate | {gradle-next-3-day-yyyy-MM-dd}  |
      | endDate   | {gradle-next-10-day-yyyy-MM-dd} |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | startDate | {gradle-next-3-day-yyyy-MM-dd}  |
      | endDate   | {gradle-next-10-day-yyyy-MM-dd} |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
