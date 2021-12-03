@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfilesID @CreatePricingProfilesID
Feature: Create Pricing Profile - ID

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator changes the country to "Indonesia"

  @CloseNewWindows @DeletePricingProfile @HappyPathID
  Scenario: Create Pricing Profile - with Percentage Discount where Shipper has Active & Expired Pricing Profile (uid:bafe6400-ee59-4068-9e6d-fc3395ac7a8a)
    And Operator edits shipper "{shipper-v4-active-expired-pp-legacy-id}"
    Then Operator verifies that Pricing Script is "Active" and "Expired"
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 20.00                                           |
      | comments          | This is a test pricing script                   |
      | type              | PERCENTAGE                                      |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows
  Scenario: Create Pricing Profile - with 0 Percentage Discount (uid:71f8c382-2c78-4ba7-b052-ada13861d606)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid discount and verifies the error message
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 0                                               |
      | errorMessage      | 0 is not a valid discount value                 |

  @DeleteNewlyCreatedShipper @CloseNewWindows @HappyPathID
  Scenario: Create Pricing Profile - with none Percentage Discount (uid:67f49a74-87a8-4db8-b1a7-7787f4dd70e9)
    Given API Operator create new normal shipper
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | comments          | This is a test pricing script                   |
      | type              | PERCENTAGE                                      |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile details
    And Operator verifies the pricing profile and shipper discount details are correct

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Pricing Profile - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage - ID (uid:63d13a1d-cdbb-4a48-bde9-7c962f0101f8)
    Given API Operator create new normal shipper
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    When Operator adds new Shipper's Pricing Profile
      | startDate           | {gradle-next-2-day-yyyy-MM-dd}                  |
      | pricingScriptName   | {pricing-script-id-2} - {pricing-script-name-2} |
      | type                | PERCENTAGE                                      |
      | discount            | 20                                              |
      | insuranceMinFee     | 3000                                            |
      | insurancePercentage | 1                                               |
      | insuranceThreshold  | 0                                               |
      | comments            | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Pricing Profile - with 'Int' COD Min Fee and 'Int' COD Percentage - ID (uid:eb8347c5-468c-4909-9dcd-d0f37f395f7c)
    Given API Operator create new normal shipper
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-2-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | PERCENTAGE                                      |
      | discount          | 20                                              |
      | codMinFee         | 3000                                            |
      | codPercentage     | 1                                               |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Pricing Profile - RTS Charge, Surcharge - ID (uid:4d044c16-5a84-437a-a2e6-fe792f815a93)
    Given API Operator create new normal shipper
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | PERCENTAGE                                      |
      | discount          | 20                                              |
      | rtsChargeType     | Surcharge                                       |
      | rtsChargeValue    | 30                                              |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
