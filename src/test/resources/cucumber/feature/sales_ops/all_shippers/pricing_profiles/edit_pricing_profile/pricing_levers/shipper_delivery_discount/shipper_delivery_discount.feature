@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @UpdatePricingProfiles @DeliveryDiscount @NormalShipper
Feature: Edit Pricing Profile - Normal Shippers - Shipper Delivery Discount

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Operator create new normal shipper
    # add active pricing profile
    And API operator adds new basic pricing profile with pricing script id "{pricing-script-id}" to created shipper
    # add pending pricing profile
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{KEY_CREATED_SHIPPER.id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with 0 Flat Discount (uid:7764257b-02ad-41d6-99df-1a52e9c7f01f)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 0 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | 0 is not a valid discount value |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with none Flat Discount (uid:df20d395-ed05-4890-a5c9-a9d287fd9251)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | none |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | type     | Flat |
      | discount | none |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with special characters Discount (uid:35faef0b-1dc5-41d3-8c25-e623af2fbbde)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | $#^$^#@5 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  @CloseNewWindows @NotInGaia
  Scenario: Edit Pending Pricing Profile - with 3-5 integer after decimal point (uid:ed2da24e-c989-435f-9202-1fe5e69d9b30)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 4.38656 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Please provide only 2 decimal places. |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with shipper discount within 6 digits Flat Discount (uid:0fd13d01-2339-4358-b177-c5e463da15af)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 50000 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | discount | 50000 |

  @CloseNewWindows @NotInGaia
  Scenario: Edit Pending Pricing Profile - with shipper discount over 6 digits Flat Discount (uid:aaa6dc52-ffc5-42ec-8f64-80ebd4eb23cf)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 10000000 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Discounts cannot exceed 6 figures. |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with Int Discount (uid:f350a950-3a1b-4814-83a9-6f84e5f41d32)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | discount | 30                         |
      | comments | Edited test pricing script |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | discount | 30 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
