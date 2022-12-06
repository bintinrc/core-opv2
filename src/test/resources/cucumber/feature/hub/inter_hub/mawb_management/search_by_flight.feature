@OperatorV2 @MiddleMile @Hub @InterHub @mawbManagement @SearchByFlight
Feature: MAWB Management - Search by Flight

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteCreatedMAWBs
  Scenario: Search by Flight with Valid Filter
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | vendorId             | {vendor-id}                      |
    And DB Operator get ID of MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}"
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                         |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}|
      | flight_no           | 12345                               |
    And Operator put MAWBs below to flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}":
      | {KEY_OF_CURRENT_MAWB_ID}|
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by Flight" UI on MAWB Management Page
    Given Operator searchs by flight following data below on MAWB Management page:
      | flight_no               | 12345                         |
      | flightTripDepartureDate | {gradle-next-1-day-yyyy-MM-dd}|
    And Operator clicks on "Search by Flight" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    And Operator verifies total 1 results shown on MAWB Management Page


  @DeleteShipments @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteCreatedMAWBs
  Scenario: Search by Flight with Valid Filter - Reload Search
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id}  |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | vendorId             | {vendor-id}    |
    And DB Operator get ID of MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}"
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                   |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}            |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}             |
      | flight_no           | 12345                         |
    And Operator put MAWBs below to flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}":
      | {KEY_OF_CURRENT_MAWB_ID}|
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by Flight" UI on MAWB Management Page
    Given Operator searchs by flight following data below on MAWB Management page:
      | flight_no               | 12345                         |
      | flightTripDepartureDate | {gradle-next-1-day-yyyy-MM-dd}|
    And Operator clicks on "Search by Flight" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    And Operator verifies total 1 results shown on MAWB Management Page
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id}  |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | vendorId             | {vendor-id}    |
    And DB Operator get ID of MAWB "{KEY_LIST_OF_CREATED_MAWB[2]}"
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                   |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}            |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}             |
      | flight_no           | 12345                         |
    And Operator put MAWBs below to flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}":
      | {KEY_OF_CURRENT_MAWB_ID}|
    When Operator clicks on "Reload" button on MAWB Management Page
    Then Operator verifies total 2 results shown on MAWB Management Page

  @DeleteShipments @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteCreatedMAWBs
  Scenario: Search by Flight with Valid Filter - No Result Found
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | vendorId             | {vendor-id}                      |
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                         |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}|
      | flight_no           | 12345                               |
      | mawb                | {KEY_LIST_OF_CREATED_MAWB[1]}       |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by Flight" UI on MAWB Management Page
    Given Operator searchs by flight following data below on MAWB Management page:
      | flight_no               | 12345                         |
      | flightTripDepartureDate | {gradle-next-1-day-yyyy-MM-dd}|
    And Operator clicks on "Search by Flight" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    And Operator verifies total 0 results shown on MAWB Management Page

  @DeleteShipments @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteCreatedMAWBs
  Scenario: Search by Flight with Valid Filter - Delete previous value of Flight Number
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | vendorId             | {vendor-id}                      |
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                         |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}|
      | flight_no           | 12345                               |
      | mawb                | {KEY_LIST_OF_CREATED_MAWB[1]}       |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by Flight" UI on MAWB Management Page
    Given Operator searchs by flight following data below on MAWB Management page:
      | flight_no               | 12345                         |
      | flightTripDepartureDate | {gradle-next-1-day-yyyy-MM-dd}|
    And Operator removes text of "Flight Number" field on MAWB Management page
    Then Operator verifies Mandatory require error message of "Flight Number" field on MAWB Management page
    And Operator verifies button "Search by Flight" is disalbe on MAWB Management page


  @DeleteShipments @CancelTrip @DeleteCreatedAirports @DeleteAirportsViaAPI @DeleteCreatedMAWBs
  Scenario: Search by Flight with Valid Filter - Delete previous value of Flight Trip Departure Date
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | GENERATED   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | vendorId             | {vendor-id}                      |
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                         |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}|
      | flight_no           | 12345                               |
      | mawb                | {KEY_LIST_OF_CREATED_MAWB[1]}       |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by Flight" UI on MAWB Management Page
    Given Operator searchs by flight following data below on MAWB Management page:
      | flight_no               | 12345                         |
      | flightTripDepartureDate | {gradle-next-1-day-yyyy-MM-dd}|
    And Operator removes text of "Search by Flight_Flight Trip Departure Date" field on MAWB Management page
    Then Operator verifies Mandatory require error message of "Search by Flight_Flight Trip Departure Date" field on MAWB Management page
    And Operator verifies button "Search by Flight" is disalbe on MAWB Management page

  @KillBrowser
  Scenario: Kill Browser
    Given no-op

