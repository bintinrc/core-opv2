@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateSWB1
Feature: Update SWB 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB without Download Sum Up Report - Create SWB Number with New SWB Number, Vendor, Origin Seaport, and Dest Seaport
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
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

  @HappyPath @DeleteCreatedShipments
  Scenario: Update SWB without Download Sum Up Report - Create SWB Number with existing SWB Number and new Vendor, Origin Seaport, and Dest Seaport
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
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
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 2 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
	When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
	  | swb                | {KEY_MM_SHIPMENT_SWB}       |
	  | seahaulVendor      | {local-seahaul-vendor-name} |
	  | originSeahaul      | {local-seaport-1-code}      |
	  | destinationSeahaul | {local-seaport-2-code}      |
	Then Operator click update button on shipment weight update mawb page
	And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @HappyPath @DeleteCreatedShipments
  Scenario: Update SWB without Download Sum Up Report - Create SWB Number with existing SWB Number and existing Vendor, Origin Seaport, and Dest Seaport
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
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
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 2 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
	When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
	  | swb                | {KEY_MM_SHIPMENT_SWB}       |
	  | seahaulVendor      | {local-seahaul-vendor-name} |
	  | originSeahaul      | {local-seaport-1-code}      |
	  | destinationSeahaul | {local-seaport-2-code}      |
	Then Operator click update button on shipment weight update mawb page
	And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments
  Scenario: Update SWB without Download Sum Up Report with Invalid Format
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
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
	  | swb                | INVALID                     |
	  | seahaulVendor      | {local-seahaul-vendor-name} |
	  | originSeahaul      | {local-seaport-1-code}      |
	  | destinationSeahaul | {local-seaport-2-code}      |
	Then Operator verifies Update Billing Number "SWB" page UI has error
	  | seawayBillMessage | Invalid SWB Format |

  @DeleteCreatedShipments
  Scenario: Update SWB without Download Sum Up Report with Empty SWB Number
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
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
	  | swb                | EMPTY                       |
	  | seahaulVendor      | {local-seahaul-vendor-name} |
	  | originSeahaul      | {local-seaport-1-code}      |
	  | destinationSeahaul | {local-seaport-2-code}      |
	Then Operator verifies Update Billing Number "SWB" page UI has error
	  | seawayBillMessage |  |

  @DeleteCreatedShipments
  Scenario: Update SWB without Download Sum Up Report with Empty Seahaul Vendor
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
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
	And Operator clicks clear "Sea Haul Vendor" button on "Update Seaway Bill" Shipment Weight Dimension page
	Then Operator verifies Update Billing Number "SWB" page UI has error
	  | emptySeahaulVendorErrorMessage | Please enter Sea Haul Vendor |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op