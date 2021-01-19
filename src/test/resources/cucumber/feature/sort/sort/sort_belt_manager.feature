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
    And Operator fill data in Create Configuration modal:
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
    And Operator fill data in Create Configuration modal:
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
    And Operator fill data in Create Configuration modal:
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
    And Operator fill data in Create Configuration modal:
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
    And Operator fill data in Create Configuration modal:
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
    And Operator fill data in Create Configuration modal:
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
    And Operator fill data in Create Configuration modal:
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
    And Operator verifies combination appears under Unique Combination table:
      | armOutput      | Arm 1        |
      | destinationHub | {hub-name-3} |
      | orderTag       | OPV2AUTO2    |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed

  Scenario: Change Unassigned Parcel Arm for the Existing Config - From Arm X To None (uid:35bdf0fe-0034-430c-b12f-1b523178603c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
      | firstFilter         | Destination Hubs |
      | secondFilter        | Order Tags       |
      | unassignedParcelArm | Arm 1            |
    And Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    And Operator select combination value for "Arm 2"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
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
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    And Operator verifies Unassigned Parcel Arm is "Arm 1" on Sort Belt Manager page
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator Change Unassigned Parcel Arm to "None" on Edit Configuration page
    And Operator select combination value for "Arm 1"
      | status          | Enabled      |
      | destinationHubs | {hub-name-3} |
      | orderTags       | OPV2AUTO2    |
    And Operator click Confirm button on Edit Configuration page
    Then Operator verifies combinations appear under Unique Combination table:
      | armOutput | destinationHub | orderTag  |
      | Arm 1     | {hub-name-3}   | OPV2AUTO2 |
      | Arm 2     | {hub-name}     | OPV2AUTO1 |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed
    And Operator verifies Unassigned Parcel Arm is "None" on Sort Belt Manager page

  Scenario: Change Unassigned Parcel Arm for the Existing Config - From None To Arm X (uid:379a95b0-732c-4834-b7d5-63da1655c04c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    And Operator verifies Unassigned Parcel Arm is "None" on Sort Belt Manager page
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator opens Change Unassigned Parcel Arm modal on Edit Configuration page
    And Operator selects "Arm 1" Unassigned Parcel Arm on Edit Configuration page
    Then Operator verifies filter values in Change Unassigned Parcel Arm modal:
      | Destination Hub | {hub-name} |
      | Order Tag       | OPV2AUTO1  |
    And Operator verifies "Filter values on Arm 1 will be removed." message is displayed in Change Unassigned Parcel Arm modal
    When Operator click Confirm button in Change Unassigned Parcel Arm modal
    And Operator click Confirm button on Edit Configuration page
    Then Operator verifies combinations appear under Unique Combination table:
      | armOutput | destinationHub | orderTag  |
      | Arm 2     | {hub-name-3}   | OPV2AUTO2 |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed
    And Operator verifies Unassigned Parcel Arm is "Arm 1" on Sort Belt Manager page

  Scenario: Change Unassigned Parcel Arm for the New Config - From None To Arm X (uid:7ce865ed-66df-4bcd-81fa-b3fb43a42198)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
    And Operator opens Change Unassigned Parcel Arm modal on Edit Configuration page
    And Operator selects "Arm 1" Unassigned Parcel Arm on Edit Configuration page
    Then Operator verifies filter values in Change Unassigned Parcel Arm modal:
      | Destination Hub | {hub-name} |
      | Order Tag       | OPV2AUTO1  |
    And Operator verifies "Filter values on Arm 1 will be removed." message is displayed in Change Unassigned Parcel Arm modal
    When Operator click Confirm button in Change Unassigned Parcel Arm modal
    And Operator click Confirm button on Edit Configuration page
    Then Operator verifies combinations appear under Unique Combination table:
      | armOutput | destinationHub | orderTag  |
      | Arm 2     | {hub-name-3}   | OPV2AUTO2 |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    And Operator verifies Unassigned Parcel Arm is "Arm 1" on Sort Belt Manager page

  Scenario: Change Unassigned Parcel Arm for the New Config - From Arm X To None (uid:67e969e9-1768-49c5-a847-22fe2307ad00)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
      | firstFilter         | Destination Hubs |
      | secondFilter        | Order Tags       |
      | unassignedParcelArm | Arm 1            |
    And Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    And Operator select combination value for "Arm 2"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
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
    And Operator Change Unassigned Parcel Arm to "None" on Edit Configuration page
    And Operator select combination value for "Arm 1"
      | status          | Enabled      |
      | destinationHubs | {hub-name-3} |
      | orderTags       | OPV2AUTO2    |
    And Operator click Confirm button on Edit Configuration page
    Then Operator verifies combinations appear under Unique Combination table:
      | armOutput | destinationHub | orderTag  |
      | Arm 1     | {hub-name-3}   | OPV2AUTO2 |
      | Arm 2     | {hub-name}     | OPV2AUTO1 |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    And Operator verifies Unassigned Parcel Arm is "None" on Sort Belt Manager page

  Scenario: Change Unassigned Parcel Arm for the New Config - From Arm X To Arm Y (uid:cd0823b8-f7a9-4944-a42c-fb4e3dfe05da)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
      | firstFilter         | Destination Hubs |
      | secondFilter        | Order Tags       |
      | unassignedParcelArm | Arm 1            |
    And Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    And Operator select combination value for "Arm 2"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
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
    And Operator opens Change Unassigned Parcel Arm modal on Edit Configuration page
    And Operator selects "Arm 2" Unassigned Parcel Arm on Edit Configuration page
    Then Operator verifies filter values in Change Unassigned Parcel Arm modal:
      | Destination Hub | {hub-name} |
      | Order Tag       | OPV2AUTO1  |
    And Operator verifies "Filter values on Arm 2 will transfer to Arm 1." message is displayed in Change Unassigned Parcel Arm modal
    When Operator click Confirm button in Change Unassigned Parcel Arm modal
    And Operator click Confirm button on Edit Configuration page
    Then Operator verifies combinations appear under Unique Combination table:
      | armOutput | destinationHub | orderTag  |
      | Arm 1     | {hub-name}     | OPV2AUTO1 |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    And Operator verifies Unassigned Parcel Arm is "Arm 2" on Sort Belt Manager page

  Scenario: Change Unassigned Parcel Arm for the Existing Config - From Arm X To Arm Y (uid:558d6e5c-0ee2-48ac-9007-dcbc6da71699)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
      | firstFilter         | Destination Hubs |
      | secondFilter        | Order Tags       |
      | unassignedParcelArm | Arm 1            |
    And Operator input Configuration name and description
      | configName  | AUTO {gradle-current-date-yyyyMMddHHmmsss} |
      | description | Created for test automation purposes       |
    And Operator select combination value for "Arm 2"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
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
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    And Operator verifies Unassigned Parcel Arm is "Arm 1" on Sort Belt Manager page
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator opens Change Unassigned Parcel Arm modal on Edit Configuration page
    And Operator selects "Arm 2" Unassigned Parcel Arm on Edit Configuration page
    Then Operator verifies filter values in Change Unassigned Parcel Arm modal:
      | Destination Hub | {hub-name} |
      | Order Tag       | OPV2AUTO1  |
    And Operator verifies "Filter values on Arm 2 will transfer to Arm 1." message is displayed in Change Unassigned Parcel Arm modal
    When Operator click Confirm button in Change Unassigned Parcel Arm modal
    And Operator click Confirm button on Edit Configuration page
    Then Operator verifies combinations appear under Unique Combination table:
      | armOutput | destinationHub | orderTag  |
      | Arm 1     | {hub-name}     | OPV2AUTO1 |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed
    And Operator verifies Unassigned Parcel Arm is "Arm 2" on Sort Belt Manager page

  Scenario: Update Configuration and Define Unique Combination for Different Arm (uid:e93e6d2d-eb56-4364-aea6-d1d8b22e375c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
      | status | Disabled |
    And Operator select combination value for "Arm 3"
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
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator select combination value for "Arm 2"
      | status          | Enabled      |
      | destinationHubs | {hub-name-3} |
      | orderTags       | OPV2AUTO2    |
    And Operator click Confirm button on Edit Configuration page
    Then Operator verify there are no result under Duplicate Combination table
    And Operator verifies combinations appear under Unique Combination table:
      | armOutput | destinationHub | orderTag  |
      | Arm 1     | {hub-name}     | OPV2AUTO1 |
      | Arm 2     | {hub-name-3}   | OPV2AUTO2 |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed

  Scenario: Update Configuration and Define Duplicate Combination for Different Arm (uid:b322c28e-8069-4f27-969f-5b8a97f2b989)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
      | status | Disabled |
    And Operator select combination value for "Arm 3"
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
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator select combination value for "Arm 2"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator click Confirm button on Edit Configuration page
    Then Operator verifies combination appears under Duplicate Combination table:
      | armOutput      | Arm 1, Arm 2 |
      | destinationHub | {hub-name}   |
      | orderTag       | OPV2AUTO1    |
    And Operator verify there are no result under Unique Combination table
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed

  Scenario: Update Configuration and Define Unique Combination for Same Arm (uid:fcd7a003-f076-450e-9d36-517dd9da70b6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
      | status | Disabled |
    And Operator select combination value for "Arm 3"
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
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator add combination value for "Arm 1"
      | destinationHubs | {hub-name-3} |
      | orderTags       | OPV2AUTO2    |
    And Operator click Confirm button on Edit Configuration page
    Then Operator verify there are no result under Duplicate Combination table
    And Operator verifies combinations appear under Unique Combination table:
      | armOutput | destinationHub | orderTag  |
      | Arm 1     | {hub-name}     | OPV2AUTO1 |
      | Arm 1     | {hub-name-3}   | OPV2AUTO2 |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed

  Scenario: Update Configuration and Define Duplicate Combination for Same Arm (uid:21a12cb3-ef7f-4b3e-a441-1b328f987157)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
      | status | Disabled |
    And Operator select combination value for "Arm 3"
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
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator add combination value for "Arm 1"
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator click Confirm button on Edit Configuration page
    Then Operator verifies combination appears under Duplicate Combination table:
      | armOutput      | Arm 1, Arm 1 |
      | destinationHub | {hub-name}   |
      | orderTag       | OPV2AUTO1    |
    And Operator verify there are no result under Unique Combination table
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed

  Scenario: Update Configuration and Define Unique and Duplicate Combinations for Same Arm (uid:9c8c301e-e754-4f3c-9f6e-2dda05aa54f9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
      | status | Disabled |
    And Operator select combination value for "Arm 3"
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
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator add combination value for "Arm 1"
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator add combination value for "Arm 1"
      | destinationHubs | {hub-name-3} |
      | orderTags       | OPV2AUTO2    |
    And Operator click Confirm button on Edit Configuration page
    Then Operator verifies combination appears under Duplicate Combination table:
      | armOutput      | Arm 1, Arm 1 |
      | destinationHub | {hub-name}   |
      | orderTag       | OPV2AUTO1    |
    And Operator verifies combination appears under Unique Combination table:
      | armOutput      | Arm 1        |
      | destinationHub | {hub-name-3} |
      | orderTag       | OPV2AUTO2    |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed

  Scenario: Update Configuration and Define Unique and Duplicate Combinations for Different Arm (uid:db849e38-d8af-4f16-93f7-029bef487fdd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
      | status | Disabled |
    And Operator select combination value for "Arm 3"
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
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Created" success notification is displayed
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator select combination value for "Arm 2"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    And Operator select combination value for "Arm 3"
      | status          | Enabled      |
      | destinationHubs | {hub-name-3} |
      | orderTags       | OPV2AUTO2    |
    And Operator click Confirm button on Edit Configuration page
    Then Operator verifies combination appears under Duplicate Combination table:
      | armOutput      | Arm 1, Arm 2 |
      | destinationHub | {hub-name}   |
      | orderTag       | OPV2AUTO1    |
    And Operator verifies combination appears under Unique Combination table:
      | armOutput      | Arm 3        |
      | destinationHub | {hub-name-3} |
      | orderTag       | OPV2AUTO2    |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed

  Scenario: Remove Combination from an Arm (uid:33f93f97-cb49-49a0-bd7e-a522f03935cd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
    And Operator click Confirm button on Configuration Summary page
    And Operator verifies that "Configuration Created" success notification is displayed
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator remove 2 combination for "Arm 1"
    And Operator click Confirm button on Edit Configuration page
    Then Operator verify there are no result under Duplicate Combination table
    And Operator verifies combination appears under Unique Combination table:
      | armOutput      | Arm 1      |
      | destinationHub | {hub-name} |
      | orderTag       | OPV2AUTO1  |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed

  Scenario: Change Active Configuration (uid:771d3341-7f52-4046-b055-5ff2797dca23)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
    And Operator click Confirm button on Configuration Summary page
    And Operator verifies that "Configuration Created" success notification is displayed
    When Operator save active configuration value on Sort Belt Manager page
    And Operator change active configuration to "{KEY_CREATED_SORT_BELT_CONFIG}" on Sort Belt Manager page
    Then Operator verifies that "Configuration Activated" success notification is displayed
    And Operator verify active configuration values on Sort Belt Manager page:
      | activeConfiguration   | {KEY_CREATED_SORT_BELT_CONFIG}   |
      | previousConfiguration | {KEY_ACTIVE_SORT_BELT_CONFIG}    |
      | lastChangedAt         | {gradle-current-date-yyyy-MM-dd} |

  Scenario: Disable Arm (uid:b9e3f527-bf57-49c0-a36f-cb988ae38e88)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    And Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    And Operator click Proceed button on Sort Belt Manager page
    And Operator click Create Configuration button
    And Operator fill data in Create Configuration modal:
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
    And Operator click Confirm button on Configuration Summary page
    And Operator verifies that "Configuration Created" success notification is displayed
    When Operator click Edit Configuration button on Sort Belt Manager page
    And Operator select combination value for "Arm 2"
      | status | Disabled |
    And Operator click Confirm button on Edit Configuration page
    Then Operator verify there are no result under Duplicate Combination table
    And Operator verifies combination appears under Unique Combination table:
      | armOutput      | Arm 1      |
      | destinationHub | {hub-name} |
      | orderTag       | OPV2AUTO1  |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verifies that "Configuration Updated" success notification is displayed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op