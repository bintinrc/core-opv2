@Hub @E2EAirhaulShipmentInboundWithTrip
Feature: E2E Airhaul Shipment With Trip

  @LaunchBrowser @ShouldAlwaysRun @runthis
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Hub Inbound Air Haul Shipment at Shipment Destination Hub with Airport to Warehouse Trip - Success Delivery - e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator create 2 new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create 2 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}       |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | shipmentType   | Air Haul                              |
      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | vendorId             | {vendor-id}                      |
    And Operator close shipment on Add to Shipment page
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
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    And Operator clicks end inbound button
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Transit to Airport                    |
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
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Handed over to Airline                |
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
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Transit                               |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[2].airport_name}                                                                                      |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    Then Operator verifies shipment to go with trip is shown with total "1"
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    When Operator clicks end inbound button
    When Operator clicks proceed in end inbound dialog "Hub Inbound"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Completed                             |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | overrideSize | S                                  |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator make sure size changed to "S"
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Hub Inbound Air Haul Shipment at Shipment Destination Hub with Airport to Warehouse Trip - Fail Delivery - e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator create 2 new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create 2 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}       |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | shipmentType   | Air Haul                              |
      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | vendorId             | {vendor-id}                      |
    And Operator close shipment on Add to Shipment page
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
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    And Operator clicks end inbound button
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Transit to Airport                    |
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
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Handed over to Airline                |
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
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Transit                               |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[2].airport_name}                                                                                      |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    Then Operator verifies shipment to go with trip is shown with total "1"
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    When Operator clicks end inbound button
    When Operator clicks proceed in end inbound dialog "Hub Inbound"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Completed                             |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | overrideSize | S                                  |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator make sure size changed to "S"
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_FAIL"
    And Operator verify order status is "Delivery fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Hub Inbound Air Haul Shipment at Shipment Destination Hub with Airport to Warehouse Trip - Reversion Fail Delivery to Success - e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator create 2 new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create 2 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}       |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | shipmentType   | Air Haul                              |
      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | vendorId             | {vendor-id}                      |
    And Operator close shipment on Add to Shipment page
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
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    And Operator clicks end inbound button
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Transit to Airport                    |
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
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Handed over to Airline                |
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
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Transit                               |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[2].airport_name}                                                                                      |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    Then Operator verifies shipment to go with trip is shown with total "1"
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    When Operator clicks end inbound button
    When Operator clicks proceed in end inbound dialog "Hub Inbound"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                              |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status       | Completed                             |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | overrideSize | S                                  |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator make sure size changed to "S"
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver fail all created parcels successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_FAIL"
    And Operator verify order status is "Delivery fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    When API Driver Reversion Failed Delivery to Success
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteCreatedMAWBs @DeleteCreatedAirports @DeleteAirportsViaAPI
  Scenario: Hub Inbound Stayover Air Haul Shipment at Shipment Destination Hub with Airport to Warehouse Trip - Success Delivery - e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator creates 3 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator create 2 new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    And API Operator refresh Airports cache
    Given API Operator create 3 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[1].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[4].id}"
    Given API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 1
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 2
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[2].id} } |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP                 |
      | originFacility      | {KEY_LIST_OF_CREATED_HUBS[3].id}     |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                          |
      | originFacility      | {KEY_CREATED_AIRPORT_LIST[1].hub_id} |
      | destinationFacility | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
      | flight_no           | NLI12345                             |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[4].id}
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM                           |
      | destinationAirportId | {KEY_CREATED_AIRPORT_LIST[2].id} |
      | originAirportId      | {KEY_CREATED_AIRPORT_LIST[1].id} |
      | vendorId             | {vendor-id}                      |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}       |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[4].name}    |
      | shipmentType   | Air Haul                              |
      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator close shipment on Add to Shipment page
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | tripID | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[4]} |
      | vendor | {vendor-name}                              |
      | mawb   | {KEY_LIST_OF_CREATED_MAWB[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    And Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
#    And Operator click start inbound
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    When Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    And Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].id} - {KEY_LIST_OF_CREATED_HUBS[3].name}                                                           |
#      | inboundType          | Into Hub                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
#    And Operator click start inbound
#    And Operator click proceed in trip completion dialog
#    Then Operator verifies shipment to go with trip is shown with total "1"
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    When Operator clicks end inbound button
#    When Operator clicks proceed in end inbound dialog "Hub Inbound"
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    Then Operator verify parameters of shipment on Shipment Management page:
#      | shipmentType | AIR_HAUL                              |
#      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
#      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[4].name}    |
#      | status       | At Transit Hub                        |
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    And Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].id} - {KEY_LIST_OF_CREATED_HUBS[3].name}                                                           |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[1].airport_name}                                                                                      |
#    And Operator click start inbound
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    When Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    Then Operator verify parameters of shipment on Shipment Management page:
#      | shipmentType | AIR_HAUL                              |
#      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
#      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[4].name}    |
#      | status       | Transit to Airport                    |
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    When API Operator arrive trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
#    Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with trip with data below:
#      | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
#      | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}      |
#      | actionType | ADD                                        |
#      | scanType   | SHIPMENT_HUB_INBOUND                       |
#    When API Operator complete trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
#    Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[1].hub_id}" with data below:
#      | systemId | sg                                         |
#      | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
#      | scanType | shipment_hub_inbound                       |
#      | driverId | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
#    Then Operator verify parameters of shipment on Shipment Management page:
#      | shipmentType | AIR_HAUL                                   |
#      | id           | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
#      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}         |
#      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[4].name}         |
#      | status       | Handed over to Airline                     |
#    When API Operator depart flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
#    When API Operator arrive flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
#    Given API Operator create new air trip with data below:
#      | airtripType         | TO_FROM_AIRPORT_TRIP                 |
#      | originFacility      | {KEY_CREATED_AIRPORT_LIST[2].hub_id} |
#      | destinationFacility | {KEY_LIST_OF_CREATED_HUBS[4].id}     |
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[3].id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
#    Given API Operator shipment inbound scan in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with trip with data below:
#      | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
#      | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}      |
#      | actionType | ADD                                        |
#      | scanType   | SHIPMENT_VAN_INBOUND                       |
#    Then API Operator end shipment inbound with trip in hub id "{KEY_CREATED_AIRPORT_LIST[2].hub_id}" with data below:
#      | systemId | sg                                         |
#      | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
#      | scanType | shipment_van_inbound                       |
#      | driverId | {KEY_LIST_OF_CREATED_DRIVERS[3].id}        |
#    When API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    Then Operator verify parameters of shipment on Shipment Management page:
#      | shipmentType | AIR_HAUL                              |
#      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
#      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[4].name}    |
#      | status       | Transit                               |
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    And Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
#      | inboundType          | Into Hub                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
#      | movementTripSchedule | {KEY_CREATED_AIRPORT_LIST[2].airport_name}                                                                                      |
#    And Operator click start inbound
#    And Operator click proceed in trip completion dialog
#    Then Operator verifies shipment to go with trip is shown with total "1"
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    When Operator clicks end inbound button
#    When Operator clicks proceed in end inbound dialog "Hub Inbound"
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    Then Operator verify parameters of shipment on Shipment Management page:
#      | shipmentType | AIR_HAUL                              |
#      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
#      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[4].name}    |
#      | status       | Completed                             |

  @KillBrowser @ShouldAlwaysRun @runthis
  Scenario: Kill Browser
    Given no-op