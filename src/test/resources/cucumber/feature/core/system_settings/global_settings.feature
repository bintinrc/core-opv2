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

  @RestoreSmsNotificationsSettingsV2  @MediumPriority
  Scenario: Operator Update SMS Notification Settings - Enable Van Inbound SMS Shipper Ids (uid:5138946c-664b-4978-927b-e2cdebe98697)
    And API Core - Operator gets SMS notifications settings
    When Operator go to menu System Settings -> Global Settings
    And Operator check 'Enable Van Inbound SMS Shipper Ids' checkbox on Global Settings page
    And Operator add " {global-settings-shipper-name} " shipper to Exempted Shippers from Van Inbound SMS on Global Settings page
    And Operator clicks 'Update SMS Settings' button on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies that Exempted Shippers from Van Inbound SMS contains "{global-settings-shipper-legacy-id}-{global-settings-shipper-name}" shipper on Global Settings page

  @RestoreSmsNotificationsSettingsV2 @MediumPriority
  Scenario: Operator Update SMS Notification Settings - Enable Return Pickup SMS Shipper Ids (uid:567792fc-dd86-461c-b742-872a47cba620)
    And API Core - Operator gets SMS notifications settings
    When Operator go to menu System Settings -> Global Settings
    And Operator check 'Enable Return Pickup SMS Shipper Ids' checkbox on Global Settings page
    And Operator add " {global-settings-shipper-name} " shipper to Exempted Shippers from Return Pickup SMS on Global Settings page
    And Operator clicks 'Update SMS Settings' button on Global Settings page
    Then Operator verifies that success toast displayed:
      | top | Updated |
    When Operator refresh page
    Then Operator verifies that Exempted Shippers from Return Pickup SMS contains "{global-settings-shipper-legacy-id}-{global-settings-shipper-name}" shipper on Global Settings page
