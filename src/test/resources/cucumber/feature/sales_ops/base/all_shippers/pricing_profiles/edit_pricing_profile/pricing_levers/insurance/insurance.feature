@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @UpdatePricingProfiles @nadeera
Feature: Pricing Profiles

  Background: Login to Operator Portal V2 and
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator go to menu Shipper -> All Shippers
    And DB Operator deletes "{shipper-v4-dummy-pricing-profile-2-global-id}" shipper's pricing profiles
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page


  @CloseNewWindows
  Scenario: Update Pricing Profile - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage (uid:3a379fd3-5464-46a3-817d-123ef0a13e23)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee     | 1.2 |
      | insurancePercentage | 3   |
      | insuranceThreshold  | 0   |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | insuranceMinFee     | 1.2 |
      | insurancePercentage | 3   |
      | insuranceThreshold  | 0   |

  Scenario: Update Pricing Profile - with 'NULL' Insurance Min Fee, with 'Decimal' Insurance Percentage (uid:c2f87d6f-185f-4bdc-a49f-8a5773c7c69d)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee | removeValue |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | This field is required. |

#  Scenario: Update Pricing Profile - with 'Int' Insurance Min Fee, '0' Insurance Percentage (uid:d11c5ef9-d44b-4c87-8db1-50c4363439d5)

  Scenario: Update Pricing Profile - with '0' Insurance Min Fee, with 'Decimal' Insurance Percentage (uid:1c8cda6a-8a31-4429-beec-0e45eb0257e7)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee     | 0     |
      | insurancePercentage | 50.05 |
      | insuranceThreshold  | 0     |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | insuranceMinFee     | 0     |
      | insurancePercentage | 50.05 |
      | insuranceThreshold  | 0     |

  Scenario: Update Pricing Profile - with '0' Insurance Min Fee, '0' Insurance Percentage (uid:cfd31f39-3bb6-408e-b234-9cf1cf25a9e8)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee     | 0 |
      | insurancePercentage | 0 |
      | insuranceThreshold  | 0 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | insuranceMinFee     | 0 |
      | insurancePercentage | 0 |
      | insuranceThreshold  | 0 |

  Scenario: Update Pricing Profile - with 'more than 2 int after decimal (e.g 2.5647)' Insurance Min Fee and Insurance Percentage (uid:60b6ee94-4336-4471-8f79-4a0cce948f4d)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee | 2.5647 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Please provide only 2 decimal places. |

  Scenario: Update Pricing Profile - input special characters on Insurance Min Fee (uid:a3142dd0-0769-4c7c-8f20-9900a1a4065f)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee | !@#$%^& |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  Scenario: Update Pricing Profile - input negative values on Insurance Min Fee (uid:fa023bb1-7e02-4844-b6c1-a19f1e1aa9a1)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee | -2.5647 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Negative value is not allowed |

  @coverage-manual @coverage-operator-manual @step-done
  Scenario: Update Pricing Profile - input alphabets on Insurance Min Fee (uid:e2f34275-e5a1-49e1-9938-7fdbf01c0923)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee | test |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  @coverage-manual @coverage-operator-manual @step-done
  Scenario: Update Pricing Profile - input special characters on Insurance Percentage (uid:09ef1f55-56bf-4bb8-b428-d9361a643410)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insurancePercentage | @#$%^& |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  @coverage-manual @coverage-operator-manual @step-done
  Scenario: Update Pricing Profile - input negative values on Insurance Percentage (uid:b5326674-d061-4600-b987-237a0c84598d)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insurancePercentage | -4 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Negative value is not allowed |

  Scenario: Update Pricing Profile - input alphabets on Insurance Percentage (uid:f83f18df-8bfa-411a-9347-ec801692a0e8)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd} |
      | pricingScript       | {pricing-script-name}          |
      | discountValue       | 1                              |
      | insuranceMinFee     | 5                              |
      | insurancePercentage | 5                              |
      | insuranceThreshold  | 5                              |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insurancePercentage | test |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |