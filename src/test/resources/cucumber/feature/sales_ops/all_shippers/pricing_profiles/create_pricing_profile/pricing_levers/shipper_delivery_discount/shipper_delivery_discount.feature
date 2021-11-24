@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache  @PricingProfiles @CreatePricingProfiles @DeliveryDiscount @NormalShipper
Feature:  Create Pricing Profile - Normal Shippers - Shipper Delivery Discount

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
@test
@CloseNewWindows @DeletePricingProfile @HappyPath
  Scenario: Create Pricing Profile - with Flat Discount where Shipper has Active & Expired Pricing Profile (uid:0e077755-8ca3-41af-8c7e-a852ab0ad0f2)
  And Operator edits shipper "{shipper-v4-active-expired-pp-legacy-id}"
  Then Operator verifies that Pricing Script is "Active" and "Expired"
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 20.00                                           |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows @HappyPath
  Scenario: Create Pricing Profile - with 0 Flat Discount (uid:e5ba2876-828e-4340-9208-d294ea2052b1)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid discount and verifies the error message
      | discount     | 0                               |
      | errorMessage | 0 is not a valid discount value |

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Pricing Profile - with none Flat Discount (uid:3895c1e8-58b5-4625-9175-788c133a4b92)
    Given API Operator create new normal shipper
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows
  Scenario: Create Pricing Profile - with special characters Discount (uid:4dde3d48-2513-4c84-9b6c-4b848833d3eb)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid discount and verifies the error message
      | discount     | $#^$^#@                          |
      | errorMessage | Special character is not allowed |

  @CloseNewWindows
  Scenario: Create Pricing Profile - with 3-5 integer after decimal point (uid:30ed9502-76df-4695-8a33-f21d40dc9ad5)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid discount and verifies the error message
      | discount     | 20.54321                              |
      | comments     | This is an invalid discount           |
      | errorMessage | Please provide only 2 decimal places. |

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Create Pricing Profile - with shipper discount within 6 digits Flat Discount (uid:5e17e04a-7461-4546-9e3b-20dc2add40e6)
    Given API Operator create new normal shipper
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 50000.00                                        |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @CloseNewWindows
  Scenario: Create Pricing Profile - with shipper discount over 6 digits Flat Discount (uid:7e8428a0-4af4-4d08-b168-4837a8606f7d)
    Given Operator go to menu Shipper -> All Shippers
    When Operator adds new pricing Profile
    Then Operator adds pricing script with invalid discount and verifies the error message
      | discount     | 10000000                           |
      | comments     | This is an invalid discount        |
      | errorMessage | Discounts cannot exceed 6 figures. |

  @test
  @DeleteNewlyCreatedShipper
  Scenario: Create Pricing Profile - with Int Discount (uid:79bb423b-36d1-49a0-8b22-34972253afe7)
    Given API Operator create new normal shipper
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | discount          | 20                                              |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
