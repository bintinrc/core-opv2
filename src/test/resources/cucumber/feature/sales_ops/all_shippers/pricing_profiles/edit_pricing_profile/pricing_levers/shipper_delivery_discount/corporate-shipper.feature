@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @UpdatePricingProfiles @Corporate

Feature: Corporate Shipper

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}" shipper's pricing profiles

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Corporate Sub Shipper - Edit Discount (uid:6d3ff955-f76f-4e97-99f3-42392917000e)
    # create a pending pricing profile for corporate sub shipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    # edit pending pricing profile for corporate sub shipper
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 1.2 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | discount | 1.2 |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Corporate Shipper - Edit Discount - Corporate Sub Shipper who Reference Pricing Profile from Parent is exists (uid:dbd624e8-a0f7-4fed-a8af-34db8d14b184)
    # create a pending pricing profile for corporate shipper
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    # edit pending pricing profile for corporate shipper
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 1.2 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    Then Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Corporate Shipper - Edit Pricing Script ID - Corporate Sub Shipper who Reference Pricing Profile from Parent is exists (uid:d83486a9-6fca-42d4-aa8f-010e2a93bc56)
    # create a pending pricing profile
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    # edit pending pricing profile
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    Then Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Corporate Shipper - Edit Discount - Corporate Sub Shipper who has their own Pricing Profile exists (uid:d979aa96-eeef-44a1-8bc1-15b947adbcff)
     # create a pending pricing profile for corporate shipper
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
     # create a pending pricing profile for corporate sub shipper
    Given Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
        # edit pending pricing profile of corporate shipper
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 1.2 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    # verify pricing profile of corporate sub shipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | type     | Flat |
      | discount | none |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Corporate Shipper - Edit Pricing Script ID - Corporate Sub Shipper who has their own Pricing Profile exists (uid:e8ec1a31-551e-4942-865c-2f2b8cefae5d)
    # create a pending pricing profile for corporate shipper
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
     # create a pending pricing profile for corporate sub shipper
    Given Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
        # edit pending pricing profile of corporate shipper
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
   # verify  pricing profile of corporate sub shipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all} |


  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile for Corporate Sub Shipper who has their own Pending Pricing Profile - Corporate Shipper has Pending Pricing Profile (uid:236faff3-3caf-4368-ac77-de99f73cd683)
     # create a pending pricing profile for corporate shipper
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
     # create a pending pricing profile for corporate sub shipper
    Given Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
        # edit pending pricing profile of corporate sub shipper
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    And Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 1.2 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
     # verify pricing profile of corporate sub shipper
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | discount | 1.2 |
     # verify pricing profile of corporate shipper
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | discount | none |


  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile for Corporate Sub Shipper who Reference Parent's Pending Pricing Profile (uid:03a6d3ae-8eb1-40a9-a54c-6ef39cb90251)
     # create a pending pricing profile for corporate shipper
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    # verify pricing profile of corporate sub shipper
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    Then Operator verifies that Add New Pricing Profile Button is displayed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op