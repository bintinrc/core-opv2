@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @SearchByBillingNumber1
Feature: Search by Billing Number 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteCreatedShipments
  Scenario: Search Shipment by Valid MAWB
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 2            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 2 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
	When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
	  | mawb        | RANDOM                 |
	  | vendor      | {local-vendor-name}    |
	  | origin      | {local-airport-1-code} |
	  | destination | {local-airport-2-code} |
	Then Operator click update button on shipment weight update mawb page
	And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "MAWB" billing number with value "{KEY_SHIPMENT_UPDATED_AWB}" on Shipment Weight Dimension page
	When Operator clicks "Search Shipments" button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown

  @HappyPath @DeleteCreatedShipments
  Scenario: Search Shipment by Valid SWB
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 2            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 2 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
	When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
	  | swb                | RANDOM                      |
	  | seahaulVendor      | {local-seahaul-vendor-name} |
	  | originSeahaul      | {local-seaport-1-code}      |
	  | destinationSeahaul | {local-seaport-2-code}      |
	Then Operator click update button on shipment weight update mawb page
	And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "SWB" billing number with value "{KEY_MM_SHIPMENT_SWB}" on Shipment Weight Dimension page
	When Operator clicks "Search Shipments" button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown

  @DeleteCreatedShipments
  Scenario: Cancel Search Shipment by Valid MAWB
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 2            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 2 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
	When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
	  | mawb        | RANDOM                 |
	  | vendor      | {local-vendor-name}    |
	  | origin      | {local-airport-1-code} |
	  | destination | {local-airport-2-code} |
	Then Operator click update button on shipment weight update mawb page
	And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "MAWB" billing number with value "{KEY_SHIPMENT_UPDATED_AWB}" on Shipment Weight Dimension page
	When Operator clicks "Close Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies the popup is closed on Shipment Weight Dimension page

  @DeleteCreatedShipments
  Scenario: Cancel Search Shipment by Valid SWB
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 2            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 2 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
	When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
	  | swb                | RANDOM                      |
	  | seahaulVendor      | {local-seahaul-vendor-name} |
	  | originSeahaul      | {local-seaport-1-code}      |
	  | destinationSeahaul | {local-seaport-2-code}      |
	Then Operator click update button on shipment weight update mawb page
	And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "SWB" billing number with value "{KEY_MM_SHIPMENT_SWB}" on Shipment Weight Dimension page
	When Operator clicks "Close Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies the popup is closed on Shipment Weight Dimension page

  @DeleteCreatedShipments
  Scenario: Search Shipment by Valid MAWB and Back to Main
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 2            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 2 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
	When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
	  | mawb        | RANDOM                 |
	  | vendor      | {local-vendor-name}    |
	  | origin      | {local-airport-1-code} |
	  | destination | {local-airport-2-code} |
	Then Operator click update button on shipment weight update mawb page
	And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "MAWB" billing number with value "{KEY_SHIPMENT_UPDATED_AWB}" on Shipment Weight Dimension page
	When Operator clicks "Search Shipments" button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator clicks "Back to Main" button on Shipment Weight Dimension page
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page

  @DeleteCreatedShipments
  Scenario: Search Shipment by Valid SWB and Back to Main
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 2            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 2 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
	When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
	  | swb                | RANDOM                      |
	  | seahaulVendor      | {local-seahaul-vendor-name} |
	  | originSeahaul      | {local-seaport-1-code}      |
	  | destinationSeahaul | {local-seaport-2-code}      |
	Then Operator click update button on shipment weight update mawb page
	And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "SWB" billing number with value "{KEY_MM_SHIPMENT_SWB}" on Shipment Weight Dimension page
	When Operator clicks "Search Shipments" button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator clicks "Back to Main" button on Shipment Weight Dimension page
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op