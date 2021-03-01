@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @Insurance @CreatePricingProfiles
Feature: Create Pricing Profile - Normal Shippers - Insurance

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator go to menu Shipper -> All Shippers
    And DB Operator deletes "{shipper-v4-dummy-pricing-profile-ins-global-id}" shipper's pricing profiles

  Scenario: Create Pricing Profile - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage, '0' Insurance Threshold (uid:8109e55a-bfbd-4d95-8ef7-102a05d18618)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1                                           |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - with 'Decimal' Insurance Min Fee, 'NULL' Insurance Percentage (uid:ce7b838c-a0da-41d9-aa71-257781a11107)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | pricingScriptName   | {pricing-script-id-2} - {pricing-script-name-2} |
      | type                | FLAT                                            |
      | discount            | 20                                              |
      | insuranceMinFee     | 10.05                                           |
      | insurancePercentage | OnlyClick                                       |
      | errorMessage        | This field is required.                         |

  Scenario: Create Pricing Profile - with 'NULL' Insurance Min Fee, with 'Decimal' Insurance Percentage (uid:828c8d66-cd44-41b6-a24e-b358abe7b2a5)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | pricingScriptName   | {pricing-script-id-2} - {pricing-script-name-2} |
      | type                | FLAT                                            |
      | discount            | 20                                              |
      | insurancePercentage | 60.52                                           |
      | insuranceMinFee     | OnlyClick                                       |
      | errorMessage        | This field is required.                         |

  Scenario: Create Pricing Profile - with 'Int' Insurance Min Fee, '0' Insurance Percentage (uid:616e45b3-bb89-4bf0-abd8-1938427f8acc)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 2                                           |
      | insurancePercentage | 0                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - with '0' Insurance Min Fee, with 'Decimal' Insurance Percentage (uid:dc05362f-dda9-4a35-a137-93c32d0f0976)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 0                                           |
      | insurancePercentage | 5.5                                         |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - with '0' Insurance Min Fee, '0' Insurance Percentage (uid:8ee68c2b-f41e-4e16-992f-ab87f6ca675f)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 0                                           |
      | insurancePercentage | 0                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - with 'more than 2 int after decimal (e.g 2.5647)' Insurance Min Fee (uid:07d0d6fd-0b1f-4b54-90d8-c8b90632887d)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | insuranceMinFee   | 2.5647                                          |
      | errorMessage      | Please provide only 2 decimal places.           |

  Scenario: Create Pricing Profile - with 'more than 2 int after decimal (e.g 10.4073)' Insurance Percentage (uid:5ff79bb9-febf-46bc-b1c6-6ebb7b31ff4d)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | insurancePercentage | 10.4073                               |
      | errorMessage        | Please provide only 2 decimal places. |

  Scenario: Create Pricing Profile - input special characters on Insurance Min Fee (uid:8c170e88-d593-4d57-9cf3-931180f75a1c)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | insuranceMinFee | !@#$%^&                          |
      | errorMessage    | Special character is not allowed |

  Scenario: Create Pricing Profile - input negative values on Insurance Min Fee (uid:e939d7e1-2452-4eb3-8c7d-b0d1ce71ff9a)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | insuranceMinFee | -1                            |
      | errorMessage    | Negative value is not allowed |

  Scenario: Create Pricing Profile - input alphabets on Insurance Min Fee (uid:279411a1-9620-477e-aac2-1b07d4c94818)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | insuranceMinFee | abcd                             |
      | errorMessage    | Special character is not allowed |

  Scenario: Create Pricing Profile - input special characters on Insurance Percentage (uid:26ba8e70-03eb-4b3c-aaad-8c0698663113)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | insurancePercentage | !@#$%^&                          |
      | errorMessage        | Special character is not allowed |

  Scenario: Create Pricing Profile - input negative values on Insurance Percentage (uid:807b39a5-1bfe-4b3a-b2ed-7327fa1781f4)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | insurancePercentage | -1                            |
      | errorMessage        | Negative value is not allowed |

  Scenario: Create Pricing Profile - input alphabets on Insurance Percentage (uid:b8d5c94a-1534-4611-a293-f65c80974a3e)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | insurancePercentage | abcd                             |
      | errorMessage        | Special character is not allowed |

  Scenario: Create Pricing Profile with Shipper Insurance Fee and “Int” Insurance Threshold (uid:621df691-ec21-493e-9231-6229e2cf5913)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 100                                         |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile with Shipper Insurance Fee and “Decimal” Insurance Threshold (uid:6ecdc11b-af58-4c66-bb83-9fd03546c95d)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 50.5                                        |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile with Shipper Insurance Fee and “More than 2 integer after decimal” Insurance Threshold (uid:02ed2d99-9da9-44ea-8661-84f208ade5df)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | insuranceThreshold | 10.4073                               |
      | errorMessage       | Please provide only 2 decimal places. |

  Scenario: Create Pricing Profile with Shipper Insurance Fee and “Special Character” Insurance Threshold (uid:1ba232ab-ce75-47a8-80c3-bd996d4f2b03)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | insuranceThreshold | !@#$%^&                          |
      | errorMessage       | Special character is not allowed |

  Scenario: Create Pricing Profile with Shipper Insurance Fee and “Negative Values” Insurance Threshold (uid:ee77e756-fd80-4c13-87e6-0f36e7d60eae)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | insuranceThreshold | -12                           |
      | errorMessage       | Negative value is not allowed |

  Scenario: Create Pricing Profile with Shipper Insurance Fee and “NULL” Insurance Threshold (uid:e030d59c-69d4-4913-8b0e-18194ddf8457)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | pricingScriptName  | {pricing-script-id-2} - {pricing-script-name-2} |
      | type               | FLAT                                            |
      | discount           | 20                                              |
      | insuranceMinFee    | 10.05                                           |
      | insuranceThreshold | OnlyClick                                       |
      | errorMessage       | This field is required.                         |

  Scenario: Create Pricing Profile with Shipper Insurance Fee and “More than 10 digits” Insurance Threshold (uid:183acccc-fed4-40f9-976b-2d9aa7d397f3)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | pricingScriptName  | {pricing-script-id-2} - {pricing-script-name-2} |
      | insuranceThreshold | 10000000000                                     |
      | errorMessage       | Value cannot exceed 10 figures.                 |

  Scenario: Create Pricing Profile with Shipper Insurance Fee and “Up to 10 digits” Insurance Threshold (uid:ae509551-6fc3-4a91-b8dc-264d19793b40)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 1000000000                                  |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile with Shipper Insurance Fee and “Up to 10 digits” Insurance Threshold (uid:a359c010-4036-4975-96eb-eb99df587d1d)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-ins-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 1000000000.0                                |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct