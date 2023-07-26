@OperatorV2 @MiddleMile @Hub @InterHub @mawbManagement @ManifestMAWB
Feature: MAWB Management - Manifest MAWB

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Success Manifest MAWB with Attachment and Comments
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
	When Operator performs manifest MAWB following data below:
	  | mawb           | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | uploadFileSize | 1000                          |
	  | comments       | Automation comment            |
	And Operator clicks on submit manifest button on Manifest MAWB Page
	Then Operator verifies manifest MAWB successfully message

  @HappyPath @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Fail Manifest MAWB with Attachment and Comments
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
	When Operator performs manifest MAWB following data below:
	  | mawb           | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | uploadFileSize | 1000                          |
	  | comments       | Automation comment            |
	And DB Operator delete created MAWBs
	And Operator clicks on submit manifest button on Manifest MAWB Page
	Then Operator verifies toast messages below on Manifest MAWB page:
	  | Status: 400                                                        |
	  | URL: post /1.0/manifests                                           |
	  | Error Message: mawb refs [{KEY_LIST_OF_CREATED_MAWB[1]}] not found |

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Success Manifest MAWB with Attachment and No Comments
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
	When Operator performs manifest MAWB following data below:
	  | mawb           | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | uploadFileSize | 1000                          |
	And Operator clicks on submit manifest button on Manifest MAWB Page
	Then Operator verifies manifest MAWB successfully message

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Fail Manifest MAWB with Attachment and No Comments
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
	When Operator performs manifest MAWB following data below:
	  | mawb           | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | uploadFileSize | 1000                          |
	And DB Operator delete created MAWBs
	And Operator clicks on submit manifest button on Manifest MAWB Page
	Then Operator verifies toast messages below on Manifest MAWB page:
	  | Status: 400                                                        |
	  | URL: post /1.0/manifests                                           |
	  | Error Message: mawb refs [{KEY_LIST_OF_CREATED_MAWB[1]}] not found |

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Manifest MAWB with 0 Total Booked
	Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM         |
	  | destinationAirportId | {airport-id-1} |
	  | originAirportId      | {airport-id-2} |
	  | vendorId             | {vendor-id}    |
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
	When Operator performs manifest MAWB following data below:
	  | mawb           | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | uploadFileSize | 1000                          |
	  | comments       | Automation comment            |
	And Operator clicks on submit manifest button on Manifest MAWB Page
	Then Operator verifies manifest MAWB successfully message

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Cancel Manifest MAWB with Attachment and Comments
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
	When Operator performs manifest MAWB following data below:
	  | mawb           | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | uploadFileSize | 1000                          |
	  | comments       | Automation comment            |
	And Operator clicks on close button on Manifest MAWB Page
	Then Operator verifies that manifest MAWB page close

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Cancel Manifest MAWB with Attachment and No Comments
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
	When Operator performs manifest MAWB following data below:
	  | mawb           | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | uploadFileSize | 1000                          |
	And Operator clicks on close button on Manifest MAWB Page
	Then Operator verifies that manifest MAWB page close

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Upload > 10 MB Attachment in Manifest MAWB
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
	When Operator performs manifest MAWB following data below:
	  | mawb           | {KEY_LIST_OF_CREATED_MAWB[1]} |
	  | uploadFileSize | 20000000                      |
	And Operator clicks on close button on Manifest MAWB Page
	Then Operator verifies that manifest MAWB page close

  @KillBrowser
  Scenario: Kill Browser
	Given no-op

