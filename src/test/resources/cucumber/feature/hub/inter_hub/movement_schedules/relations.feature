@MiddleMile @Hub @InterHub @MovementSchedules @Relations
Feature: Relations

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath
  Scenario: Search Station in Pending Relations Tab
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	When Operator select "Relations" tab on Movement Management page
	Then Operator verify "Pending" tab is selected on 'Relations' tab
	Then Operator the number of Relations appear in beside "Pending" tab
	When Operator gets relation data from Movement Management page
	And Operator search for relation on Movement Management page:
	  | station | {KEY_FOUND_RELATION_STATION} |
	Then Operator verify relations table on Movement Management page using data below:
	  | station      | {KEY_FOUND_RELATION_STATION}       |
	  | crossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	When Operator clears filters on Relations tab on Movement Management page
	And Operator search for relation on Movement Management page:
	  | chrossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	Then Operator verify relations table on Movement Management page using data below:
	  | station      | {KEY_FOUND_RELATION_STATION}       |
	  | crossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	When Operator clears filters on Relations tab on Movement Management page
	When Operator sort "Station" column Ascending on Relations tab on Movement Management page
	Then Operator verifies "Station" column is sorted Ascending on Relations tab on Movement Management page
	When Operator sort "Station" column Descending on Relations tab on Movement Management page
	Then Operator verifies "Station" column is sorted Descending on Relations tab on Movement Management page
	When Operator sort "Crossdock Hub" column Ascending on Relations tab on Movement Management page
	Then Operator verifies "Crossdock Hub" column is sorted Ascending on Relations tab on Movement Management page
	When Operator sort "Crossdock Hub" column Descending on Relations tab on Movement Management page
	Then Operator verifies "Crossdock Hub" column is sorted Descending on Relations tab on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Update Station Relation (uid:b54b31c7-770c-4db3-b4cc-19e1fb9335c1)
	Given Operator go to menu Utilities -> QRCode Printing
	When API Operator creates new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | STATION   |
	  | region       | JKB       |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	When API Operator creates new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | CROSSDOCK |
	  | region       | JKB       |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	And API Operator reloads hubs cache
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	When Operator select "Relations" tab on Movement Management page
	Then Operator verify "Pending" tab is selected on 'Relations' tab
	When Operator get count of Relations of "Pending" tab
	When Operator get count of Relations of "Complete" tab
	And Operator edit relation on Movement Management page:
	  | station         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | newCrossdockHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	Then Operator verifies that success react notification displayed:
	  | top    | Relation created                                                                               |
	  | bottom | Relation from {KEY_LIST_OF_CREATED_HUBS[1].name} to {KEY_LIST_OF_CREATED_HUBS[2].name} created |
	When Operator select "Complete" tab on Movement Management page
	And Operator search for relation on Movement Management page:
	  | station       | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | chrossdockHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	Then Operator verify relations table on Movement Management page using data below:
	  | station      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	And Operator verifies count of Relations of "Pending" tab decreased
	And Operator verifies count of Relations of "Complete" tab increased

  Scenario: Search Station in Complete Relations Tab
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	When Operator select "Relations" tab on Movement Management page
	Then Operator verify "Pending" tab is selected on 'Relations' tab
	When Operator select "Complete" tab on Movement Management page
	Then Operator the number of Relations appear in beside "Complete" tab
	When Operator gets relation data from Movement Management page
	And Operator search for relation on Movement Management page:
	  | station | {KEY_FOUND_RELATION_STATION} |
	Then Operator verify relations table on Movement Management page using data below:
	  | station      | {KEY_FOUND_RELATION_STATION}       |
	  | crossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	When Operator clears filters on Relations tab on Movement Management page
	And Operator search for relation on Movement Management page:
	  | chrossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	Then Operator verify relations table on Movement Management page using data below:
	  | station      | {KEY_FOUND_RELATION_STATION}       |
	  | crossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	When Operator clears filters on Relations tab on Movement Management page
	When Operator sort "Station" column Ascending on Relations tab on Movement Management page
	Then Operator verifies "Station" column is sorted Ascending on Relations tab on Movement Management page
	When Operator sort "Station" column Descending on Relations tab on Movement Management page
	Then Operator verifies "Station" column is sorted Descending on Relations tab on Movement Management page
	When Operator sort "Crossdock Hub" column Ascending on Relations tab on Movement Management page
	Then Operator verifies "Crossdock Hub" column is sorted Ascending on Relations tab on Movement Management page
	When Operator sort "Crossdock Hub" column Descending on Relations tab on Movement Management page
	Then Operator verifies "Crossdock Hub" column is sorted Descending on Relations tab on Movement Management page

  Scenario: Search Station in All Relations Tab
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	When Operator select "Relations" tab on Movement Management page
	Then Operator verify "Pending" tab is selected on 'Relations' tab
	When Operator select "All" tab on Movement Management page
	Then Operator the number of Relations appear in beside "All" tab
	When Operator gets relation data from Movement Management page
	And Operator search for relation on Movement Management page:
	  | station | {KEY_FOUND_RELATION_STATION} |
	Then Operator verify relations table on Movement Management page using data below:
	  | station      | {KEY_FOUND_RELATION_STATION}       |
	  | crossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	When Operator clears filters on Relations tab on Movement Management page
	And Operator search for relation on Movement Management page:
	  | chrossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	Then Operator verify relations table on Movement Management page using data below:
	  | station      | {KEY_FOUND_RELATION_STATION}       |
	  | crossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	When Operator clears filters on Relations tab on Movement Management page
	When Operator sort "Station" column Ascending on Relations tab on Movement Management page
	Then Operator verifies "Station" column is sorted Ascending on Relations tab on Movement Management page
	When Operator sort "Station" column Descending on Relations tab on Movement Management page
	Then Operator verifies "Station" column is sorted Descending on Relations tab on Movement Management page
	When Operator sort "Crossdock Hub" column Ascending on Relations tab on Movement Management page
	Then Operator verifies "Crossdock Hub" column is sorted Ascending on Relations tab on Movement Management page
	When Operator sort "Crossdock Hub" column Descending on Relations tab on Movement Management page
	Then Operator verifies "Crossdock Hub" column is sorted Descending on Relations tab on Movement Management page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Edit Relation - Add Crossdock Hub for Existing Relation
	Given Operator go to menu Utilities -> QRCode Printing
	When API Operator creates new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | STATION   |
	  | region       | JKB       |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	When API Operator creates new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | CROSSDOCK |
	  | region       | JKB       |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	When API Operator creates new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | CROSSDOCK |
	  | region       | JKB       |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	And API Operator reloads hubs cache
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	When Operator select "Relations" tab on Movement Management page
	Then Operator verify "Pending" tab is selected on 'Relations' tab
	And Operator edit relation on Movement Management page:
	  | station         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | newCrossdockHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	When Operator select "Complete" tab on Movement Management page
	When Operator get count of Relations of "Complete" tab
	And Operator edit relation on Movement Management page:
	  | station         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | crossdockHub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	  | newCrossdockHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
	Then Operator verifies that success react notification displayed:
	  | top    | Relation updated                                                                               |
	  | bottom | Relation from {KEY_LIST_OF_CREATED_HUBS[1].name} to {KEY_LIST_OF_CREATED_HUBS[3].name} updated |
	And Operator search for relation on Movement Management page:
	  | station       | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | chrossdockHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
	Then Operator verify relations table on Movement Management page using data below:
	  | station      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
	And Operator verifies count of Relations of "Complete" tab was not changed

  Scenario: Edit Relation - Remove Crossdock Hub for Existing Relation
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	When Operator select "Relations" tab on Movement Management page
	When Operator select "Complete" tab on Movement Management page
	When Operator gets relation data from Movement Management page
	And Operator edit relation on Movement Management page:
	  | station         | {KEY_FOUND_RELATION_STATION}       |
	  | crossdockHub    | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	  | newCrossdockHub |                                    |
	Then Operator verifies "Please enter Crossdock Hub" error is displayed in Edit Station Relations dialog

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: ECancel Edit Relation
	Given Operator go to menu Utilities -> QRCode Printing
	When API Operator creates new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | CROSSDOCK |
	  | region       | JKB       |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	And API Operator reloads hubs cache
	When Operator go to menu Inter-Hub -> Movement Schedules
	And Movement Management page is loaded
	When Operator select "Relations" tab on Movement Management page
	When Operator select "Complete" tab on Movement Management page
	When Operator gets relation data from Movement Management page
	And Operator fill edit relation on Movement Management page:
	  | station         | {KEY_FOUND_RELATION_STATION}       |
	  | crossdockHub    | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	  | newCrossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	And Operator click Cancel in Edit Relation dialog
	And Operator fill edit relation on Movement Management page:
	  | station         | {KEY_FOUND_RELATION_STATION}       |
	  | crossdockHub    | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	  | newCrossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	And Operator click X in Edit Relation dialog
	And Operator search for relation on Movement Management page:
	  | station       | {KEY_FOUND_RELATION_STATION}       |
	  | chrossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |
	Then Operator verify relations table on Movement Management page using data below:
	  | station      | {KEY_FOUND_RELATION_STATION}       |
	  | crossdockHub | {KEY_FOUND_RELATION_CROSSDOCK_HUB} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op