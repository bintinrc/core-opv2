@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @UpdatePricingProfiles @Cod @NormalShipper
Feature: Edit Pricing Profiles - Normal Shippers - COD

  Background: Login to Operator Portal V2 and set up shipper for testing
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-v4-dummy-pricing-profile-cod-2-global-id}" shipper's pricing profiles
      # create a pending pricing profile for shipper
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-cod-2-global-id}"
      | {"effective_date":"{gradle-next-0-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id-all}} |
    And Operator waits for 1 seconds
    And API Operator send below request to addPricingProfile endpoint for Shipper ID "{shipper-v4-dummy-pricing-profile-cod-2-global-id}"
      | {"effective_date":"{gradle-next-2-day-yyyy-MM-dd}T00:00:00Z","contractEndDate":"{gradle-next-3-day-yyyy-MM-dd}T00:00:00Z","pricing_script_id": {pricing-script-id},"pricing_levers": {"cod_min_fee": 20,"cod_percentage": 0.8,"insurance_min_fee": 2,"insurance_percentage": 0.6,"insurance_threshold": 25}} |
    # edit pending pricing profile for shipper
    When Operator edits shipper "{shipper-v4-dummy-pricing-profile-cod-2-legacy-id}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with 'Int' COD Min Fee and 'Int' COD Percentage (uid:d7546eae-f4e7-47d1-b8a7-86c37229f9dd)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee     | 1.2 |
      | codPercentage | 3   |
      | codThreshold  | 0   |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | codMinFee     | 1.2 |
      | codPercentage | 3   |
      | codThreshold  | 0   |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with 'Decimal' COD Min Fee, 'NULL' COD Percentage (uid:4d9ada07-a22c-4a6c-afe6-26181805c340)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codPercentage | none |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | This field is required. |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with 'NULL' COD Min Fee, with 'Decimal' COD Percentage (uid:32cd26e0-e781-4d31-86e1-258e08ff7015)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee | none |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | This field is required. |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with 'Int' COD Min Fee, '0' COD Percentage (uid:e210c034-4dc2-4674-8e07-2119676bae02)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee     | 250 |
      | codPercentage | 0   |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | codMinFee     | 250 |
      | codPercentage | 0   |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with '0' COD Min Fee, with 'Decimal' COD Percentage (uid:dba592fb-bca5-40f4-a241-cfcf61bb7fe1)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee     | 0     |
      | codPercentage | 50.05 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | codMinFee     | 0     |
      | codPercentage | 50.05 |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with '0' COD Min Fee, '0' COD Percentage (uid:93a112fa-3845-4ae2-a686-b5d435aad58a)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee     | 0 |
      | codPercentage | 0 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | codMinFee     | 0 |
      | codPercentage | 0 |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with 'more than 2 int after decimal (e.g 2.5647)' COD Min Fee (uid:9ba75e7a-5df8-4f04-b3a2-25042cc8bf95)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee | 2.5647 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Please provide only 2 decimal places. |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - with 'more than 2 int after decimal (e.g 10.4057)' COD Percentage (uid:4adb6877-7427-4638-b7ec-7a0f2f384977)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codPercentage | 10.4057 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Please provide only 2 decimal places. |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - input special characters on COD Min Fee (uid:010bd0bd-700d-4008-a0cc-6b751636a4f0)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee | !@#$%^& |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - input negative values on COD Min Fee (uid:5e496a7c-8d2f-4f35-a65b-04177083c446)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee | -2.5647 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Negative value is not allowed |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - input alphabets on COD Min Fee (uid:30d91493-1415-4157-bebd-8662339144bc)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codMinFee | test |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - input special characters on COD Percentage (uid:47a339fa-72d5-41ae-8014-245142f68569)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codPercentage | @#$%^& |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - input negative values on COD Percentage (uid:fb513ac3-4c99-4a32-856c-d3e04f505520)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codPercentage | -4 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Negative value is not allowed |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - input alphabets on COD Percentage (uid:27a2e019-eb73-43a4-87a6-cb2cd5403a77)
    Given Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | codPercentage | test |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
