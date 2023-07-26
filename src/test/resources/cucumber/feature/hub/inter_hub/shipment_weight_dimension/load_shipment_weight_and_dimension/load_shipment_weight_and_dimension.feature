# https://studio.cucumber.io/projects/210778/test-plan/folders/2075581
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @Load
Feature: Load Shipment Weight and Dimension

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018984
  @HappyPath @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by End Hub field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given API Operator link mawb for following shipment id
	  | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
	  | mawb                 | RANDOM                                |
	  | destinationAirportId | {airport-id-1}                        |
	  | originAirportId      | {airport-id-2}                        |
	  | vendorId             | {vendor-id}                           |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	And Operator verify Shipment Weight Dimension Filter UI
	When Operator fill in Load Shipment Weight filter
	  | presetName  | {shipment-weight-filter-name} |
	  | createdTime | {KEY_SHIPMENT_CREATION_DATE}  |
	And Operator click Load Selection button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	And Operator verify can filter Shipment Weight Dimension Table
	When Operator filter Shipment Weight Dimension Table by "end_hub" column with first shipment value
	  | expectedNumOfRows | 1 |
	And Operator select all data on Shipment Weight Dimension Table
	Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
	When Operator clear filter on Shipment Weight Dimension Table
	Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018985
  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Shipment Creation Date Time field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given API Operator link mawb for following shipment id
	  | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
	  | mawb                 | RANDOM                                |
	  | destinationAirportId | {airport-id-1}                        |
	  | originAirportId      | {airport-id-2}                        |
	  | vendorId             | {vendor-id}                           |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	And Operator verify Shipment Weight Dimension Filter UI
	When Operator fill in Load Shipment Weight filter
	  | presetName  | {shipment-weight-filter-name} |
	  | createdTime | {KEY_SHIPMENT_CREATION_DATE}  |
	And Operator click Load Selection button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	And Operator verify can filter Shipment Weight Dimension Table
	When Operator filter Shipment Weight Dimension Table by "creation_date" column with first shipment value
	  | expectedNumOfRows | 1 |
	And Operator select all data on Shipment Weight Dimension Table
	Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
	When Operator clear filter on Shipment Weight Dimension Table
	Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018992
  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Comments field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given API Operator link mawb for following shipment id
	  | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
	  | mawb                 | RANDOM                                |
	  | destinationAirportId | {airport-id-1}                        |
	  | originAirportId      | {airport-id-2}                        |
	  | vendorId             | {vendor-id}                           |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	And Operator verify Shipment Weight Dimension Filter UI
	When Operator fill in Load Shipment Weight filter
	  | presetName  | {shipment-weight-filter-name} |
	  | createdTime | {KEY_SHIPMENT_CREATION_DATE}  |
	And Operator click Load Selection button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	And Operator verify can filter Shipment Weight Dimension Table
	When Operator filter Shipment Weight Dimension Table by "comments" column with first shipment value
	  | expectedNumOfRows | 1 |
	And Operator select all data on Shipment Weight Dimension Table
	Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
	When Operator clear filter on Shipment Weight Dimension Table
	Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018994
  @HappyPath @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Start Hub field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given API Operator link mawb for following shipment id
	  | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
	  | mawb                 | RANDOM                                |
	  | destinationAirportId | {airport-id-1}                        |
	  | originAirportId      | {airport-id-2}                        |
	  | vendorId             | {vendor-id}                           |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	And Operator verify Shipment Weight Dimension Filter UI
	When Operator fill in Load Shipment Weight filter
	  | presetName  | {shipment-weight-filter-name} |
	  | createdTime | {KEY_SHIPMENT_CREATION_DATE}  |
	And Operator click Load Selection button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	And Operator verify can filter Shipment Weight Dimension Table
	When Operator filter Shipment Weight Dimension Table by "start_hub" column with first shipment value
	  | expectedNumOfRows | 1 |
	And Operator select all data on Shipment Weight Dimension Table
	Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
	When Operator clear filter on Shipment Weight Dimension Table
	Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018995
  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Shipment Type field
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given API Operator link mawb for following shipment id
	  | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
	  | mawb                 | RANDOM                                |
	  | destinationAirportId | {airport-id-1}                        |
	  | originAirportId      | {airport-id-2}                        |
	  | vendorId             | {vendor-id}                           |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	And Operator verify Shipment Weight Dimension Filter UI
	When Operator fill in Load Shipment Weight filter
	  | presetName  | {shipment-weight-filter-name} |
	  | createdTime | {KEY_SHIPMENT_CREATION_DATE}  |
	And Operator click Load Selection button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	And Operator verify can filter Shipment Weight Dimension Table
	When Operator filter Shipment Weight Dimension Table by "shipment_type" column with first shipment value
	  | expectedNumOfRows | 1 |
	And Operator select all data on Shipment Weight Dimension Table
	Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
	When Operator clear filter on Shipment Weight Dimension Table
	Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

  @KillBrowser
  Scenario: Kill Browser
	Given no-op
