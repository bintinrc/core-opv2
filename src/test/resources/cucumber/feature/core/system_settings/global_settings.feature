@OperatorV2 @Core @SystemSettings @GlobalSettings
Feature: Global Settings

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @RestoreInboundSettingsV2 @MediumPriority
  Scenario: Operator Set Global Inbound Weight Settings - Weight Tollerance (uid:6d7fa00e-5af8-4831-9edf-16bd18faf707)
    When Operator go to menu System Settings -> Global Settings
    And Operator save inbound settings from Global Settings page
    And Operator set Weight Tolerance value to "44.0" on Global Settings page
    And Operator save Weight Tolerance settings on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies Weight Tolerance value is "44.0" on Global Settings page

  @RestoreInboundSettingsV2 @MediumPriority
  Scenario: Operator Set Global Inbound Weight Settings - Weight Limit (uid:9adccb4b-c7c7-49e3-91cf-3890d6ac4c4f)
    When Operator go to menu System Settings -> Global Settings
    And Operator save inbound settings from Global Settings page
    And Operator set Weight Limit value to "44.0" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies Weight Limit value is "44.0" on Global Settings page

  @RestoreSmsNotificationsSettingsV2 @DeleteNewlyCreatedShipperCommonV2 @MediumPriority
  Scenario: Operator Update SMS Notification Settings - Enable Van Inbound SMS Shipper Ids (uid:5138946c-664b-4978-927b-e2cdebe98697)
    And API Core - Operator gets SMS notifications settings
    And API Shipper - Operator create new shipper using data below:
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
    And API Shipper - Operator reload all shipper cache
    And API Shipper - Operator fetch shipper id by legacy shipper id "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}"
    When Operator go to menu System Settings -> Global Settings
    And Operator check 'Enable Van Inbound SMS Shipper Ids' checkbox on Global Settings page
    And API Shipper - Operator wait until shipper available to search using data below:
      | searchShipperRequest | {"search_field":{"match_type":"default","fields":["id"],"value":{KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}}} |
    And Operator add " {KEY_SHIPPER_LIST_OF_SHIPPERS[1].name} " shipper to Exempted Shippers from Van Inbound SMS on Global Settings page
    And Operator clicks 'Update SMS Settings' button on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies that Exempted Shippers from Van Inbound SMS contains "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}-{KEY_SHIPPER_LIST_OF_SHIPPERS[1].name}" shipper on Global Settings page

  @RestoreSmsNotificationsSettingsV2 @DeleteNewlyCreatedShipperCommonV2 @MediumPriority
  Scenario: Operator Update SMS Notification Settings - Enable Return Pickup SMS Shipper Ids (uid:567792fc-dd86-461c-b742-872a47cba620)
    And API Core - Operator gets SMS notifications settings
    And API Shipper - Operator create new shipper using data below:
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
    And API Shipper - Operator reload all shipper cache
    And API Shipper - Operator fetch shipper id by legacy shipper id "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}"
    When Operator go to menu System Settings -> Global Settings
    And Operator check 'Enable Return Pickup SMS Shipper Ids' checkbox on Global Settings page
    And API Shipper - Operator wait until shipper available to search using data below:
      | searchShipperRequest | {"search_field":{"match_type":"default","fields":["id"],"value":{KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}}} |
    And Operator add " {KEY_SHIPPER_LIST_OF_SHIPPERS[1].name} " shipper to Exempted Shippers from Return Pickup SMS on Global Settings page
    And Operator clicks 'Update SMS Settings' button on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies that Exempted Shippers from Return Pickup SMS contains "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}-{KEY_SHIPPER_LIST_OF_SHIPPERS[1].name}" shipper on Global Settings page
