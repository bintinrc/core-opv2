@OperatorV2 @MiddleMile @Hub @InterHub @mawbManagement @RecordOffload1 @CWF
Feature: MAWB Management - Record Offload 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments @DeleteCreatedMAWBs
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
      | mawb                 | {KEY_LIST_OF_CREATED_MAWB[1]}       |
      | totalOffloadedPcs    | 1                                   |
      | totalOffloadedWeight | 1                                   |
      | nextFlight           | 12345                               |
      | departerTime         | {gradle-next-1-day-yyyy-MM-dd-HH-mm}|
      | arrivalTime          | {gradle-next-1-day-yyyy-MM-dd-HH-mm}|
      | offload_reason       | RANDOM                              |
      | comments             | Automation update                   |
    And Operator clicks offload update button on Record Offload MAWB Page
    Then Operator verifies record offload successful message

  @DeleteShipments @DeleteCreatedMAWBs @DeleteDriver  @RT
  Scenario: Record Offload Created MAWB
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator adds order to shipment:
      | shipmentId | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API Operator closes all the created shipments
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {hub-id}   |
      | destinationFacility | {airport-hub-id-1}|
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                           |
      | originFacility      | {airport-hub-id-1}  |
      | destinationFacility | {airport-hub-id-2}  |
      | flight_no           | 12345                                 |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {airport-hub-id-2}   |
      | destinationFacility | {hub-id-2}|
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
    And API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"

    Given API Operator shipment inbound scan with airport trip with data below:
      | tripId      | {KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id} |
      | scanValue   | {KEY_CREATED_SHIPMENT_ID}                     |
      | hubSystemId | sg                                            |
      | hubId       | {mawb-hub-id-1}                       |
      | actionType  | ADD                                           |
      | scanType    | SHIPMENT_VAN_INBOUND                          |



    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    When Operator performs record offload MAWB following data below:
      | mawb                 | {KEY_LIST_OF_CREATED_MAWB[1]}       |
      | totalOffloadedPcs    | 1                                   |
      | totalOffloadedWeight | 1                                   |
      | nextFlight           | 12345                               |
      | departerTime         | {gradle-next-1-day-yyyy-MM-dd-HH-mm}|
      | arrivalTime          | {gradle-next-1-day-yyyy-MM-dd-HH-mm}|
      | offload_reason       | RANDOM                              |
      | comments             | Automation update                   |
    And Operator clicks offload update button on Record Offload MAWB Page
    Then Operator verifies record offload successful message



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


  @DeleteShipments @DeleteCreatedMAWBs
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

  @DeleteShipments @DeleteCreatedMAWBs
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
      | Unable to find the following 1 MAWB:\nabcdeffff|
    Given Operator clicks to go back button on MAWB Management page
    Then Operator verifies Search MAWB Management Page
    And Operator verifies total 5 results shown on MAWB Management Page

  @DeleteShipments @DeleteCreatedMAWBs
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

  @DeleteShipments @DeleteCreatedMAWBs
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

  @DeleteShipments @DeleteCreatedMAWBs
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

