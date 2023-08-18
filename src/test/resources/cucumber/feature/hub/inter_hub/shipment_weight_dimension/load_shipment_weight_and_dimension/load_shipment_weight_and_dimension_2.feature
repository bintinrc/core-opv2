# https://studio.cucumber.io/projects/210778/test-plan/folders/2075581
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @Load2
Feature: Load Shipment Weight and Dimension 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6820637
  @HappyPath @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario:Load Shipment Weight and Dimension by Enter New Filters
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	And Operator verify Shipment Weight Dimension Filter UI
	When Operator click Enter New Filter button on Shipment Weight Dimension Filter UI
	Then Operator verify Enter New Filter card on Shipment Weight Dimension Filter UI
	Then Operator fill Shipment Weight Dimension Filter UI with data
	  | shipmentType   | Air Haul       |
	  | startHub       | {hub-name}     |
	  | endHub         | {hub-name-2}   |
	  | shipmentStatus | Pending,Closed |
	  | saveAsPreset   | true           |
	  | presetName     | RANDOM         |
	When Operator fill in Load Shipment Weight filter
	  | createdTime | future |
	And Operator click Load Selection button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension search error popup shown
	And Operator close Shipment Weight Dimension search error popup
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	And Operator verify can filter Shipment Weight Dimension Table

# https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6820662
  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Load Shipment Weight and Dimension by Enter New Filters then Clear and Close Filter
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	And Operator verify Shipment Weight Dimension Filter UI
	When Operator click Enter New Filter button on Shipment Weight Dimension Filter UI
	Then Operator verify Enter New Filter card on Shipment Weight Dimension Filter UI
	Then Operator fill Shipment Weight Dimension Filter UI with data
	  | shipmentType   | Air Haul       |
	  | startHub       | {hub-name}     |
	  | endHub         | {hub-name-2}   |
	  | shipmentStatus | Pending,Closed |
	  | saveAsPreset   | true           |
	  | presetName     | RANDOM         |
	When Operator fill in Load Shipment Weight filter
	  | createdTime | {KEY_SHIPMENT_CREATION_DATE} |
	Then Operator click Clear and Close button on Shipment Weight Dimension
	When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | search_valid |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	And Operator verify can filter Shipment Weight Dimension Table

  @KillBrowser
  Scenario: Kill Browser
	Given no-op
