@Sort @SortBeltManagerV2Part1
Feature: Sort Belt Manager V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Activate Logic On Sort Belt Manager V2
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                         |
      | description   | GENERATED                                         |
      | armFilters    | AV Statuses,Granular Statuses,Service Levels,Tags |
      | unassignedArm | 15                                                |
    And Operator fills logic rules
      | rules | [{"Arm":"1,10,11","Description":"Brief description","AV Statuses":"Verified","Granular Statuses":"Pending Pickup,En-route to Sorting Hub,Arrived at Sorting Hub","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","AV Statuses":"Unverified","Granular Statuses":"Arrived at Sorting Hub,On Vehicle for Delivery","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator deletes extra rules in create logic
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure logic checking is correct
    And Operator clicks save button in check logic
    And DB Operator make sure created logic is correct
    When Operator activates the selected logic
    Then DB Operator makes sure logic is activated
    And Operator search "default" logic in Sort Belt Manager page
    And Operator activates the selected logic
    And DB Operator hard deletes created logic

  Scenario: Activate Logic On Sort Belt Manager V2 - Logic Is Active
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                         |
      | description   | GENERATED                                         |
      | armFilters    | AV Statuses,Granular Statuses,Service Levels,Tags |
      | unassignedArm | 15                                                |
    And Operator fills logic rules
      | rules | [{"Arm":"1,10,11","Description":"Brief description","AV Statuses":"Verified","Granular Statuses":"Pending Pickup,En-route to Sorting Hub,Arrived at Sorting Hub","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","AV Statuses":"Unverified","Granular Statuses":"Arrived at Sorting Hub,On Vehicle for Delivery","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator deletes extra rules in create logic
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure logic checking is correct
    And Operator clicks save button in check logic
    And DB Operator make sure created logic is correct
    When Operator activates the selected logic
    Then DB Operator makes sure logic is activated
    When Operator search "created" logic in Sort Belt Manager page
    Then Operator make sure can not reactivate logic
    And Operator clicks close button in logic detail page
    And Operator search "default" logic in Sort Belt Manager page
    And Operator activates the selected logic
    And DB Operator hard deletes created logic

  Scenario: SBMV2UI Create/Edit Logic Section - Create New
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                         |
      | description   | GENERATED                                         |
      | armFilters    | AV Statuses,Granular Statuses,Service Levels,Tags |
      | unassignedArm | 15                                                |
    And Operator fills logic rules
      | rules | [{"Arm":"1,10,11","Description":"Brief description","AV Statuses":"Verified","Granular Statuses":"Pending Pickup,En-route to Sorting Hub,Arrived at Sorting Hub","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","AV Statuses":"Unverified","Granular Statuses":"Arrived at Sorting Hub,On Vehicle for Delivery","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator deletes extra rules in create logic
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure logic checking is correct
    And Operator clicks save button in check logic
    And DB Operator make sure created logic is correct
    And DB Operator hard deletes created logic

  Scenario: SBMV2UI Create/Edit Logic Section - Create A Copy
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                         |
      | description   | GENERATED                                         |
      | armFilters    | AV Statuses,Granular Statuses,Service Levels,Tags |
      | unassignedArm | 15                                                |
    And Operator fills logic rules
      | rules | [{"Arm":"1,10,11","Description":"Brief description","AV Statuses":"Verified","Granular Statuses":"Pending Pickup,En-route to Sorting Hub,Arrived at Sorting Hub","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","AV Statuses":"Unverified","Granular Statuses":"Arrived at Sorting Hub,On Vehicle for Delivery","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator deletes extra rules in create logic
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure logic checking is correct
    And Operator clicks save button in check logic
    And Operator clicks close button in logic detail page
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create a copy"
    Then Operator selects a logic to copy
    Then Operator make sure redirected to "Create" logic page
    And Operator make sure logic form is pre-populated
    And Operator edits logic basic information
      | name          | GENERATED                                         |
      | description   | GENERATED                                         |
      | armFilters    | AV Statuses,Granular Statuses,Service Levels,Tags |
      | unassignedArm | 15                                                |
    And Operator edits logic rules
      | rules | [{"Arm":"1,10,11","Description":"Brief description","AV Statuses":"Unverified","Granular Statuses":"Pending Pickup,En-route to Sorting Hub,Arrived at Sorting Hub","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","AV Statuses":"Verified","Granular Statuses":"Arrived at Sorting Hub,On Vehicle for Delivery","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator deletes extra rules in create logic
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure logic checking is correct
    And Operator clicks save button in check logic
    And Operator clicks close button in logic detail page
    Then Operator make sure redirected to Sort Belt Manager main page
    And DB Operator make sure created logic is correct
    And DB Operator hard deletes created logic

  Scenario: SBMV2UI Create/Edit Logic Section - Edit Logic
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator fills logic basic information
      | name          | GENERATED                                         |
      | description   | GENERATED                                         |
      | armFilters    | AV Statuses,Granular Statuses,Service Levels,Tags |
      | unassignedArm | 15                                                |
    And Operator fills logic rules
      | rules | [{"Arm":"1,10,11","Description":"Brief description","AV Statuses":"Verified","Granular Statuses":"Pending Pickup,En-route to Sorting Hub,Arrived at Sorting Hub","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","AV Statuses":"Unverified","Granular Statuses":"Arrived at Sorting Hub,On Vehicle for Delivery","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator deletes extra rules in create logic
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure logic checking is correct
    And Operator clicks save button in check logic
    And Operator clicks close button in logic detail page
    Then Operator make sure redirected to Sort Belt Manager main page
    When Operator search "created" logic in Sort Belt Manager page
    And Operator edits the selected logic
    Then Operator make sure redirected to "Edit" logic page
    And Operator make sure logic form is pre-populated
    And Operator edits logic basic information
      | name          | GENERATED                                         |
      | description   | GENERATED                                         |
      | armFilters    | AV Statuses,Granular Statuses,Service Levels,Tags |
      | unassignedArm | 15                                                |
    And Operator edits logic rules
      | rules | [{"Arm":"1,10,11","Description":"Brief description","AV Statuses":"Unverified","Granular Statuses":"Pending Pickup,En-route to Sorting Hub,Arrived at Sorting Hub","Service Levels":"STANDARD,SAMEDAY","Tags":"QA-TAG,BRUH-TAG","Shipment Destination":"JKB","Shipment Type":"Air haul"},{"Arm":"2","Description":"Brief description","AV Statuses":"Verified","Granular Statuses":"Arrived at Sorting Hub,On Vehicle for Delivery","Service Levels":"EXPRESS,SAMEDAY","Tags":"PRIOR,PRIORITY","Shipment Destination":"RECOVERY1","Shipment Type":"Land haul"}] |
    And Operator deletes extra rules in create logic
    And Operator clicks next button in create logic
    Then Operator make sure redirected to check logic page
    And Operator make sure logic checking is correct
    And Operator clicks save button in check logic
    And Operator clicks close button in logic detail page
    Then Operator make sure redirected to Sort Belt Manager main page
    And DB Operator make sure created logic is correct
    And DB Operator hard deletes created logic

  Scenario: SBMV2UI Create/Edit Logic Section - Filter Exceeds 4 Items
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
    And Operator make sure can not select arm filters anymore
    When Operator clicks cancel button in create logic
    And Operator confirms on cancel creating logic
    Then Operator make sure redirected to Sort Belt Manager main page

  Scenario: SBMV2UI Create/Edit Logic Section - Empty Mandatory Fields
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Sort -> Sort Belt Manager
    And Sort Belt Manager page is loaded
    When Operator selects hub and device of Sort Belt Manager
    Then Operator make sure redirected to Sort Belt Manager main page
    And Operator clicks Create Logic -> "Create new"
    Then Operator make sure redirected to "Create" logic page
    And Operator clicks next button in create logic
    And Operator make sure can not create logic

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op