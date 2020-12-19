@Sort @SortBeltManager
Feature: Sort Belt Manager

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Can Not Create Incomplete Combination of Configuration (uid:8ad3ff31-9929-4946-b9b7-309f403721c4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    When Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    When Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    When Operator click Create Configuration button
    When Operator select Filters
      | firstFilter  | Destination Hubs |
      | secondFilter | Order Tags       |
    When Operator input Configuration name and description
      | configName  | GENERATED                            |
      | description | Created for test automation purposes |
    Then Operator verify Incomplete form submission toast is shown
    When Operator refresh page
    When Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    When Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    Then Make sure new configuration is not created

  Scenario: Create Configuration and Define Duplicate Combination for Same Arm (uid:9c001ce9-23d3-4a21-802e-312cd667f501)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    When Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    When Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    When Operator click Create Configuration button
    When Operator select Filters
      | firstFilter  | Destination Hubs |
      | secondFilter | Order Tags       |
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
    When Operator input Configuration name and description
      | configName  | GENERATED                            |
      | description | Created for test automation purposes |
    Then Make sure duplicate combination is appears under Duplicate Combination table
      | armOutput       | Arm 1, Arm 1 |
      | destinationHubs | {hub-name}   |
      | orderTags       | OPV2AUTO1    |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verify Configuration created toast is shown

  Scenario: Create Configuration and Define Duplicate Combination for Different Arm (uid:92b4ac93-9bd3-4f59-a3fb-51e1734106da)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    When Operator select the hub of Sort Belt Manager
      | hubName | JKB |
    When Operator select the device id of Sort Belt Manager
      | deviceId | Hello |
    When Operator click Create Configuration button
    When Operator select Filters
      | firstFilter  | Destination Hubs |
      | secondFilter | Order Tags       |
    When Operator select combination value for "Arm 1"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    When Operator select combination value for "Arm 2"
      | status          | Enabled    |
      | destinationHubs | {hub-name} |
      | orderTags       | OPV2AUTO1  |
    When Operator select combination value for "Arm 3"
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
    When Operator input Configuration name and description
      | configName  | GENERATED                            |
      | description | Created for test automation purposes |
    Then Make sure duplicate combination is appears under Duplicate Combination table
      | armOutput       | Arm 1, Arm 2, Arm 3 |
      | destinationHubs | {hub-name}          |
      | orderTags       | OPV2AUTO1           |
    When Operator click Confirm button on Configuration Summary page
    Then Operator verify Configuration created toast is shown

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op