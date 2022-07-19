@MileZero @Utilities
Feature: Ninja Pack Tracking ID Generator

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CleanDownloadFolder
  Scenario: Ninja pack tid generator (sku) - success generate (uid:046e0a87-dd40-459d-bc44-07940df70631)
    When Operator go to menu Utilities -> Pack TID Generator (sku)
    And Operator select "test name 1" for product SKU in Pack TID Generator SKU page
    And Operator fill quantity with 1 in Pack TID Generator SKU page
    And Operator click Generate tracking ids button in Pack TID Generator SKU page
    And Operator verifies Ninja Pack tracking ID SKU file contains 1 records
    When Operator saves generated Ninja Pack SKU Tracking IDs from file
    And DB Operator verifies Ninja Pack Tracking ID record:
      | trackingId  | {KEY_LIST_OF_NINJA_PACK_TRAKING_ID[1]} |
      | isUsed      | false                                  |
      | isCorporate | false                                  |
      | sku         | tes-sku-1                              |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op