@Sort @SortBeltManager
Feature: Sort Belt Manager

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Can Not Create Incomplete Combination of Configuration (uid:8ad3ff31-9929-4946-b9b7-309f403721c4)
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    When Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    When Operator click Create Configuration button
    When Operator select Filters
      | firstFilter  | Destination Hubs |
      | secondFilter | Order Tags       |
    When Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    And Operator click Confirm button on Create Configuration page
    Then Operator verifies that "Incomplete Form Submission" error notification is displayed
    When Operator refresh page
    And Sort Belt Manager page is loaded
    When Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    When Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    Then Make sure new configuration is not created

  Scenario: Create Configuration and Define Duplicate Combination for Same Arm (uid:9c001ce9-23d3-4a21-802e-312cd667f501)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    When Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    When Operator click Create Configuration button
    When Operator select Filters
      | firstFilter  | Destination Hubs |
      | secondFilter | Order Tags       |
    When Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    When Operator select combination value for "Arm 1"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    When Operator add combination value for "Arm 1"
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    When Operator select combination value for "Arm 2"
      | status | Disabled |
    When Operator select combination value for "Arm 3"
      | status | Disabled |
    When Operator select combination value for "Arm 4"
      | status | Disabled |
    When Operator select combination value for "Arm 5"
      | status | Disabled |
    When Operator select combination value for "Arm 6"
      | status | Disabled |
    When Operator select combination value for "Arm 7"
      | status | Disabled |
    When Operator select combination value for "Arm 8"
      | status | Disabled |
    When Operator select combination value for "Arm 9"
      | status | Disabled |
    When Operator select combination value for "Arm 10"
      | status | Disabled |
    When Operator select combination value for "Arm 11"
      | status | Disabled |
    When Operator select combination value for "Arm 12"
      | status | Disabled |
    When Operator select combination value for "Arm 13"
      | status | Disabled |
    When Operator select combination value for "Arm 14"
      | status | Disabled |
    When Operator select combination value for "Arm 15"
      | status | Disabled |
    And Operator click Confirm button on Create Configuration page
    Then Operator verifies combination appears under Duplicate Combination table:
      | armOutput      | Arm 1, Arm 1 |
      | destinationHub | {hub-name}   |
      | orderTag       | OPV2AUTO1    |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed

  Scenario: Create Configuration and Define Duplicate Combination for Different Arm (uid:92b4ac93-9bd3-4f59-a3fb-51e1734106da)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator select Filters
      | firstFilter  | Destination Hubs |
      | secondFilter | Order Tags       |
    When Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    And Operator select combination value for "Arm 1"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator select combination value for "Arm 2"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator select combination value for "Arm 3"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    When Operator select combination value for "Arm 4"
      | status | Disabled |
    When Operator select combination value for "Arm 5"
      | status | Disabled |
    When Operator select combination value for "Arm 6"
      | status | Disabled |
    When Operator select combination value for "Arm 7"
      | status | Disabled |
    When Operator select combination value for "Arm 8"
      | status | Disabled |
    When Operator select combination value for "Arm 9"
      | status | Disabled |
    When Operator select combination value for "Arm 10"
      | status | Disabled |
    When Operator select combination value for "Arm 11"
      | status | Disabled |
    When Operator select combination value for "Arm 12"
      | status | Disabled |
    When Operator select combination value for "Arm 13"
      | status | Disabled |
    When Operator select combination value for "Arm 14"
      | status | Disabled |
    When Operator select combination value for "Arm 15"
      | status | Disabled |
    And Operator click Confirm button on Create Configuration page
    Then Operator verifies combination appears under Duplicate Combination table:
      | armOutput      | Arm 1, Arm 2, Arm 3 |
      | destinationHub | {hub-name}          |
      | orderTag       | OPV2AUTO1           |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed

  Scenario: Create Configuration and Define Unique Combination for Different Arm (uid:c7b5ad7e-a393-4bb4-bf0c-4baefe053a76)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator select Filters
      | firstFilter  | Destination Hubs |
      | secondFilter | Order Tags       |
    And Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    And Operator select combination value for "Arm 1"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator select combination value for "Arm 2"
      | status          | Enabled      |
      | destinationHubs | {hub-name-3} |
      | orderTags       | OPV2AUTO2    |
    And Operator select combination value for "Arm 3"
      | status | Disabled |
    And Operator select combination value for "Arm 4"
      | status | Disabled |
    And Operator select combination value for "Arm 5"
      | status | Disabled |
    And Operator select combination value for "Arm 6"
      | status | Disabled |
    And Operator select combination value for "Arm 7"
      | status | Disabled |
    And Operator select combination value for "Arm 8"
      | status | Disabled |
    And Operator select combination value for "Arm 9"
      | status | Disabled |
    And Operator select combination value for "Arm 10"
      | status | Disabled |
    And Operator select combination value for "Arm 11"
      | status | Disabled |
    And Operator select combination value for "Arm 12"
      | status | Disabled |
    And Operator select combination value for "Arm 13"
      | status | Disabled |
    And Operator select combination value for "Arm 14"
      | status | Disabled |
    And Operator select combination value for "Arm 15"
      | status | Disabled |
    And Operator click Confirm button on Create Configuration page
    Then Operator verify there are no result under Duplicate Combination table
    Then Operator verifies combinations appear under Unique Combination table:
      | armOutput | destinationHub | orderTag  |
      | Arm 1     | {hub-name}     | OPV2AUTO1 |
      | Arm 2     | {hub-name-3}   | OPV2AUTO2 |
    When Operator click Confirm button on Configuration Summary page
    And Operator verifies that "Configuration Created" success notification is displayed

  Scenario: Create Configuration and Define Unique Combination for Same Arm (uid:9726b1e3-a92f-4e03-93b3-d0cc87a60425)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator select Filters
      | firstFilter  | Destination Hubs |
      | secondFilter | Order Tags       |
    And Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    And Operator select combination value for "Arm 1"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator add combination value for "Arm 1"
      | destinationHubs | {hub-name-3} |
      | orderTags       | OPV2AUTO2    |
    And Operator select combination value for "Arm 2"
      | status | Disabled |
    And Operator select combination value for "Arm 3"
      | status | Disabled |
    And Operator select combination value for "Arm 4"
      | status | Disabled |
    And Operator select combination value for "Arm 5"
      | status | Disabled |
    And Operator select combination value for "Arm 6"
      | status | Disabled |
    And Operator select combination value for "Arm 7"
      | status | Disabled |
    And Operator select combination value for "Arm 8"
      | status | Disabled |
    And Operator select combination value for "Arm 9"
      | status | Disabled |
    And Operator select combination value for "Arm 10"
      | status | Disabled |
    And Operator select combination value for "Arm 11"
      | status | Disabled |
    And Operator select combination value for "Arm 12"
      | status | Disabled |
    And Operator select combination value for "Arm 13"
      | status | Disabled |
    And Operator select combination value for "Arm 14"
      | status | Disabled |
    And Operator select combination value for "Arm 15"
      | status | Disabled |
    And Operator click Confirm button on Create Configuration page
    Then Operator verify there are no result under Duplicate Combination table
    Then Operator verifies combinations appear under Unique Combination table:
      | armOutput | destinationHub | orderTag  |
      | Arm 1     | {hub-name}     | OPV2AUTO1 |
      | Arm 1     | {hub-name-3}   | OPV2AUTO2 |
    When Operator click Confirm button on Configuration Summary page
    And Operator verifies that "Configuration Created" success notification is displayed

  Scenario: Create Configuration and Define Unique and Duplicate Combinations for Different Arm (uid:bf54d220-8e92-4bb1-88b1-4b0784033433)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator select Filters
      | firstFilter  | Destination Hubs |
      | secondFilter | Order Tags       |
    When Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    And Operator select combination value for "Arm 1"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator select combination value for "Arm 2"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator select combination value for "Arm 3"
      | status          | Enabled      |
      | destinationHubs | {hub-name-3} |
      | orderTags       | OPV2AUTO2    |
    When Operator select combination value for "Arm 4"
      | status | Disabled |
    When Operator select combination value for "Arm 5"
      | status | Disabled |
    When Operator select combination value for "Arm 6"
      | status | Disabled |
    When Operator select combination value for "Arm 7"
      | status | Disabled |
    When Operator select combination value for "Arm 8"
      | status | Disabled |
    When Operator select combination value for "Arm 9"
      | status | Disabled |
    When Operator select combination value for "Arm 10"
      | status | Disabled |
    When Operator select combination value for "Arm 11"
      | status | Disabled |
    When Operator select combination value for "Arm 12"
      | status | Disabled |
    When Operator select combination value for "Arm 13"
      | status | Disabled |
    When Operator select combination value for "Arm 14"
      | status | Disabled |
    When Operator select combination value for "Arm 15"
      | status | Disabled |
    And Operator click Confirm button on Create Configuration page
    Then Operator verifies combination appears under Duplicate Combination table:
      | armOutput      | Arm 1, Arm 2 |
      | destinationHub | {hub-name}   |
      | orderTag       | OPV2AUTO1    |
    Then Operator verifies combination appears under Unique Combination table:
      | armOutput      | Arm 3        |
      | destinationHub | {hub-name-3} |
      | orderTag       | OPV2AUTO2    |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed

  Scenario: Create Configuration and Define Unique and Duplicate Combinations for Same Arm (uid:b0c36e1f-03e4-42d0-8e9a-ff67920bc329)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator select Filters
      | firstFilter  | Destination Hubs |
      | secondFilter | Order Tags       |
    When Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    And Operator select combination value for "Arm 1"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator add combination value for "Arm 1"
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator add combination value for "Arm 1"
      | destinationHubs | {hub-name-3} |
      | orderTags       | OPV2AUTO2    |
    And Operator select combination value for "Arm 2"
      | status | Disabled |
    And Operator select combination value for "Arm 3"
      | status | Disabled |
    When Operator select combination value for "Arm 4"
      | status | Disabled |
    When Operator select combination value for "Arm 5"
      | status | Disabled |
    When Operator select combination value for "Arm 6"
      | status | Disabled |
    When Operator select combination value for "Arm 7"
      | status | Disabled |
    When Operator select combination value for "Arm 8"
      | status | Disabled |
    When Operator select combination value for "Arm 9"
      | status | Disabled |
    When Operator select combination value for "Arm 10"
      | status | Disabled |
    When Operator select combination value for "Arm 11"
      | status | Disabled |
    When Operator select combination value for "Arm 12"
      | status | Disabled |
    When Operator select combination value for "Arm 13"
      | status | Disabled |
    When Operator select combination value for "Arm 14"
      | status | Disabled |
    When Operator select combination value for "Arm 15"
      | status | Disabled |
    And Operator click Confirm button on Create Configuration page
    Then Operator verifies combination appears under Duplicate Combination table:
      | armOutput      | Arm 1, Arm 1 |
      | destinationHub | {hub-name}   |
      | orderTag       | OPV2AUTO1    |
    Then Operator verifies combination appears under Unique Combination table:
      | armOutput      | Arm 1        |
      | destinationHub | {hub-name-3} |
      | orderTag       | OPV2AUTO2    |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op