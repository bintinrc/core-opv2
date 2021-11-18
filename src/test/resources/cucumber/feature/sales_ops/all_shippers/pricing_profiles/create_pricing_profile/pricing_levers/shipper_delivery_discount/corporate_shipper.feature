@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @CreatePricingProfiles @Corporate

Feature:  Corporate Shipper

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator deletes "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}" shipper's pricing profiles
    And DB Operator deletes "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-global-id}" shipper's pricing profiles

  @CloseNewWindows
  Scenario: Create a new Corporate Shipper - Create Pricing Profile (uid:73b9a005-9f6d-4248-b054-341b0f3ae575)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Corporate HQ          |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | true                  |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | true                  |
      | isMultiParcelShipper         | true                  |
      | isDisableDriverAppReschedule | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    Then Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}                     |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | discount          | 2.00                                               |
      | comments          | This is a test pricing script                   |
      | type              | FLAT                                            |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database

  @CloseNewWindows
  Scenario: Create Pricing Profile - Corporate Shipper - with none Flat Discount - Corporate Sub Shipper who has Reference Parent's Pricing Profile is Exists (uid:d5bca341-35c6-425b-9a64-9310527ab33f)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | empty                                           |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database
    # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create Pricing Profile - Corporate Shipper - with Int Flat Discount - Corporate Sub Shipper has Reference Parent's Pricing Profile is Exists (uid:0e312444-f283-4718-8a2d-cfdfdee40126)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    # Verify pricing profile is changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create Pricing Profile - Corporate Shipper - with Int Flat Discount - Corporate Sub Shipper has their own Pricing Profile is Exists (uid:7509457c-6449-470a-8678-dd6825bf07e0)
    #create pricing profile for sub-shipper
    Given Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 3.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    #create pricing profile for shipper
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}                     |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    # Verify pricing profile is not changed - sub shipper
    And Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator gets pricing profile values
    And Operator verifies the pricing profile details are like below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 3.0                                             |
      | comments          | This is a test pricing script                   |

  @CloseNewWindows
  Scenario: Create Pricing Profile - Corporate Sub Shipper - with none Flat Discount (uid:64784cc4-74cf-4a4f-a9d1-f92769eef545)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    # create pricing profile for sub-shipper
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}                     |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | empty                                           |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    And Operator verifies the pricing profile details are like below:
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}                     |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | empty                                           |
      | comments          | This is a test pricing script                   |

  @CloseNewWindows
  Scenario: Create Pricing Profile - Corporate Sub Shipper - with Int Flat Discount (uid:69a3ab5a-3eca-45d0-af54-09436841798e)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    # create pricing profile for sub-shipper
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database

  @CloseNewWindows
  Scenario: Existing Corporate Sub Shipper - Reference Pricing Profile from Corporate (Parent) Shipper who has Active Pricing Profile  (uid:3b1dfe48-f3a6-4a5f-a471-074034e9ef11)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    When Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create Pricing Profile for Corporate Shipper, new Profile become Active, the old one become Expired - Existing Corporate Sub Shipper has their own Pricing Profile (uid:74c92443-7b17-4e0c-8b3f-26289ec34f75)
    Given Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 3.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    When Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}                     |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    Then Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    # update effective date from db
    And Operator updates effective date of pricing profile to "{gradle-next-0-day-yyyy-MM-dd}" date
    And API Script Engine clear the shipper's cache
    Then DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details in the database

  @CloseNewWindows
  Scenario: Create Pricing Profile for Corporate Shipper, new Profile become Active, the old one become Expired - Corporate Sub Shipper who has Reference Parent's Pricing Profile is Exists (uid:3b8b774a-737b-4c98-939a-c25583a393cb)
    # Corporate shipper has an active pricing profile
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-2} - {pricing-script-name-2} |
      | type              | FLAT                                            |
      | discount          | 3.0                                             |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    # Corporate shipper creates a new pricing profile
    And Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | endDate           | {gradle-next-3-day-yyyy-MM-dd}                     |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    # update effective date from db
    And Operator updates effective date of pricing profile to "{gradle-next-0-day-yyyy-MM-dd}" date
    And API Script Engine clear the shipper's cache
    Then DB Operator gets the shippers active pricing script ID
    Then DB Operator fetches pricing profile and shipper discount details
    And Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database

  @CloseNewWindows
  Scenario: Create a new Corporate Sub Shipper - Reference Pricing Profile from Corporate (Parent) Shipper who has Active Pricing Profile (uid:5a94b7c1-6242-48a4-8768-9296ac8667e9)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page
    And Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    And Operator save changes on Edit Shipper Page
    And Finance Operator waits for "3" seconds
    And Operator edits the created corporate sub-shipper
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create a new Corporate Sub Shipper - Reference Pricing Profile from Corporate (Parent) Shipper who has Active Pricing Profile and Pending Pricing Profile (uid:cb4117f6-120f-4dd2-ad0a-985cc822faa7)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.0                                             |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator adds new Shipper's Pricing Profile
      | startDate         | {gradle-next-1-day-yyyy-MM-dd}                  |
      | pricingScriptName | {pricing-script-id-all} - {pricing-script-name-all |
      | type              | FLAT                                               |
      | discount          | 2.5                                             |
      | comments          | This is a test pricing script                   |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    And  Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    And Operator verifies the pricing lever details in the database
    And Operator edits shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And Operator edits the created corporate sub-shipper
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create a new Corporate Sub Shipper - Reference Pricing Profile from Corporate (Parent) Shipper who has Active and Expired Pricing Profile (uid:7b197eb6-f33a-4f1e-8b95-6a5f171e3926)
    Given Operator edits shipper "{shipper-sop-corp-active-expired-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And Operator edits the created corporate sub-shipper
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-active-expired-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @CloseNewWindows
  Scenario: Create a new Corporate Sub Shipper - Reference Pricing Profile from Corporate (Parent) Shipper who has Expired Pricing Profile only (uid:c36e6129-acfa-45a4-b049-8d0b49f1cd87)
    Given Operator edits shipper "{shipper-sop-corp-expired-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"
    When Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And Operator edits the created corporate sub-shipper
    And Operator verifies the pricing profile is referred to parent shipper "{shipper-sop-corp-expired-v4-dummy-pricing-profile-Delivery-Discount-legacy-id}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op