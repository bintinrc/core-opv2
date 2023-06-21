@OperatorV2 @Core @SystemSettings @GlobalSettings
Feature: Global Settings

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @RestoreInboundSettings
  Scenario: Operator Set Global Inbound Weight Settings - Weight Tollerance (uid:6d7fa00e-5af8-4831-9edf-16bd18faf707)
    When Operator go to menu System Settings -> Global Settings
    And Operator save inbound settings from Global Settings page
    And Operator set Weight Tolerance value to "44.0" on Global Settings page
    And Operator save Weight Tolerance settings on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies Weight Tolerance value is "44.0" on Global Settings page
    And DB Operator verify 'inbound_weight_tolerance' parameter is "44.0"

  @RestoreInboundSettings
  Scenario: Operator Set Global Inbound Weight Settings - Weight Limit (uid:9adccb4b-c7c7-49e3-91cf-3890d6ac4c4f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu System Settings -> Global Settings
    And Operator save inbound settings from Global Settings page
    And Operator set Weight Limit value to "44.0" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies Weight Limit value is "44.0" on Global Settings page
    And DB Operator verify 'inbound_max_weight' parameter is "44.0"

  @RestoreSmsNotificationsSettings @DeleteShipper @CloseNewWindows
  Scenario: Operator Update SMS Notification Settings - Enable Van Inbound SMS Shipper Ids (uid:5138946c-664b-4978-927b-e2cdebe98697)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator gets SMS notifications settings
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    When Operator go to menu System Settings -> Global Settings
    And Operator check 'Enable Van Inbound SMS Shipper Ids' checkbox on Global Settings page
    And Operator add "{KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name}" shipper to Exempted Shippers from Van Inbound SMS on Global Settings page
    And Operator clicks 'Update SMS Settings' button on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies that Exempted Shippers from Van Inbound SMS contains "{KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name}" shipper on Global Settings page

  @RestoreSmsNotificationsSettings @DeleteShipper @CloseNewWindows
  Scenario: Operator Update SMS Notification Settings - Enable Return Pickup SMS Shipper Ids (uid:567792fc-dd86-461c-b742-872a47cba620)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator gets SMS notifications settings
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    When Operator go to menu System Settings -> Global Settings
    And Operator check 'Enable Return Pickup SMS Shipper Ids' checkbox on Global Settings page
    And Operator add "{KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name}" shipper to Exempted Shippers from Return Pickup SMS on Global Settings page
    And Operator clicks 'Update SMS Settings' button on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies that Exempted Shippers from Return Pickup SMS contains "{KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name}" shipper on Global Settings page
