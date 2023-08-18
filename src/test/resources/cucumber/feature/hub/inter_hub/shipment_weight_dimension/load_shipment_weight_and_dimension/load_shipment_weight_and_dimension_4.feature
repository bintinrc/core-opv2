@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @Load4
Feature: Load Shipment Weight and Dimension 4

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteCreatedShipments
  Scenario: No Data Shown when Search Shipment by Shipment ID field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator search the "SHIPMENT ID" column with inputted data "INVALID" on Shipment Weight Dimension Table
	Then Operator verify No Data empty description in Shipment Weight Dimension Table is shown

  @HappyPath @DeleteCreatedShipments
  Scenario: No Data Shown when Search Shipment by Shipment Status field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator search the "SHIPMENT STATUS" column with inputted data "INVALID" on Shipment Weight Dimension Table
	Then Operator verify No Data empty description in Shipment Weight Dimension Table is shown

  @HappyPath @DeleteCreatedShipments
  Scenario: No Data Shown when Search Shipment by End Hub field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator search the "END HUB" column with inputted data "INVALID" on Shipment Weight Dimension Table
	Then Operator verify No Data empty description in Shipment Weight Dimension Table is shown

  @DeleteCreatedShipments
  Scenario: No Data Shown when Search Shipment by Shipment Creation Date Time field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator search the "SHIPMENT CREATION DATE TIME" column with inputted data "INVALID" on Shipment Weight Dimension Table
	Then Operator verify No Data empty description in Shipment Weight Dimension Table is shown

  @DeleteCreatedShipments
  Scenario: No Data Shown when Search Shipment by Comments field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator search the "COMMENTS" column with inputted data "INVALID" on Shipment Weight Dimension Table
	Then Operator verify No Data empty description in Shipment Weight Dimension Table is shown

  @HappyPath @DeleteCreatedShipments
  Scenario: No Data Shown when Search Shipment by Start Hub field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator search the "START HUB" column with inputted data "INVALID" on Shipment Weight Dimension Table
	Then Operator verify No Data empty description in Shipment Weight Dimension Table is shown

  @DeleteCreatedShipments
  Scenario: No Data Shown when Search Shipment by Shipment Type field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator search the "SHIPMENT TYPE" column with inputted data "INVALID" on Shipment Weight Dimension Table
	Then Operator verify No Data empty description in Shipment Weight Dimension Table is shown

  @DeleteCreatedShipments
  Scenario: No Data Shown when Search Shipment by Vendor field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator search the "VENDOR" column with inputted data "INVALID" on Shipment Weight Dimension Table
	Then Operator verify No Data empty description in Shipment Weight Dimension Table is shown

  @DeleteCreatedShipments
  Scenario: No Data Shown when Search Shipment by Origin Port field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator search the "ORIGIN PORT" column with inputted data "INVALID" on Shipment Weight Dimension Table
	Then Operator verify No Data empty description in Shipment Weight Dimension Table is shown

  @DeleteCreatedShipments
  Scenario: No Data Shown when Search Shipment by Destination Port field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator search the "DESTINATION PORT" column with inputted data "INVALID" on Shipment Weight Dimension Table
	Then Operator verify No Data empty description in Shipment Weight Dimension Table is shown

  @KillBrowser
  Scenario: Kill Browser
	Given no-op