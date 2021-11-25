@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @Cod @CreatePricingProfiles @NormalShipper
Feature: Create Pricing Profile - Normal Shippers - COD

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-v4-dummy-pricing-profile-cod-global-id}" shipper's pricing profiles

  Scenario: Create Pricing Profile - with 'Int' COD Min Fee and 'Int' COD Percentage (uid:7b127104-0aa7-4ddc-a639-b9224fa81b7f)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-cod-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | codMinFee         | 5                                           |
      | codPercentage     | 10                                          |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - with 'Decimal' COD Min Fee, 'NULL' COD Percentage (uid:f657ff55-ff19-4ca1-a617-121655bd5362)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 20                                              |
      | codMinFee         | 10.05                                           |
      | codPercentage     | none                                            |
      | errorMessage      | This field is required.                         |

  Scenario: Create Pricing Profile - with 'NULL' COD Min Fee, with 'Decimal' COD Percentage (uid:90757d27-31b0-42ef-9470-54feacd987e2)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 20                                              |
      | codPercentage     | 10.52                                           |
      | codMinFee         | none                                            |
      | errorMessage      | This field is required.                         |

  Scenario: Create Pricing Profile - with 'Int' COD Min Fee, '0' COD Percentage (uid:f0dcdb3e-7a99-450b-a2f5-94047ceae51d)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-cod-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | codMinFee         | 2                                           |
      | codPercentage     | 0                                           |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - with '0' COD Min Fee, '0' COD Percentage (uid:1c68f550-017e-4c85-983c-8795d82c44b0)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-cod-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | codMinFee         | 0                                           |
      | codPercentage     | 0                                           |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - with '0' COD Min Fee, with 'Decimal' COD Percentage (uid:8e44e9f5-2117-4818-bd21-ae827e3f844e)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-cod-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | FLAT                                        |
      | discount          | 20                                          |
      | codMinFee         | 0                                           |
      | codPercentage     | 5.5                                         |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - with more than 2 int after decimal (e.g 2.5647) for COD Min Fee (uid:73e0f2de-7d5b-4b5b-a4f1-233a3cd0e724)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | codMinFee         | 2.5647                                          |
      | errorMessage      | Please provide only 2 decimal places.           |

  Scenario: Create Pricing Profile - with more than 2 int after decimal (e.g 2.5647) for COD Percentage (uid:45c1838d-379d-470b-bf1b-a9deec4256c9)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | codPercentage | 10.4073                               |
      | errorMessage  | Please provide only 2 decimal places. |

  Scenario: Create Pricing Profile - input special characters on COD Min Fee (uid:2ece28e7-5322-49a6-871b-b8bd38d97a29)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | codMinFee    | !@#$%^&                          |
      | errorMessage | Special character is not allowed |

  Scenario: Create Pricing Profile - input negative values on COD Min Fee (uid:1e5583b2-4cdd-435c-8d77-46570c0675b7)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | codMinFee    | -1                            |
      | errorMessage | Negative value is not allowed |

  Scenario: Create Pricing Profile - input alphabets on COD Min Fee (uid:29422d43-d5b0-41bf-b59b-a510f41fb0bf)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | codMinFee    | abcd                             |
      | errorMessage | Special character is not allowed |

  Scenario: Create Pricing Profile - input special characters on COD Percentage (uid:0a61ec83-df3b-4f9f-9b1b-4adbacff9836)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | codPercentage | !@#$%^&                          |
      | errorMessage  | Special character is not allowed |

  Scenario: Create Pricing Profile - input negative values on COD Percentage (uid:6d922abf-100a-4564-a2dd-69eb638ec22d)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | codPercentage | -1                            |
      | errorMessage  | Negative value is not allowed |

  Scenario: Create Pricing Profile - input alphabets on COD Percentage (uid:d42b25ab-98be-46e0-8357-be9e77014b16)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | codPercentage | abcd                             |
      | errorMessage  | Special character is not allowed |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
