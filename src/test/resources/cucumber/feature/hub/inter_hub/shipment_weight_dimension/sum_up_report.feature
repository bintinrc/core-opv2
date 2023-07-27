#https://studio.cucumber.io/projects/210778/test-plan/folders/2095313
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @SumUpReport
Feature: Sum Up Report

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#    https://studio.cucumber.io/projects/210778/test-plan/folders/2095313/scenarios/6905685
  @HappyPath @DeleteShipments
  Scenario: Select Some SID from Shipment Weight Dimension table and Download All Sum Up Report
	Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 5            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 5 |
	And Operator select 4 rows from the shipment weight table
	When Operator click sum up button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator select all rows from the shipment sum up report table
	And Operator click on Download Full Report button on shipment sum up report table
	Then Operator verify the downloaded CSV Sum Up report file is contains the correct values
	  | header | "No","Origin Hub","Destination Hub","Shipment ID","Weight (kg)","kgV","Length","Width","Height","No. of parcels","Status","MAWB","SWB","Air Haul Vendor","Sea Haul Vendor","Origin Airport","Origin Seaport","Destination Airport","Destination Seaport","Comments" |

#    https://studio.cucumber.io/projects/210778/test-plan/folders/2095313/scenarios/6905699
  @HappyPath @DeleteShipments
  Scenario: Select All SID from Shipment Weight Dimension table and Download All Sum Up Report
	Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 5            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 5 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click sum up button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator select all rows from the shipment sum up report table
	And Operator click on Download Full Report button on shipment sum up report table
	Then Operator verify the downloaded CSV Sum Up report file is contains the correct values
	  | header | "No","Origin Hub","Destination Hub","Shipment ID","Weight (kg)","kgV","Length","Width","Height","No. of parcels","Status","MAWB","SWB","Air Haul Vendor","Sea Haul Vendor","Origin Airport","Origin Seaport","Destination Airport","Destination Seaport","Comments" |

#    https://studio.cucumber.io/projects/210778/test-plan/folders/2095313/scenarios/6905704
  @HappyPath @DeleteShipments
  Scenario: Select All SID from Shipment Weight Dimension table and Remove Some SID of Sum Up Report
	Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 5            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 5 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click sum up button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator remove 2 shipments on Shipment Weight Sum Up report
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator select all rows from the shipment sum up report table
	And Operator click on Download Full Report button on shipment sum up report table
	Then Operator verify the downloaded CSV Sum Up report file is contains the correct values
	  | header | "No","Origin Hub","Destination Hub","Shipment ID","Weight (kg)","kgV","Length","Width","Height","No. of parcels","Status","MAWB","SWB","Air Haul Vendor","Sea Haul Vendor","Origin Airport","Origin Seaport","Destination Airport","Destination Seaport","Comments" |

#    https://studio.cucumber.io/projects/210778/test-plan/folders/2095313/scenarios/6905707
  @DeleteShipments
  Scenario: Select Some SID from Shipment Weight Dimension table and Remove Some SID of Sum Up Report
	Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 5            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 5 |
	And Operator select 4 rows from the shipment weight table
	When Operator click sum up button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator remove 2 shipments on Shipment Weight Sum Up report
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator select all rows from the shipment sum up report table
	And Operator click on Download Full Report button on shipment sum up report table
	Then Operator verify the downloaded CSV Sum Up report file is contains the correct values
	  | header | "No","Origin Hub","Destination Hub","Shipment ID","Weight (kg)","kgV","Length","Width","Height","No. of parcels","Status","MAWB","SWB","Air Haul Vendor","Sea Haul Vendor","Origin Airport","Origin Seaport","Destination Airport","Destination Seaport","Comments" |

#    https://studio.cucumber.io/projects/210778/test-plan/folders/2095313/scenarios/6905708
  @DeleteShipments
  Scenario: Select Some SID from Shipment Weight Dimension table and Cancel Remove Some SID of Sum Up Report
	Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 5            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 5 |
	And Operator select 4 rows from the shipment weight table
	When Operator click sum up button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator remove shipment and cancel on Shipment Weight Sum Up report
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator select all rows from the shipment sum up report table
	And Operator click on Download Full Report button on shipment sum up report table
	Then Operator verify the downloaded CSV Sum Up report file is contains the correct values
	  | header | "No","Origin Hub","Destination Hub","Shipment ID","Weight (kg)","kgV","Length","Width","Height","No. of parcels","Status","MAWB","SWB","Air Haul Vendor","Sea Haul Vendor","Origin Airport","Origin Seaport","Destination Airport","Destination Seaport","Comments" |

#    https://studio.cucumber.io/projects/210778/test-plan/folders/2095313/scenarios/6905709
  @DeleteShipments
  Scenario: Select All SID from Shipment Weight Dimension table and Cancel Remove Some SID of Sum Up Report
	Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 5            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 5 |
	And Operator select all data on Shipment Weight Dimension Table
	When Operator click sum up button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator remove shipment and cancel on Shipment Weight Sum Up report
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator select all rows from the shipment sum up report table
	And Operator click on Download Full Report button on shipment sum up report table
	Then Operator verify the downloaded CSV Sum Up report file is contains the correct values
	  | header | "No","Origin Hub","Destination Hub","Shipment ID","Weight (kg)","kgV","Length","Width","Height","No. of parcels","Status","MAWB","SWB","Air Haul Vendor","Sea Haul Vendor","Origin Airport","Origin Seaport","Destination Airport","Destination Seaport","Comments" |

  @HappyPath @DeleteShipments
  Scenario: Select Some SID from Shipment Weight Dimension table and Remove All SID of Sum Up Report
	Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state | initial |
	When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
	Then Operator verify Shipment Weight Dimension Load Shipment page UI
	  | state             | search_valid |
	  | numberOfShipments | 5            |
	When Operator click search button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Dimension Table page is shown
	When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
	  | expectedNumOfRows | 5 |
	And Operator select 4 rows from the shipment weight table
	When Operator click sum up button on Shipment Weight Dimension page
	Then Operator verify Shipment Weight Sum Up report page UI
	When Operator remove 4 shipments on Shipment Weight Sum Up report
	Then Operator verify Shipment Weight Sum Up report show empty record

  @KillBrowser
  Scenario: Kill Browser
	Given no-op