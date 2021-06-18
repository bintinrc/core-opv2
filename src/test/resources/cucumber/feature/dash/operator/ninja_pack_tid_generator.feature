@OperatorV2 @Utilities @NinjaPackTrackingIdGenerator
Feature: Ninja Pack Tracking ID Generator

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Ninja pack tid generator - success generate (uid:cf4880a4-0023-4526-9930-df9bba15a128)
    When Operator go to menu Utilities -> Ninja Pack Tracking ID Generator
    And Operator enters 2 quantity on Ninja Pack Tracking ID Generator page
    And Operator clicks Generate button on Ninja Pack Tracking ID Generator page
    Then Operator verifies quantity is 2 in Review Ninja Pack ID generator selection dialog
    When Operator clicks Confirm button in Review Ninja Pack ID generator selection dialog
    Then Operator verifies that success toast displayed:
      | top                | Tracking ID generated successfully |
      | waitUntilInvisible | true                               |
    And Operator verifies Ninja Pack tracking ID file contains 2 records
    When Operator saves generated Ninja Pack Tracking IDs from file
    And DB Operator verifies Ninja Pack Tracking ID record:
      | trackingId  | {KEY_LIST_OF_NINJA_PACK_TRAKING_ID[1]} |
      | isUsed      | false                                  |
      | isCorporate | false                                  |
      | sku         | null                                   |
    And DB Operator verifies Ninja Pack Tracking ID record:
      | trackingId  | {KEY_LIST_OF_NINJA_PACK_TRAKING_ID[2]} |
      | isUsed      | false                                  |
      | isCorporate | false                                  |
      | sku         | null                                   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op