@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @UpdatePricingProfiles @Basic
Feature: Edit Pricing Profile - Normal Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-v4-dummy-pricing-profile-basic-global-id}" shipper's pricing profiles

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Edit Pricing Script ID (uid:f7f04ae2-65ba-45a8-8627-79f732fae1a2)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-basic-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | discount          | 10                                          |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName       | {KEY_CREATED_SHIPPER.name}                  |
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | Flat                                        |
      | discount          | 10                                          |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName       | {KEY_CREATED_SHIPPER.name}                      |
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | Flat                                            |
      | discount          | 10                                              |

  @CloseNewWindows
  Scenario: Edit Pending Pricing Profile - Edit Start Date / End Date (uid:86101231-638d-4d38-917d-79dbb1b1d07d)
    Given Operator go to menu Shipper -> All Shippers
    And Operator edits shipper "{shipper-v4-dummy-pricing-profile-basic-legacy-id}"
    And Operator add New Pricing Profile on Edit Shipper Page using data below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate           | {gradle-next-2-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | discount          | 10                                          |
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName       | {KEY_CREATED_SHIPPER.name}                  |
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}              |
      | endDate           | {gradle-next-2-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | Flat                                        |
      | discount          | 10                                          |
    When Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:
      | startDate | {gradle-next-2-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-3-day-yyyy-MM-dd} |
    And Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page
    And Operator save changes on Edit Shipper Page
    And Operator edits the created shipper
    And Operator open Edit Pricing Profile dialog on Edit Shipper Page
    Then Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:
      | shipperName       | {KEY_CREATED_SHIPPER.name}                  |
      | startDate         | {gradle-next-2-day-yyyy-MM-dd}              |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}              |
      | pricingScriptName | {pricing-script-id} - {pricing-script-name} |
      | type              | Flat                                        |
      | discount          | 10                                          |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
