@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateBothMawbSwb1
Feature: Update Both MAWB & SWB 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedSWBs
  Scenario: Update Both MAWB & SWB without Download Sum Up Report - Create New MAWB & New SWB Number with new Vendor, Origin port, and Dest port
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
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
	When Operator click Update Billing Number "BOTH" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "BOTH" page UI
	When Operator update billing number "BOTH" information on Shipment Weight Dimension page with following data:
	  | mawb               | RANDOM                      |
	  | airhaulVendor      | {local-vendor-name}         |
	  | originAirhaul      | {local-airport-1-code}      |
	  | destinationAirhaul | {local-airport-2-code}      |
	  | swb                | RANDOM                      |
	  | seahaulVendor      | {local-seahaul-vendor-name} |
	  | originSeahaul      | {local-seaport-1-code}      |
	  | destinationSeahaul | {local-seaport-2-code}      |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "BOTH" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}, {KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedSWBs
  Scenario: Update Both MAWB & SWB without Download Sum Up Report - Create New MAWB & Existing SWB Number with new Vendor, Origin port, and Dest port
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
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
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "BOTH" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "BOTH" page UI
	When Operator update billing number "BOTH" information on Shipment Weight Dimension page with following data:
	  | mawb               | RANDOM                        |
	  | airhaulVendor      | {local-vendor-name}           |
	  | originAirhaul      | {local-airport-1-code}        |
	  | destinationAirhaul | {local-airport-2-code}        |
	  | swb                | {KEY_MM_SHIPMENT_SWB}         |
	  | seahaulVendor      | {local-seahaul-vendor-2-name} |
	  | originSeahaul      | {local-seaport-2-code}        |
	  | destinationSeahaul | {local-seaport-1-code}        |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "BOTH" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}, {KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedSWBs
  Scenario: Update Both MAWB & SWB without Download Sum Up Report - Create Existing MAWB & New SWB Number with new Vendor, Origin port, and Dest port
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
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
	When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
	When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
	  | mawb        | {RANDOM}               |
	  | vendor      | {other-vendor-name}    |
	  | origin      | {other-airport-name-1} |
	  | destination | {other-airport-name-2} |
	Then Operator click update button on shipment weight update mawb page
	And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "BOTH" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "BOTH" page UI
	When Operator update billing number "BOTH" information on Shipment Weight Dimension page with following data:
	  | mawb               | {KEY_SHIPMENT_UPDATED_AWB}    |
	  | airhaulVendor      | {local-vendor-name}           |
	  | originAirhaul      | {local-airport-1-code}        |
	  | destinationAirhaul | {local-airport-2-code}        |
	  | swb                | RANDOM                        |
	  | seahaulVendor      | {local-seahaul-vendor-2-name} |
	  | originSeahaul      | {local-seaport-2-code}        |
	  | destinationSeahaul | {local-seaport-1-code}        |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "BOTH" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}, {KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedSWBs
  Scenario: Update Both MAWB & SWB without Download Sum Up Report - Create Existing MAWB & Existing SWB Number with new Vendor, Origin port, and Dest port
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
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
	When Operator click Update Billing Number "BOTH" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "BOTH" page UI
	When Operator update billing number "BOTH" information on Shipment Weight Dimension page with following data:
	  | mawb               | RANDOM                      |
	  | airhaulVendor      | {local-vendor-name}         |
	  | originAirhaul      | {local-airport-1-code}      |
	  | destinationAirhaul | {local-airport-2-code}      |
	  | swb                | RANDOM                      |
	  | seahaulVendor      | {local-seahaul-vendor-name} |
	  | originSeahaul      | {local-seaport-1-code}      |
	  | destinationSeahaul | {local-seaport-2-code}      |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "BOTH" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}, {KEY_MM_SHIPMENT_SWB}"
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "BOTH" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "BOTH" page UI
	When Operator update billing number "BOTH" information on Shipment Weight Dimension page with following data:
	  | mawb               | {KEY_SHIPMENT_UPDATED_AWB}    |
	  | airhaulVendor      | {local-vendor-name}           |
	  | originAirhaul      | {local-airport-2-code}        |
	  | destinationAirhaul | {local-airport-1-code}        |
	  | swb                | {KEY_MM_SHIPMENT_SWB}         |
	  | seahaulVendor      | {local-seahaul-vendor-2-name} |
	  | originSeahaul      | {local-seaport-2-code}        |
	  | destinationSeahaul | {local-seaport-1-code}        |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "BOTH" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}, {KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedSWBs
  Scenario: Update Both MAWB & SWB without Download Sum Up Report - Existing MAWB & New SWB Number - Update Airhaul Vendor
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
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
	When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
	When Operator update billing number "BOTH" information on Shipment Weight Dimension page with following data:
	  | mawb               | RANDOM                 |
	  | airhaulVendor      | {local-vendor-name}    |
	  | originAirhaul      | {local-airport-1-code} |
	  | destinationAirhaul | {local-airport-2-code} |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "BOTH" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "BOTH" page UI
	When Operator update billing number "BOTH" information on Shipment Weight Dimension page with following data:
	  | mawb               | {KEY_SHIPMENT_UPDATED_AWB}    |
	  | airhaulVendor      | {local-vendor-2-name}         |
	  | originAirhaul      | {local-airport-1-code}        |
	  | destinationAirhaul | {local-airport-2-code}        |
	  | swb                | RANDOM                        |
	  | seahaulVendor      | {local-seahaul-vendor-2-name} |
	  | originSeahaul      | {local-seaport-2-code}        |
	  | destinationSeahaul | {local-seaport-1-code}        |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "BOTH" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}, {KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedSWBs
  Scenario: Update Both MAWB & SWB without Download Sum Up Report - Existing MAWB & New SWB Number - Update Airhaul Origin Port
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
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
	When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
	When Operator update billing number "BOTH" information on Shipment Weight Dimension page with following data:
	  | mawb               | RANDOM                 |
	  | airhaulVendor      | {local-vendor-name}    |
	  | originAirhaul      | {local-airport-1-code} |
	  | destinationAirhaul | {local-airport-2-code} |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "BOTH" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "BOTH" page UI
	When Operator update billing number "BOTH" information on Shipment Weight Dimension page with following data:
	  | mawb               | {KEY_SHIPMENT_UPDATED_AWB}    |
	  | airhaulVendor      | {local-vendor-name}           |
	  | originAirhaul      | {local-airport-2-code}        |
	  | destinationAirhaul | {local-airport-1-code}        |
	  | swb                | RANDOM                        |
	  | seahaulVendor      | {local-seahaul-vendor-2-name} |
	  | originSeahaul      | {local-seaport-2-code}        |
	  | destinationSeahaul | {local-seaport-1-code}        |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "BOTH" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}, {KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs @DeleteCreatedSWBs
  Scenario: Update Both MAWB & SWB without Download Sum Up Report - Existing MAWB & New SWB Number - Update Airhaul Destination Port
	Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
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
	When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
	When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
	  | mawb        | RANDOM                 |
	  | vendor      | {local-vendor-name}    |
	  | origin      | {local-airport-1-code} |
	  | destination | {local-airport-2-code} |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click Update Billing Number "BOTH" on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Update Billing Number "BOTH" page UI
	When Operator update billing number "BOTH" information on Shipment Weight Dimension page with following data:
	  | mawb               | {KEY_SHIPMENT_UPDATED_AWB}    |
	  | airhaulVendor      | {local-vendor-name}           |
	  | originAirhaul      | {local-airport-2-code}        |
	  | destinationAirhaul | {local-airport-1-code}        |
	  | swb                | RANDOM                        |
	  | seahaulVendor      | {local-seahaul-vendor-2-name} |
	  | originSeahaul      | {local-seaport-2-code}        |
	  | destinationSeahaul | {local-seaport-1-code}        |
	Then Operator click update button on shipment weight update mawb page
	And Operator waits for 2 seconds
	And Operator verify Update Billing Number "BOTH" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}, {KEY_MM_SHIPMENT_SWB}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op