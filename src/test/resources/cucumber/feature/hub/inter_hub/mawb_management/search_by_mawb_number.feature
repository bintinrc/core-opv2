@OperatorV2 @MiddleMile @Hub @InterHub @mawbManagement @SearchByMAWBnumber
Feature: MAWB Management - Search by MAWB number

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Search by MAWB Number with Single Valid MAWB Number
	Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> MAWB Management
	Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
	Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
	  | {KEY_LIST_OF_CREATED_MAWB} |
	And Operator clicks on "Search MAWB" button on MAWB Management Page
	Then Operator verifies Search MAWB Management Page


  Scenario: Search by MAWB Number with Single Invalid MAWB Number
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> MAWB Management
	Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
	Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
	  | abcdef |
	And Operator clicks on "Search MAWB" button on MAWB Management Page
	Then Operator verifies error message below on MAWB Management Page:
	  | Cannot find any MAWB. Try different search criteria. |
	Given Operator clicks to go back button on MAWB Management page


  @HappyPath @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Search by MAWB Number with Single Duplicate MAWB Number
	Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> MAWB Management
	Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
	Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
	  | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | {KEY_LIST_OF_CREATED_MAWB[1]} |
	And Operator clicks on "Search MAWB" button on MAWB Management Page
	Then Operator verifies Search MAWB Management Page

  @HappyPath @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Search by MAWB Number with Multiple Valid MAWB Number <= 100
	Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> MAWB Management
	Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
	Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
	  | {KEY_LIST_OF_CREATED_MAWB} |
	And Operator clicks on "Search MAWB" button on MAWB Management Page
	Then Operator verifies Search MAWB Management Page

  @HappyPath
  Scenario: Search by MAWB Number with Multiple Invalid MAWB Number <= 100
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> MAWB Management
	Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
	Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
	  | abcdef |
	  | abc123 |
	  | abc456 |
	And Operator clicks on "Search MAWB" button on MAWB Management Page
	Then Operator verifies error message below on MAWB Management Page:
	  | Cannot find any MAWB. Try different search criteria. |
	Given Operator clicks to go back button on MAWB Management page

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Search by MAWB Number with Multiple Valid and Invalid MAWB Number <= 100
	Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> MAWB Management
	Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
	Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
	  | {KEY_LIST_OF_CREATED_MAWB} |
	  | abcdeffff                  |
	And Operator clicks on "Search MAWB" button on MAWB Management Page
	Then Operator verifies error message below on MAWB Management Page:
	  | Unable to find the following 1 MAWB:\nabcdeffff |
	Given Operator clicks to go back button on MAWB Management page
	Then Operator verifies Search MAWB Management Page
	And Operator verifies total 5 results shown on MAWB Management Page

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Search by MAWB Number with Multiple Duplicate MAWB Number <= 100
	Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> MAWB Management
	Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
	Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
	  | {KEY_LIST_OF_CREATED_MAWB} |
	  | {KEY_LIST_OF_CREATED_MAWB} |
	And Operator clicks on "Search MAWB" button on MAWB Management Page
	Then Operator verifies Search MAWB Management Page
	And Operator verifies total 5 results shown on MAWB Management Page

  @KillBrowser
  Scenario: Kill Browser
	Given no-op

