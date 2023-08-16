#https://studio.cucumber.io/projects/210778/test-plan/folders/2081862
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateWeightAndDimension
Feature: Update Weight and Dimension

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#    https://studio.cucumber.io/projects/210778/test-plan/folders/2081862/scenarios/6846723
  @HappyPath @DeleteShipment
  Scenario: Update Shipment Weight and Dimension
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
	And Operator click edit button on Shipment Weight Dimension table
	Then Operator verify Shipment Weight Dimension Add UI
	  | state  | has dimension |
	  | weight | 16.0          |
	  | length | 8.0           |
	  | width  | 1.9           |
	  | height | 9.7           |
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 10 |
	  | length | 17 |
	  | width  | 15 |
	  | height | 5  |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 10 |
	  | length | 17 |
	  | width  | 15 |
	  | height | 5  |

#    https://studio.cucumber.io/projects/210778/test-plan/folders/2081862/scenarios/6846728
  @HappyPath @DeleteShipment
  Scenario: Update Shipment Weight
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
	And Operator click edit button on Shipment Weight Dimension table
	Then Operator verify Shipment Weight Dimension Add UI
	  | state  | has dimension |
	  | weight | 16.0          |
	  | length | 8.0           |
	  | width  | 1.9           |
	  | height | 9.7           |
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 10 |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 10.0 |
	  | length | 8.0  |
	  | width  | 1.9  |
	  | height | 9.7  |

#   https://studio.cucumber.io/projects/210778/test-plan/folders/2081862/scenarios/6846729
  @DeleteShipment
  Scenario: Update Shipment Dimension
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
	And Operator click edit button on Shipment Weight Dimension table
	Then Operator verify Shipment Weight Dimension Add UI
	  | state  | has dimension |
	  | weight | 16.0          |
	  | length | 8.0           |
	  | width  | 1.9           |
	  | height | 9.7           |
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | length | 17 |
	  | width  | 15 |
	  | height | 5  |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 16.0 |
	  | length | 17   |
	  | width  | 15   |
	  | height | 5    |

#    https://studio.cucumber.io/projects/210778/test-plan/folders/2081862/scenarios/6846730
  @HappyPath @DeleteShipment
  Scenario: Remove Shipment Dimension
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
	And Operator click edit button on Shipment Weight Dimension table
	Then Operator verify Shipment Weight Dimension Add UI
	  | state  | has dimension |
	  | weight | 16.0          |
	  | length | 8.0           |
	  | width  | 1.9           |
	  | height | 9.7           |
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | length | null |
	  | width  | null |
	  | height | null |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 16.0 |
	  | length | 0.0  |
	  | width  | 0.0  |
	  | height | 0.0  |

#   https://studio.cucumber.io/projects/210778/test-plan/folders/2081862/scenarios/6846731
  @DeleteShipment
  Scenario: Remove Shipment Weight
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
	And Operator click edit button on Shipment Weight Dimension table
	Then Operator verify Shipment Weight Dimension Add UI
	  | state  | has dimension |
	  | weight | 16.0          |
	  | length | 8.0           |
	  | width  | 1.9           |
	  | height | 9.7           |
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | null |
	Then Operator verify Shipment Weight Dimension Add Dimension UI
	  | state        | invalid                        |
	  | field        | weight                         |
	  | errorMessage | Please enter Weight (required) |
	And Operator verify Shipment Weight Dimension Submit button is disabled

#   https://studio.cucumber.io/projects/210778/test-plan/folders/2081862/scenarios/6855027
  @DeleteShipment
  Scenario: Update Shipment Weight to 0
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
	And Operator click edit button on Shipment Weight Dimension table
	Then Operator verify Shipment Weight Dimension Add UI
	  | state  | has dimension |
	  | weight | 16.0          |
	  | length | 8.0           |
	  | width  | 1.9           |
	  | height | 9.7           |
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 0 |
	Then Operator verify Shipment Weight Dimension Add Dimension UI
	  | state        | invalid                |
	  | field        | weight                 |
	  | errorMessage | Must be greater than 0 |
	And Operator verify Shipment Weight Dimension Submit button is disabled

  @KillBrowser
  Scenario: Kill Browser
	Given no-op
