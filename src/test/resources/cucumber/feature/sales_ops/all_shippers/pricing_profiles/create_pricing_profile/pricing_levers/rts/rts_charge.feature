@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @Rts @CreatePricingProfiles @NormalShipper

Feature: Pricing Levers - RTS Charge

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-v4-dummy-pricing-profile-rts-global-id}" shipper's pricing profiles

  Scenario: Create Pricing Profile - RTS Charge, Surcharge (uid:10de3e90-ea99-49cf-b769-ff5149aca9d9)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | rtsChargeType     | Surcharge                                   |
      | rtsChargeValue    | 30                                          |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - RTS Charge, Surcharge - Values up to 2 Decimals (uid:aed89b6f-f328-4b15-b3fd-b0312f67aaec)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | rtsChargeType     | Surcharge                                   |
      | rtsChargeValue    | 49.55                                       |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - RTS Charge, Surcharge - Value is 0 (uid:cd54745f-0c83-4f76-8523-6a139f065d0b)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | rtsChargeType     | Surcharge                                   |
      | rtsChargeValue    | 0                                           |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - RTS Charge, Surcharge - Values more than 2 Decimals (uid:be570901-3fc3-42b2-8e2b-45238af976c9)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | rtsChargeType  | Surcharge                             |
      | rtsChargeValue | 45.9549                               |
      | errorMessage   | Please provide only 2 decimal places. |

  Scenario: Create Pricing Profile - RTS Charge, Surcharge - NULL (uid:043f1ac0-1942-4a07-b8aa-d12a4c4c861e)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | rtsChargeType     | Surcharge                                       |
      | rtsChargeValue    | none                                            |
      | errorMessage      | This field is required.                         |

  Scenario: Create Pricing Profile - RTS Charge, Surcharge - Input Special Characters (uid:b0fec1ab-cc58-4db6-b168-680802643c91)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | rtsChargeType  | Surcharge                        |
      | rtsChargeValue | 30#$%@#                          |
      | errorMessage   | Special character is not allowed |

  Scenario: Create Pricing Profile - RTS Charge, Surcharge - Value is more than 100 (uid:33aa6033-c03d-45c0-ac06-0fe4ac23da0c)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | rtsChargeType  | Surcharge                |
      | rtsChargeValue | 150                      |
      | errorMessage   | Cannot be more than 100% |

  Scenario: Create Pricing Profile - RTS Charge, Discount (uid:87a586b8-d6b5-4a95-ac4e-0d04cc5093be)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | rtsChargeType     | Discount                                    |
      | rtsChargeValue    | 30                                          |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - RTS Charge, Discount - Values up to 2 Decimals (uid:d8c3a783-a721-413a-b892-6a91146b8c13)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | rtsChargeType     | Discount                                    |
      | rtsChargeValue    | 49.55                                       |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - RTS Charge, Discount - Value is 0 (uid:d3059e91-708e-4c1d-bbb8-27da97ad11cb)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | rtsChargeType     | Discount                                    |
      | rtsChargeValue    | 0                                           |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - RTS Charge, Discount - Values more than 2 Decimals (uid:0d3772ab-9ad0-4d1a-ac75-8f1256d49a6b)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | rtsChargeType  | Discount                              |
      | rtsChargeValue | 45.9549                               |
      | errorMessage   | Please provide only 2 decimal places. |

  Scenario: Create Pricing Profile - RTS Charge, Discount - NULL (uid:cdfccc70-4763-440d-9caf-8b501a8eb890)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | rtsChargeType     | Discount                                        |
      | rtsChargeValue    | none                                            |
      | errorMessage      | This field is required.                         |

  Scenario: Create Pricing Profile - RTS Charge, Discount - Input Special Characters (uid:f8ce6638-bc56-4138-bf78-c334187049b9)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | rtsChargeType  | Discount                         |
      | rtsChargeValue | 30#$%@#                          |
      | errorMessage   | Special character is not allowed |

  Scenario: Create Pricing Profile - Use RTS Charge Country Default (uid:15dbdc2b-9b43-4688-b905-3f3858503fe2)
    Given Operator edits shipper "{shipper-v4-dummy-pricing-profile-rts-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | comments          | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  Scenario: Create Pricing Profile - RTS Charge, Discount - Value is more than 100 (uid:d17ed74e-b694-439c-86da-f51f91255cf6)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid pricing_lever and verifies the error message
      | rtsChargeType  | Discount                 |
      | rtsChargeValue | 150                      |
      | errorMessage   | Cannot be more than 100% |
