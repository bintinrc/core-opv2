@MileZero
Feature: Edit Shipper

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipper
  Scenario: Shipper setting to hide price estimates (uid:a71bf0dc-ae57-42c0-8d0b-7649eefdd0d7)
    Given API Operator create new 'normal' shipper
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    When Operator go to "Pricing and Billing" tab on Edit Shipper page
    And Operator verify that the toggle: 'Show Pricing Estimate' is set as "Yes" under 'Pricing and Billing' tab
    And Operator set service type "Show Pricing Estimate" to "No" on edit shipper page
    Then Operator refresh page
    And Operator go to "Pricing and Billing" tab on Edit Shipper page
    And Operator verify that the toggle: 'Show Pricing Estimate' is set as "No" under 'Pricing and Billing' tab

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op