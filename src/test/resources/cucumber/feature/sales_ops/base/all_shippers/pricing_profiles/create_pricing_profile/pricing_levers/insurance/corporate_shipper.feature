@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @Insurance @CreatePricingProfiles @Corporate
Feature: Corporate Shippers - Insurance

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator go to menu Shipper -> All Shippers


  Scenario: Create Pricing Profile - Corporate Shipper - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage - Corporate Sub Shipper who Reference Parent's Pricing Profile is Exists (uid:4a5db608-65c4-410f-9a3f-44eab4f64acd)
    Given DB Operator deletes "{shipper-sop-corp-v4-dummy-script-global-id}" shipper's pricing profiles
    And Operator edits shipper "{shipper-sop-corp-v4-dummy-script-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-script-legacy-id}"
    And Operator gets pricing profile values
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details

  Scenario: Create Pricing Profile - Corporate Shipper - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage - Corporate Sub Shipper who has their own Pricing Profile is Exists (uid:41f890c1-214c-4f0d-9e9f-055e3558d0d6)
    Given DB Operator deletes "{shipper-sop-corp-v4-dummy-script-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-corp-v4-dummy-script-global-id}" shipper's pricing profiles
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-script-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-script-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | pricingScript       | {pricing-script-name-2}       |
      | type                | FLAT                          |
      | discount            | 50                            |
      | insuranceMinFee     | 50                            |
      | insurancePercentage | 50                            |
      | insuranceThreshold  | 50                            |
      | comments            | This is a test pricing script |
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-script-legacy-id}"
    Then Operator verifies the pricing profile and shipper discount details are correct
    Then Operator verifies the pricing lever details
