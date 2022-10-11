@OperatorV2 @MiddleMile @Hub @InterHub @mawbManagement @SearchByMAWBnumber @CWF
Feature: MAWB Management - Search by MAWB number

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments
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


  @DeleteShipments
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

  @DeleteShipments
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

  @DeleteShipments
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
      | Unable to find the following 1 MAWB:\nabcdeffff|
    Given Operator clicks to go back button on MAWB Management page
    Then Operator verifies Search MAWB Management Page
    And Operator verifies total 5 result show on MAWB Management Page

  @DeleteShipments
  Scenario: Search by MAWB Number with Multiple Valid MAWB Number > 100
    Given API Operator create multiple 110 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
    Then Operator verifies error toast message on MAWB Management Page:
      |We cannot process more than 100 MAWB number|

  @DeleteShipments
  Scenario: Search by MAWB Number with Multiple Invalid MAWB Number > 100
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | GENERATED 100 INVALID MAWB |
      | adasdasdasdsd              |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies error toast message on MAWB Management Page:
      |We cannot process more than 100 MAWB number|

  @DeleteShipments
  Scenario: Search by MAWB Number with Multiple Valid and Invalid MAWB Number > 100
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
      | GENERATED 100 INVALID MAWB |
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies error toast message on MAWB Management Page:
      |We cannot process more than 100 MAWB number|

  @DeleteShipments
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
    And Operator verifies total 5 result show on MAWB Management Page

  @DeleteShipments
  Scenario: Search by MAWB Number with Multiple Duplicate MAWB Number > 100
    Given API Operator create multiple 101 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
      | {KEY_LIST_OF_CREATED_MAWB[1]} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies error toast message on MAWB Management Page:
      |We cannot process more than 100 MAWB number|

  @KillBrowser
  Scenario: Kill Browser
    Given no-op

