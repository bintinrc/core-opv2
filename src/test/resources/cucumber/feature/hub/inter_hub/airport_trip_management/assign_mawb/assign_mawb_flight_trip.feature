@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AssignMAWBFlighttTrip
Feature: Airport Trip Management - Assign MAWB to Flight Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CancelTrip @DeleteShipments @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Assign MAWB to Pending Flight Trip
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
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                         |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}|
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | vendorId             | {vendor-id}                      |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    Given Operator assigns MAWB to flight trip with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | vendor  | {vendor-name}                              |
      | mawb    | {KEY_LIST_OF_CREATED_MAWB[1]}              |
    Then Operator verifies assigned MAWB success message

  @DeleteShipments @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Assign MAWB to Transit Flight Trip
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
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                         |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}|
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | vendorId             | {vendor-id}                      |
    And API Operator depart flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    Given Operator assigns MAWB to flight trip with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | vendor  | {vendor-name}                              |
      | mawb    | {KEY_LIST_OF_CREATED_MAWB[1]}              |
    Then Operator verifies assigned MAWB success message

  @DeleteShipments @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Assign MAWB to Arrived Flight Trip
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
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                         |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}|
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | vendorId             | {vendor-id}                      |
    And API Operator depart flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}"
    And API Operator arrive flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    Given Operator assigns MAWB to flight trip with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | vendor  | {vendor-name}                              |
      | mawb    | {KEY_LIST_OF_CREATED_MAWB[1]}              |
    Then Operator verifies assigned MAWB success message

  @DeleteShipments @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Assign MAWB to Completed Flight Trip
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
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                         |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}|
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | vendorId             | {vendor-id}                      |
    And API Operator depart flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}"
    And API Operator arrive flight trip "{KEY_CURRENT_MOVEMENT_TRIP_ID}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    Given Operator assigns MAWB to flight trip with data below:
      | tripID  | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | vendor  | {vendor-name}                              |
      | mawb    | {KEY_LIST_OF_CREATED_MAWB[1]}              |
    Then Operator verifies assigned MAWB success message

  @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Assign MAWB to Cancelled Flight Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id    | SG        |
      | airportCode  | GENERATED |
      | airportName  | GENERATED |
      | city         | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator create new airport using data below:
      | system_id    | SG        |
      | airportCode  | GENERATED |
      | airportName  | GENERATED |
      | city         | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator refresh Airports cache
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id}|
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id}|
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator fill the departure date for Airport Management
      | startDate | {gradle-next-0-day-yyyy-MM-dd}    |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd}    |
    When Operator fill the Origin Or Destination for Airport Management
      | originOrDestination    | {KEY_CREATED_AIRPORT_LIST[1].airport_code}|
    And Operator click on 'Load Trips' on Airport Management
    Then Verify the parameters of loaded trips in Airport Management
      | startDate           | {gradle-next-0-day-yyyy-MM-dd}                      |
      | endDate             | {gradle-next-1-day-yyyy-MM-dd}                      |
      | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport)|
    When Operator cancel trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" on Airport Trip Management page
    And Operator select Cancellation Reason on Cancel Trip Page
    Then Operator verifies the Cancellation Reason are correct
    And Operator verifies the Cancel Trip button is "enable"
    When Operator clicks "Cancel Flight Trip" button on cancel trip dialog
    Then Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} cancelled" display on Airport Trip Management page
    And Operator verify "Assign MAWB" button is disabled on Airport Trip page

  @KillBrowser
  Scenario: Kill Browser
    Given no-op