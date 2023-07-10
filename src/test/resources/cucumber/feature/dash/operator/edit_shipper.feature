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

  @DeleteNewlyCreatedShipper
  Scenario: Change Email and phone number (uid:643c75e1-0cc1-4876-9441-d65b31486471)
    Given API Operator create new 'normal' shipper
    When Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator update basic settings of shipper "{KEY_CREATED_SHIPPER.name}":
      | shipperEmail       | {prepaid-no-order-username}      |
      | shipperPhoneNumber | {prepaid-no-order-address-phone} |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    Then Operator verifies Basic Settings on Edit Shipper page:
      | shipperEmail       | {prepaid-no-order-username}      |
      | shipperPhoneNumber | {prepaid-no-order-address-phone} |
    And DB Shipper get shipper data
      | shipperId | {KEY_CREATED_SHIPPER.legacyId} |
    And Operator verifies that following shipper personal details are correct in db:
      | email   | {prepaid-no-order-username}      |
      | contact | {prepaid-no-order-address-phone} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op