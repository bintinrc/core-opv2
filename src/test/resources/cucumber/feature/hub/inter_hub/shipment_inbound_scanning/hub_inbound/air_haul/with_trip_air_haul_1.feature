@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithTripAirHaul1
Feature: Air Haul Shipment Hub Inbound With Trip Scanning 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteShipment @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI @CancelTrip
  Scenario: Scan Pending Air Haul Shipment in Shipment's Destination Hub - Hub Inbound with Airport to Warehouse Trip
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create 2 new airport using data below:
	  | system_id   | SG        |
	  | airportCode | GENERATED |
	  | airportName | GENERATED |
	  | city        | GENERATED |
	  | latitude    | GENERATED |
	  | longitude   | GENERATED |
	Given API Operator creates 2 new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | STATION   |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	And API Operator reloads hubs cache
	And API Operator refresh Airports cache
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	And API Operator put created parcel to shipment
	And API Operator closes the created shipment
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM                           |
	  | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
	  | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
	  | vendorId             | {vendor-id}                      |
	Given API Operator create 2 new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	Given API Operator create new air trip with data below:
	  | airtripType         | TO_FROM_AIRPORT_TRIP                 |
	  | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].id}     |
	  | destinationFacility | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
	And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Given API Operator create new air trip with data below:
	  | airtripType         | FLIGHT_TRIP                          |
	  | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
	  | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
	  | flight_no           | NLI12345                             |
	Given Operator go to menu Inter-Hub -> Airport Trip Management
	And Operator verifies that the Airport Management Page is opened
	When Operator fill the departure date for Airport Management
	  | startDate | {gradle-next-0-day-yyyy-MM-dd} |
	  | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
	When Operator fill the Origin Or Destination for Airport Management
	  | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
	And Operator click on 'Load Trips' on Airport Management
	Then Verify the parameters of loaded trips in Airport Management
	  | startDate           | {gradle-next-0-day-yyyy-MM-dd}                       |
	  | endDate             | {gradle-next-1-day-yyyy-MM-dd}                       |
	  | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) |
	Given Operator assigns MAWB to flight trip with data below:
	  | tripID | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} |
	  | vendor | {vendor-name}                              |
	  | mawb   | {KEY_LIST_OF_CREATED_MAWB[1]}              |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
	  | inboundType          | Into Van                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
	  | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[1].airport_name}                                                                                      |
	And Operator click start inbound
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
	When Operator clicks end inbound button
	And Operator clicks proceed in end inbound dialog "Van Inbound"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Transit to Airport                   |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When API Operator arrive trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with trip with data below:
	  | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
	  | actionType | ADD                                        |
	  | scanType   | SHIPMENT_HUB_INBOUND                       |
	When API Operator complete trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with data below:
	  | systemId | sg                                         |
	  | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
	  | scanType | shipment_hub_inbound                       |
	  | driverId | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Handed over to Airline               |
	When API Operator depart flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
	When API Operator arrive flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
	Given API Operator create new air trip with data below:
	  | airtripType         | TO_FROM_AIRPORT_TRIP                 |
	  | originFacility      | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
	  | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[2].id}     |
	And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
	Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with trip with data below:
	  | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
	  | actionType | ADD                                        |
	  | scanType   | SHIPMENT_VAN_INBOUND                       |
	Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with data below:
	  | systemId | sg                                         |
	  | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
	  | scanType | shipment_van_inbound                       |
	  | driverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
	When API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Transit                              |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
	  | inboundType          | Into Hub                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
	  | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[2].airport_name}                                                                                      |
	And Operator click start inbound
	And Operator click proceed in trip completion dialog
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[2]}"
	When Operator clicks end inbound button
	When Operator clicks proceed in end inbound dialog "Hub Inbound"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Completed                            |

  @DeleteShipment @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI @CancelTrip
  Scenario: Scan Closed Air Haul Shipment in Shipment's Origin Hub - Van Inbound with Warehouse to Airport Trip
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create 2 new airport using data below:
	  | system_id   | SG        |
	  | airportCode | GENERATED |
	  | airportName | GENERATED |
	  | city        | GENERATED |
	  | latitude    | GENERATED |
	  | longitude   | GENERATED |
	Given API Operator creates 2 new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | STATION   |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	And API Operator reloads hubs cache
	And API Operator refresh Airports cache
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	And API Operator put created parcel to shipment
	And API Operator closes the created shipment
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM                           |
	  | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
	  | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
	  | vendorId             | {vendor-id}                      |
	Given API Operator create 2 new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	Given API Operator create new air trip with data below:
	  | airtripType         | TO_FROM_AIRPORT_TRIP                 |
	  | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].id}     |
	  | destinationFacility | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
	And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Given API Operator create new air trip with data below:
	  | airtripType         | FLIGHT_TRIP                          |
	  | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
	  | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
	  | flight_no           | NLI12345                             |
	Given Operator go to menu Inter-Hub -> Airport Trip Management
	And Operator verifies that the Airport Management Page is opened
	When Operator fill the departure date for Airport Management
	  | startDate | {gradle-next-0-day-yyyy-MM-dd} |
	  | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
	When Operator fill the Origin Or Destination for Airport Management
	  | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
	And Operator click on 'Load Trips' on Airport Management
	Then Verify the parameters of loaded trips in Airport Management
	  | startDate           | {gradle-next-0-day-yyyy-MM-dd}                       |
	  | endDate             | {gradle-next-1-day-yyyy-MM-dd}                       |
	  | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) |
	Given Operator assigns MAWB to flight trip with data below:
	  | tripID | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} |
	  | vendor | {vendor-name}                              |
	  | mawb   | {KEY_LIST_OF_CREATED_MAWB[1]}              |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
	  | inboundType          | Into Van                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
	  | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[1].airport_name}                                                                                      |
	And Operator click start inbound
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
	When Operator clicks end inbound button
	And Operator clicks proceed in end inbound dialog "Van Inbound"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Transit to Airport                   |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When API Operator arrive trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with trip with data below:
	  | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
	  | actionType | ADD                                        |
	  | scanType   | SHIPMENT_HUB_INBOUND                       |
	When API Operator complete trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with data below:
	  | systemId | sg                                         |
	  | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
	  | scanType | shipment_hub_inbound                       |
	  | driverId | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Handed over to Airline               |
	When API Operator depart flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
	When API Operator arrive flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
	Given API Operator create new air trip with data below:
	  | airtripType         | TO_FROM_AIRPORT_TRIP                 |
	  | originFacility      | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
	  | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[2].id}     |
	And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
	Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with trip with data below:
	  | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
	  | actionType | ADD                                        |
	  | scanType   | SHIPMENT_VAN_INBOUND                       |
	Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with data below:
	  | systemId | sg                                         |
	  | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
	  | scanType | shipment_van_inbound                       |
	  | driverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
	When API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Transit                              |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	And API Operator put created parcel to shipment
	And API Operator closes the created shipment
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
	  | inboundType          | Into Hub                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
	  | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[2].airport_name}                                                                                      |
	And Operator click start inbound
	And Operator click proceed in trip completion dialog
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[2]}"
	When Operator clicks end inbound button
	When Operator clicks proceed in end inbound dialog "Hub Inbound"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Completed                            |

  @DeleteShipment @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI @CancelTrip
  Scenario: Scan Transit Air Haul Shipment in Shipment's Destination Hub - Hub Inbound with Airport to Warehouse  Trip
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create 2 new airport using data below:
	  | system_id   | SG        |
	  | airportCode | GENERATED |
	  | airportName | GENERATED |
	  | city        | GENERATED |
	  | latitude    | GENERATED |
	  | longitude   | GENERATED |
	Given API Operator creates 2 new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | STATION   |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	And API Operator reloads hubs cache
	And API Operator refresh Airports cache
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	And API Operator put created parcel to shipment
	And API Operator closes the created shipment
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM                           |
	  | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
	  | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
	  | vendorId             | {vendor-id}                      |
	Given API Operator create 2 new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	Given API Operator create new air trip with data below:
	  | airtripType         | TO_FROM_AIRPORT_TRIP                 |
	  | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].id}     |
	  | destinationFacility | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
	And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Given API Operator create new air trip with data below:
	  | airtripType         | FLIGHT_TRIP                          |
	  | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
	  | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
	  | flight_no           | NLI12345                             |
	Given Operator go to menu Inter-Hub -> Airport Trip Management
	And Operator verifies that the Airport Management Page is opened
	When Operator fill the departure date for Airport Management
	  | startDate | {gradle-next-0-day-yyyy-MM-dd} |
	  | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
	When Operator fill the Origin Or Destination for Airport Management
	  | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
	And Operator click on 'Load Trips' on Airport Management
	Then Verify the parameters of loaded trips in Airport Management
	  | startDate           | {gradle-next-0-day-yyyy-MM-dd}                       |
	  | endDate             | {gradle-next-1-day-yyyy-MM-dd}                       |
	  | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) |
	Given Operator assigns MAWB to flight trip with data below:
	  | tripID | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} |
	  | vendor | {vendor-name}                              |
	  | mawb   | {KEY_LIST_OF_CREATED_MAWB[1]}              |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
	  | inboundType          | Into Van                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
	  | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[1].airport_name}                                                                                      |
	And Operator click start inbound
	And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
	When Operator clicks end inbound button
	And Operator clicks proceed in end inbound dialog "Van Inbound"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                           |
	  | id           | {KEY_CREATED_SHIPMENT_ID}          |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	  | status       | Transit to Airport                 |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When API Operator arrive trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with trip with data below:
	  | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}      |
	  | actionType | ADD                                        |
	  | scanType   | SHIPMENT_HUB_INBOUND                       |
	When API Operator complete trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with data below:
	  | systemId | sg                                         |
	  | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
	  | scanType | shipment_hub_inbound                       |
	  | driverId | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                           |
	  | id           | {KEY_CREATED_SHIPMENT_ID}          |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	  | status       | Handed over to Airline             |
	When API Operator depart flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
	When API Operator arrive flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
	Given API Operator create new air trip with data below:
	  | airtripType         | TO_FROM_AIRPORT_TRIP                 |
	  | originFacility      | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
	  | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[2].id}     |
	And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
	Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with trip with data below:
	  | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}      |
	  | actionType | ADD                                        |
	  | scanType   | SHIPMENT_VAN_INBOUND                       |
	Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with data below:
	  | systemId | sg                                         |
	  | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
	  | scanType | shipment_van_inbound                       |
	  | driverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
	When API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                           |
	  | id           | {KEY_CREATED_SHIPMENT_ID}          |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	  | status       | Transit                            |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
	  | inboundType          | Into Hub                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
	  | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[2].airport_name}                                                                                      |
	And Operator click start inbound
	And Operator click proceed in trip completion dialog
	Then Operator verifies shipment to go with trip is shown with total "1"
	And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
	When Operator clicks end inbound button
	When Operator clicks proceed in end inbound dialog "Hub Inbound"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                           |
	  | id           | {KEY_CREATED_SHIPMENT_ID}          |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name} |
	  | status       | Completed                          |

  @DeleteShipment @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI @CancelTrip
  Scenario: Scan Cancelled Air Haul Shipment in Shipment's Transit Hub - Hub Inbound with Airport to Warehouse Trip
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create 2 new airport using data below:
	  | system_id   | SG        |
	  | airportCode | GENERATED |
	  | airportName | GENERATED |
	  | city        | GENERATED |
	  | latitude    | GENERATED |
	  | longitude   | GENERATED |
	Given API Operator creates 2 new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | STATION   |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	And API Operator reloads hubs cache
	And API Operator refresh Airports cache
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	And API Operator put created parcel to shipment
	And API Operator closes the created shipment
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM                           |
	  | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
	  | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
	  | vendorId             | {vendor-id}                      |
	Given API Operator create 2 new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	Given API Operator create new air trip with data below:
	  | airtripType         | TO_FROM_AIRPORT_TRIP                 |
	  | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].id}     |
	  | destinationFacility | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
	And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Given API Operator create new air trip with data below:
	  | airtripType         | FLIGHT_TRIP                          |
	  | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
	  | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
	  | flight_no           | NLI12345                             |
	Given Operator go to menu Inter-Hub -> Airport Trip Management
	And Operator verifies that the Airport Management Page is opened
	When Operator fill the departure date for Airport Management
	  | startDate | {gradle-next-0-day-yyyy-MM-dd} |
	  | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
	When Operator fill the Origin Or Destination for Airport Management
	  | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
	And Operator click on 'Load Trips' on Airport Management
	Then Verify the parameters of loaded trips in Airport Management
	  | startDate           | {gradle-next-0-day-yyyy-MM-dd}                       |
	  | endDate             | {gradle-next-1-day-yyyy-MM-dd}                       |
	  | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) |
	Given Operator assigns MAWB to flight trip with data below:
	  | tripID | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} |
	  | vendor | {vendor-name}                              |
	  | mawb   | {KEY_LIST_OF_CREATED_MAWB[1]}              |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
	  | inboundType          | Into Van                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
	  | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[1].airport_name}                                                                                      |
	And Operator click start inbound
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
	When Operator clicks end inbound button
	And Operator clicks proceed in end inbound dialog "Van Inbound"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Transit to Airport                   |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When API Operator arrive trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with trip with data below:
	  | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
	  | actionType | ADD                                        |
	  | scanType   | SHIPMENT_HUB_INBOUND                       |
	When API Operator complete trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with data below:
	  | systemId | sg                                         |
	  | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
	  | scanType | shipment_hub_inbound                       |
	  | driverId | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Handed over to Airline               |
	When API Operator depart flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
	When API Operator arrive flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
	Given API Operator create new air trip with data below:
	  | airtripType         | TO_FROM_AIRPORT_TRIP                 |
	  | originFacility      | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
	  | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[2].id}     |
	And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
	Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with trip with data below:
	  | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
	  | actionType | ADD                                        |
	  | scanType   | SHIPMENT_VAN_INBOUND                       |
	Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with data below:
	  | systemId | sg                                         |
	  | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
	  | scanType | shipment_van_inbound                       |
	  | driverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
	When API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Transit                              |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	When API Operator change the status of the shipment into "Cancelled"
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
	  | inboundType          | Into Hub                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
	  | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[2].airport_name}                                                                                      |
	And Operator click start inbound
	And Operator click proceed in trip completion dialog
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[2]}"
	Then Click on Yes, continue on dialog box
	When Operator clicks end inbound button
	When Operator clicks proceed in end inbound dialog "Hub Inbound"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Completed                            |

  @DeleteShipment @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI @CancelTrip
  Scenario: Scan Completed Air Haul Shipment in Shipment's Transit Hub - Hub Inbound with Airport to Warehous Trip
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create 2 new airport using data below:
	  | system_id   | SG        |
	  | airportCode | GENERATED |
	  | airportName | GENERATED |
	  | city        | GENERATED |
	  | latitude    | GENERATED |
	  | longitude   | GENERATED |
	Given API Operator creates 2 new Hub using data below:
	  | name         | GENERATED |
	  | displayName  | GENERATED |
	  | facilityType | STATION   |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	And API Operator reloads hubs cache
	And API Operator refresh Airports cache
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	And API Operator put created parcel to shipment
	And API Operator closes the created shipment
	Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	And API Operator link mawb for following shipment ids
	  | mawb                 | RANDOM                           |
	  | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
	  | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
	  | vendorId             | {vendor-id}                      |
	Given API Operator create 2 new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	Given API Operator create new air trip with data below:
	  | airtripType         | TO_FROM_AIRPORT_TRIP                 |
	  | originFacility      | {KEY_LIST_OF_CREATED_HUBS[1].id}     |
	  | destinationFacility | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
	And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Given API Operator create new air trip with data below:
	  | airtripType         | FLIGHT_TRIP                          |
	  | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
	  | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
	  | flight_no           | NLI12345                             |
	Given Operator go to menu Inter-Hub -> Airport Trip Management
	And Operator verifies that the Airport Management Page is opened
	When Operator fill the departure date for Airport Management
	  | startDate | {gradle-next-0-day-yyyy-MM-dd} |
	  | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
	When Operator fill the Origin Or Destination for Airport Management
	  | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} |
	And Operator click on 'Load Trips' on Airport Management
	Then Verify the parameters of loaded trips in Airport Management
	  | startDate           | {gradle-next-0-day-yyyy-MM-dd}                       |
	  | endDate             | {gradle-next-1-day-yyyy-MM-dd}                       |
	  | originOrDestination | {KEY_CREATED_AIRPORT_LIST[1].airport_code} (Airport) |
	Given Operator assigns MAWB to flight trip with data below:
	  | tripID | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} |
	  | vendor | {vendor-name}                              |
	  | mawb   | {KEY_LIST_OF_CREATED_MAWB[1]}              |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
	  | inboundType          | Into Van                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
	  | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[1].airport_name}                                                                                      |
	And Operator click start inbound
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
	When Operator clicks end inbound button
	And Operator clicks proceed in end inbound dialog "Van Inbound"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Transit to Airport                   |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When API Operator arrive trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with trip with data below:
	  | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
	  | actionType | ADD                                        |
	  | scanType   | SHIPMENT_HUB_INBOUND                       |
	When API Operator complete trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
	Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with data below:
	  | systemId | sg                                         |
	  | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
	  | scanType | shipment_hub_inbound                       |
	  | driverId | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Handed over to Airline               |
	When API Operator depart flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
	When API Operator arrive flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
	Given API Operator create new air trip with data below:
	  | airtripType         | TO_FROM_AIRPORT_TRIP                 |
	  | originFacility      | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
	  | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[2].id}     |
	And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
	Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with trip with data below:
	  | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
	  | actionType | ADD                                        |
	  | scanType   | SHIPMENT_VAN_INBOUND                       |
	Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with data below:
	  | systemId | sg                                         |
	  | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
	  | scanType | shipment_van_inbound                       |
	  | driverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
	When API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Transit                              |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	And API Operator put created parcel to shipment
	And API Operator performs hub inbound by updating shipment status using data below:
	  | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
	  | hubCountry | SG                                   |
	  | hubId      | {KEY_LIST_OF_CREATED_HUBS[2].id}     |
	And API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[2].id} } |
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
	  | inboundType          | Into Hub                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
	  | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[2].airport_name}                                                                                      |
	And Operator click start inbound
	And Operator click proceed in trip completion dialog
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
	And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[2]}"
	Then Click on Yes, continue on dialog box
	When Operator clicks end inbound button
	When Operator clicks proceed in end inbound dialog "Hub Inbound"
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                             |
	  | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
	  | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}   |
	  | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}   |
	  | status       | Completed                            |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op