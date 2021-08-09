@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @UpdatePricingProfiles @Insurance
Feature: Edit Pricing Profiles - Normal Shippers - Insurance

  Background: Login to Operator Portal V2 and set up shipper for testing
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-v4-dummy-pricing-profile-ins-2-global-id}" shipper's pricing profiles
    And Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page


  Scenario: Edit Pricing Profile - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage (uid:3a379fd3-5464-46a3-817d-123ef0a13e23)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
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

  Scenario: Edit Pricing Profile - with 'Decimal' Insurance Min Fee, 'NULL' Insurance Percentage (uid:67b66a36-cb7b-4ea7-ac45-932306403d8e)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5.8                                         |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insurancePercentage | none |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | This field is required. |

  Scenario: Edit Pricing Profile - with 'NULL' Insurance Min Fee, with 'Decimal' Insurance Percentage (uid:c2f87d6f-185f-4bdc-a49f-8a5773c7c69d)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee | none |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | This field is required. |

  Scenario: Edit Pending Pricing Profile - with 'Int' Insurance Min Fee, '0' Insurance Percentage (uid:d11c5ef9-d44b-4c87-8db1-50c4363439d5)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee     | 250 |
      | insurancePercentage | 0   |
      | insuranceThreshold  | 0   |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | insuranceMinFee     | 250 |
      | insurancePercentage | 0   |
      | insuranceThreshold  | 0   |

  Scenario: Edit Pricing Profile - with '0' Insurance Min Fee, with 'Decimal' Insurance Percentage (uid:1c8cda6a-8a31-4429-beec-0e45eb0257e7)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
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

  Scenario: Edit Pricing Profile - with '0' Insurance Min Fee, '0' Insurance Percentage (uid:cfd31f39-3bb6-408e-b234-9cf1cf25a9e8)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
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

  Scenario: Edit Pending Pricing Profile - with 'more than 2 int after decimal' Insurance Min Fee (uid:60b6ee94-4336-4471-8f79-4a0cce948f4d)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee | 2.5647 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Please provide only 2 decimal places. |

  Scenario: Edit Pending Pricing Profile - with 'more than 2 int after decimal' Insurance Percentage (uid:cabd8f2e-f668-41b6-8ff0-ba031dd5c6b0)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insurancePercentage | 2.5647 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Please provide only 2 decimal places. |

  Scenario: Edit Pricing Profile - input special characters on Insurance Min Fee (uid:a3142dd0-0769-4c7c-8f20-9900a1a4065f)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee | !@#$%^& |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  Scenario: Edit Pricing Profile - input negative values on Insurance Min Fee (uid:fa023bb1-7e02-4844-b6c1-a19f1e1aa9a1)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee | -2.5647 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Negative value is not allowed |

  Scenario: Edit Pricing Profile - input alphabets on Insurance Min Fee (uid:e2f34275-e5a1-49e1-9938-7fdbf01c0923)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceMinFee | test |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  Scenario: Edit Pricing Profile - input special characters on Insurance Percentage (uid:09ef1f55-56bf-4bb8-b428-d9361a643410)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insurancePercentage | @#$%^& |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  Scenario: Edit Pricing Profile - input negative values on Insurance Percentage (uid:b5326674-d061-4600-b987-237a0c84598d)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insurancePercentage | -4 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Negative value is not allowed |

  Scenario: Edit Pricing Profile - input alphabets on Insurance Percentage (uid:f83f18df-8bfa-411a-9347-ec801692a0e8)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insurancePercentage | test |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  Scenario: Edit Pricing Profile with “Int” Insurance Threshold (uid:e8863180-8961-4908-8a6d-3b3870823cc4)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceThreshold | 80 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | insuranceThreshold | 80 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Edit Pricing Profile with “Decimal” Insurance Threshold (uid:0b3845ea-aabc-4a56-9797-9e8896580b41)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceThreshold | 99.9 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | insuranceThreshold | 99.9 |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Edit Pricing Profile with with “More than 2 integer after decimal” Insurance Threshold (uid:38e171e8-31d1-492a-8bdc-c450cb3974b3)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceThreshold | 2.5647 |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Please provide only 2 decimal places. |

  Scenario: Edit Pricing Profile with with “Special Characters” Insurance Threshold (uid:afc5f787-0a1c-4aea-bc40-7ce5b286bcc4)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceThreshold | !@#$%^& |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | Special character is not allowed |

  Scenario: Edit Pricing Profile with with “NULL” Insurance Threshold (uid:399bc2af-af14-463e-b35a-48b7433ad106)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | type                | FLAT                                        |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | insuranceThreshold | none |
    Then Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:
      | errorMessage | This field is required. |

  Scenario: Edit Pricing Profile with "Use Country Default" Insurance Fee and Insurance Threshold (uid:0c082e43-7522-4004-ab2a-d5de3595b26d)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-2-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate             | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 1                                           |
      | insuranceMinFee     | 5                                           |
      | insurancePercentage | 5                                           |
      | insuranceThreshold  | 5                                           |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | isDefaultIns | true |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | isDefaultIns | true |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
