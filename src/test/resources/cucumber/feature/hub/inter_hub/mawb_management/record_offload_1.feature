@OperatorV2 @MiddleMile @Hub @InterHub @mawbManagement @RecordOffload1
Feature: MAWB Management - Record Offload 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Record Offload Created MAWB
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
	When Operator performs record offload MAWB following data below:
	  | mawb                 | {KEY_LIST_OF_CREATED_MAWB[1]}         |
	  | totalOffloadedPcs    | 1                                     |
	  | totalOffloadedWeight | 1                                     |
	  | nextFlight           | 12345                                 |
	  | departerTime         | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	  | arrivalTime          | {date: 3 days next, yyyy-MM-dd-HH-mm} |
	  | offload_reason       | RANDOM                                |
	  | comments             | Automation update                     |
	And Operator clicks offload update button on Record Offload MAWB Page
	Then Operator verifies record offload successful message

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Record Offload with Total Offloaded pcs <= 0
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
	When Operator performs record offload MAWB following data below:
	  | mawb              | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | totalOffloadedPcs | -1                            |
	Then Operator verifies error message "Must be greater than 0" under "Total Offloaded pcs" field on Record Offload Page

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Record Offload with Total Offloaded pcs is Empty
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
	When Operator performs record offload MAWB following data below:
	  | mawb              | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | totalOffloadedPcs | 2                             |
	And Operator clears text in filed "Total Offloaded pcs" on Record Offload Page
	Then Operator verifies error message "Please enter Total Offloaded pcs" under "Total Offloaded pcs" field on Record Offload Page

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Record Offload with Total Offloaded Weight <= 0
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
	When Operator performs record offload MAWB following data below:
	  | mawb                 | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | totalOffloadedPcs    | 1                             |
	  | totalOffloadedWeight | -1                            |
	Then Operator verifies error message "Must be greater than 0" under "Total Offloaded Weight" field on Record Offload Page

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Record Offload with Estimated Flight Date & Time from Future to Past
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
	When Operator performs record offload MAWB following data below:
	  | mawb              | {KEY_LIST_OF_CREATED_MAWB[1]}         |
	  | totalOffloadedPcs | 1                                     |
	  | departerTime      | {date: 3 days next, yyyy-MM-dd-HH-mm} |
	  | arrivalTime       | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	Then Operator verifies notification error message on MAWB Management Page

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Close Record Offload with all field already filled
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
	When Operator performs record offload MAWB following data below:
	  | mawb                 | {KEY_LIST_OF_CREATED_MAWB[1]}         |
	  | totalOffloadedPcs    | 1                                     |
	  | totalOffloadedWeight | 1                                     |
	  | nextFlight           | 12345                                 |
	  | departerTime         | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	  | arrivalTime          | {date: 3 days next, yyyy-MM-dd-HH-mm} |
	  | offload_reason       | RANDOM                                |
	  | comments             | Automation update                     |
	And Operator clicks close button on Record Offload Page
	Then Operator verifies all fileds on Record Offload are empty
	  | mawb | {KEY_LIST_OF_CREATED_MAWB[1]} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op

