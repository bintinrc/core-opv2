@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithTripAirHaul2
Feature: Air Haul Shipment Hub Inbound With Trip Scanning 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @DeleteDriver @DeleteCreatedMAWBs @CancelTrip
  Scenario: Scan Transit Air Haul Shipment in Shipment's Transit Hub - Hub Inbound with Airport to Warehouse Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {local-station-1-id} to hub id = {local-station-2-id}
    And API Operator put created parcel to shipment
    And API Operator closes the created shipment
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM               |
      | destinationAirportId | {local-airport-2-id} |
      | originAirportId      | {local-airport-1-id} |
      | vendorId             | {vendor-id}          |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP     |
      | originFacility      | {local-station-1-id}     |
      | destinationFacility | {local-airport-1-hub-id} |
    And API Operator assign driver "{local-driver-1-id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | NLI12345                 |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP     |
      | originFacility      | {local-airport-2-hub-id} |
      | destinationFacility | {local-crossdock-1-id}   |
    And API Operator assign driver "{local-driver-2-id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {local-station-1-id} - {local-station-1-name}            |
      | inboundType          | Into Van                                                 |
      | driver               | {local-driver-1-displayname} ({local-driver-1-username}) |
      | movementTripSchedule | {local-airport-1-name}                                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator arrive trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    Given API Operator shipment inbound scan in hub id "{local-airport-1-hub-id}" with trip with data below:
      | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
      | actionType | ADD                                        |
      | scanType   | SHIPMENT_HUB_INBOUND                       |
    When API Operator complete trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    Then API Operator end shipment inbound with trip in hub id "{local-airport-1-hub-id}" with data below:
      | systemId | sg                                         |
      | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | scanType | shipment_hub_inbound                       |
      | driverId | {local-driver-1-id}                        |
    When API Operator depart flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
    When API Operator arrive flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
    Given API Operator shipment inbound scan in hub id "{local-airport-2-hub-id}" with trip with data below:
      | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
      | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
      | actionType | ADD                                        |
      | scanType   | SHIPMENT_VAN_INBOUND                       |
    Then API Operator end shipment inbound with trip in hub id "{local-airport-2-hub-id}" with data below:
      | systemId | sg                                         |
      | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
      | scanType | shipment_van_inbound                       |
      | driverId | {local-driver-2-id}                        |
    When API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {local-crossdock-1-id} - {local-crossdock-1-name}        |
      | inboundType          | Into Hub                                                 |
      | driver               | {local-driver-2-displayname} ({local-driver-2-username}) |
      | movementTripSchedule | {local-airport-2-name}                                   |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
    When Operator clicks end inbound button
    When Operator clicks proceed in end inbound dialog "Hub Inbound"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                             |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | origHubName  | {local-station-1-id}                 |
      | destHubName  | {local-station-2-id}                 |
      | status       | Completed                            |

  @DeleteShipment @DeleteDriver @DeleteCreatedMAWBs @CancelTrip
  Scenario: Scan Cancelled Air Haul Shipment in Shipment's Transit Hub - Hub Inbound with Airport to Warehouse Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {local-station-1-id} to hub id = {local-station-2-id}
    And API Operator put created parcel to shipment
    And API Operator closes the created shipment
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM               |
      | destinationAirportId | {local-airport-2-id} |
      | originAirportId      | {local-airport-1-id} |
      | vendorId             | {vendor-id}          |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP     |
      | originFacility      | {local-station-1-id}     |
      | destinationFacility | {local-airport-1-hub-id} |
    And API Operator assign driver "{local-driver-1-id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP              |
      | originFacility      | {local-airport-1-hub-id} |
      | destinationFacility | {local-airport-2-hub-id} |
      | flight_no           | NLI12345                 |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP     |
      | originFacility      | {local-airport-2-hub-id} |
      | destinationFacility | {local-crossdock-1-id}   |
    And API Operator assign driver "{local-driver-2-id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {local-station-1-id} - {local-station-1-name}            |
      | inboundType          | Into Van                                                 |
      | driver               | {local-driver-1-displayname} ({local-driver-1-username}) |
      | movementTripSchedule | {local-airport-1-name}                                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator arrive trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    Given API Operator shipment inbound scan in hub id "{local-airport-1-hub-id}" with trip with data below:
      | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
      | actionType | ADD                                        |
      | scanType   | SHIPMENT_HUB_INBOUND                       |
    When API Operator complete trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
    Then API Operator end shipment inbound with trip in hub id "{local-airport-1-hub-id}" with data below:
      | systemId | sg                                         |
      | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | scanType | shipment_hub_inbound                       |
      | driverId | {local-driver-1-id}                        |
    When API Operator depart flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
    When API Operator arrive flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
    Given API Operator shipment inbound scan in hub id "{local-airport-2-hub-id}" with trip with data below:
      | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
      | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
      | actionType | ADD                                        |
      | scanType   | SHIPMENT_VAN_INBOUND                       |
    Then API Operator end shipment inbound with trip in hub id "{local-airport-2-hub-id}" with data below:
      | systemId | sg                                         |
      | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
      | scanType | shipment_van_inbound                       |
      | driverId | {local-driver-2-id}                        |
    When API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
    When API Operator change the status of the shipment into "Cancelled"
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {local-crossdock-1-id} - {local-crossdock-1-name}        |
      | inboundType          | Into Hub                                                 |
      | driver               | {local-driver-2-displayname} ({local-driver-2-username}) |
      | movementTripSchedule | {local-airport-2-name}                                   |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
    Then Click on Yes, continue on dialog box
    When Operator clicks end inbound button
    When Operator clicks proceed in end inbound dialog "Hub Inbound"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                             |
      | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | origHubName  | {local-station-1-id}                 |
      | destHubName  | {local-station-2-id}                 |
      | status       | Completed                            |

  @DeleteShipment @DeleteDriver @DeleteCreatedMAWBs @CancelTrip
  Scenario: Scan Completed Air Haul Shipment in Shipment's Transit Hub - Hub Inbound with Airport to Warehous Trip
      Given Operator go to menu Shipper Support -> Blocked Dates
      Given API Shipper create V4 order using data below:
        | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
        | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
      And API Operator create new shipment with type "AIR_HAUL" from hub id = {local-station-1-id} to hub id = {local-station-2-id}
      And API Operator put created parcel to shipment
      And API Operator closes the created shipment
      Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
      And API Operator link mawb for following shipment ids
        | mawb                 | RANDOM               |
        | destinationAirportId | {local-airport-2-id} |
        | originAirportId      | {local-airport-1-id} |
        | vendorId             | {vendor-id}          |
      Given API Operator create new air trip with data below:
        | airtripType         | TO_FROM_AIRPORT_TRIP     |
        | originFacility      | {local-station-1-id}     |
        | destinationFacility | {local-airport-1-hub-id} |
      And API Operator assign driver "{local-driver-1-id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
      Given API Operator create new air trip with data below:
        | airtripType         | FLIGHT_TRIP              |
        | originFacility      | {local-airport-1-hub-id} |
        | destinationFacility | {local-airport-2-hub-id} |
        | flight_no           | NLI12345                 |
      Given API Operator create new air trip with data below:
        | airtripType         | TO_FROM_AIRPORT_TRIP     |
        | originFacility      | {local-airport-2-hub-id} |
        | destinationFacility | {local-crossdock-1-id}   |
      And API Operator assign driver "{local-driver-2-id}" to airhaul trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
      Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
      And Operator fill Shipment Inbound Scanning page with data below:
        | inboundHub           | {local-station-1-id} - {local-station-1-name}            |
        | inboundType          | Into Van                                                 |
        | driver               | {local-driver-1-displayname} ({local-driver-1-username}) |
        | movementTripSchedule | {local-airport-1-name}                                   |
      And Operator click start inbound
      And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
      When Operator clicks end inbound button
      And Operator clicks proceed in end inbound dialog "Van Inbound"
      Given Operator go to menu Shipper Support -> Blocked Dates
      When API Operator arrive trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
      Given API Operator shipment inbound scan in hub id "{local-airport-1-hub-id}" with trip with data below:
        | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
        | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
        | actionType | ADD                                        |
        | scanType   | SHIPMENT_HUB_INBOUND                       |
      When API Operator complete trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
      Then API Operator end shipment inbound with trip in hub id "{local-airport-1-hub-id}" with data below:
        | systemId | sg                                         |
        | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
        | scanType | shipment_hub_inbound                       |
        | driverId | {local-driver-1-id}                        |
      When API Operator depart flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
      When API Operator arrive flight trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}"
      Given API Operator shipment inbound scan in hub id "{local-airport-2-hub-id}" with trip with data below:
        | tripId     | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
        | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}       |
        | actionType | ADD                                        |
        | scanType   | SHIPMENT_VAN_INBOUND                       |
      Then API Operator end shipment inbound with trip in hub id "{local-airport-2-hub-id}" with data below:
        | systemId | sg                                         |
        | tripId   | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} |
        | scanType | shipment_van_inbound                       |
        | driverId | {local-driver-2-id}                        |
      When API Operator depart trip "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}"
      Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
      And Operator fill Shipment Inbound Scanning page with data below:
        | inboundHub           | {local-crossdock-1-id} - {local-crossdock-1-name}        |
        | inboundType          | Into Hub                                                 |
        | driver               | {local-driver-2-displayname} ({local-driver-2-username}) |
        | movementTripSchedule | {local-airport-2-name}                                   |
      And Operator click start inbound
      And Operator click proceed in trip completion dialog
      And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}"
      Then Click on Yes, continue on dialog box
      When Operator clicks end inbound button
      When Operator clicks proceed in end inbound dialog "Hub Inbound"
      And Operator search shipments by given Ids on Shipment Management page:
        | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      Then Operator verify parameters of shipment on Shipment Management page:
        | shipmentType | AIR_HAUL                             |
        | id           | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
        | origHubName  | {local-station-1-id}                 |
        | destHubName  | {local-station-2-id}                 |
        | status       | Completed                            |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
