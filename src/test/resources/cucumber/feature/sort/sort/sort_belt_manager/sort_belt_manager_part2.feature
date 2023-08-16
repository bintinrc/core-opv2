@Sort @SortBeltManagerV2Part2
Feature: Sort Belt Manager V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: SBMV2UI Create/Edit Logic Section - 0 Unassigned Arms
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator selects hub "JKB" and device "AUTOMATION-DONT-USE-0" of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator make sure there are no arms available

  Scenario: SBMV2UI Create/Edit Logic Section - Cancel On Changes
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    And Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                 |
      | description   | GENERATED                                 |
      | armFilters    | Granular Statuses,RTS,Service Levels,Tags |
      | unassignedArm | 15                                        |
    When Operator clicks cancel button in create logic
    And Operator confirms on cancel creating logic
    Then Operator make sure redirected to Sort Belt Manager main page

  Scenario: SBMV2UI Check Logic Section - Arms With No Rules
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                 |
      | description   | GENERATED                                 |
      | armFilters    | Granular Statuses,RTS,Service Levels,Tags |
      | unassignedArm | 15                                        |
    And Operator fills logic rules
      | rules | [{"Arm":"1,10,11","Description":"Brief description","Granular Statuses":"Pending Pickup,En-route to Sorting Hub,Arrived at Sorting Hub","RTS":"Yes","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","Granular Statuses":"Arrived at Sorting Hub,On Vehicle for Delivery","RTS":"No","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator deletes extra rules in create logic
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure Logic is correct as data below:
      | condition    | no rules |
      | numberOfArms | 12       |
    And Operator clicks save button in check logic
      | logicName | {KEY_SORT_SBM_CREATED_LOGIC_FORM.name} |
    And DB Sort - Operator get logic by name and description
      | name        | {KEY_SORT_SBM_CREATED_LOGIC_FORM.name}        |
      | description | {KEY_SORT_SBM_CREATED_LOGIC_FORM.description} |
    And DB Sort - Operator hard deletes logic by "{KEY_SORT_DB_SBM_CREATED_LOGIC_FORM.id}" id

  Scenario: SBMV2UI Check Logic Section - Multiple Arms With Same Rules
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                 |
      | description   | GENERATED                                 |
      | armFilters    | Granular Statuses,RTS,Service Levels,Tags |
      | unassignedArm | 15                                        |
    And Operator fills logic rules
      | rules | [{"Arm":"1,10,11","Description":"Brief description","Granular Statuses":"Pending Pickup,En-route to Sorting Hub,Arrived at Sorting Hub","RTS":"Yes","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","Granular Statuses":"Arrived at Sorting Hub,On Vehicle for Delivery","RTS":"No","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator deletes extra rules in create logic
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure Logic is correct as data below:
      | condition     | same rules |
      | numberOfArms  | 3          |
      | numberOfRules | 1          |
    And Operator clicks save button in check logic
      | logicName | {KEY_SORT_SBM_CREATED_LOGIC_FORM.name} |
    And DB Sort - Operator get logic by name and description
      | name        | {KEY_SORT_SBM_CREATED_LOGIC_FORM.name}        |
      | description | {KEY_SORT_SBM_CREATED_LOGIC_FORM.description} |
    And DB Sort - Operator hard deletes logic by "{KEY_SORT_DB_SBM_CREATED_LOGIC_FORM.id}" id

  Scenario: SBMV2UI Check Logic Section - Unique Rules And Arms
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                 |
      | description   | GENERATED                                 |
      | armFilters    | Granular Statuses,RTS,Service Levels,Tags |
      | unassignedArm | 15                                        |
    And Operator fills logic rules
      | rules | [{"Arm":"1","Description":"Brief description","Granular Statuses":"Pending Pickup,En-route to Sorting Hub,Arrived at Sorting Hub","RTS":"Yes","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","Granular Statuses":"Arrived at Sorting Hub,On Vehicle for Delivery","RTS":"No","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator deletes extra rules in create logic
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure Logic is correct as data below:
      | condition    | unique |
      | numberOfArms | 1      |
    And Operator clicks save button in check logic
      | logicName | {KEY_SORT_SBM_CREATED_LOGIC_FORM.name} |
    And DB Sort - Operator get logic by name and description
      | name        | {KEY_SORT_SBM_CREATED_LOGIC_FORM.name}        |
      | description | {KEY_SORT_SBM_CREATED_LOGIC_FORM.description} |
    And DB Sort - Operator hard deletes logic by "{KEY_SORT_DB_SBM_CREATED_LOGIC_FORM.id}" id

  Scenario: SBMV2UI Check Logic Section - Duplicate Rules
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                 |
      | description   | GENERATED                                 |
      | armFilters    | Granular Statuses,RTS,Service Levels,Tags |
      | unassignedArm | 15                                        |
    And Operator fills logic rules
      | rules | [{"Arm":"1","Description":"Brief description","Granular Statuses":"Pending Pickup","RTS":"Yes","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","Granular Statuses":"Arrived at Sorting Hub","RTS":"No","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"},{"Arm":"1","Description":"Brief description","Granular Statuses":"Pending Pickup","RTS":"Yes","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"1","Description":"Brief description","Granular Statuses":"Pending Pickup","RTS":"Yes","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","Granular Statuses":"Arrived at Sorting Hub","RTS":"No","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure Logic is correct as data below:
      | condition     | same rules |
      | numberOfArms  | 2          |
      | numberOfRules | 5          |
    And Operator make sure can not click save button in check logic
    And Operator edits the selected logic
    And Operator clicks cancel button in create logic
    And Operator make sure redirected to Sort Belt Manager main page

  Scenario: SBMV2UI Check Logic Section - Conflicting Shipment Destination And Type
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                 |
      | description   | GENERATED                                 |
      | armFilters    | Granular Statuses,RTS,Service Levels,Tags |
      | unassignedArm | 15                                        |
    And Operator fills logic rules
      | rules | [{"Arm":"1","Description":"Brief description","Granular Statuses":"Pending Pickup","RTS":"Yes","Service Levels":"STANDARD","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"1","Description":"Brief description","Granular Statuses":"Pending Pickup","RTS":"No","Service Levels":"STANDARD","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure Logic is correct as data below:
      | condition     | conflicting shipment destination |
      | numberOfArms  | 2                                |
      | numberOfRules | 2                                |
    And Operator make sure can not click save button in check logic

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op