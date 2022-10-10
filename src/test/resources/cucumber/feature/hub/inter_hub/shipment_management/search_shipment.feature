@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @SearchShipment
Feature: Shipment Management - Search Shipment

  @LaunchBrowser @ShouldAlwaysRun @runthis
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Shipment by ID - Search <= 30 Shipments with Invalid Shipment (uid:bc7c0cdf-fbcb-4db2-8c0d-a16b39e617a5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 2 shipment IDs
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
      | 111111111                            |
    Then Operator verifies that search error modal shown with shipment ids:
      | 111111111 |
    And Operator click Show Shipments button in Search Error dialog on Shipment Management Page
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |

  Scenario: Search Shipment by ID - Search <= 30 Shipments with Empty Line (uid:a2945cf0-7404-427f-80f9-7feb06288d75)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 2 shipment IDs
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {empty}                              |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |

  @DeleteFilterTemplate
  Scenario: Preset Setting - Save Current Shipment Filter as Preset (uid:81c46be2-466f-4c5f-b7ba-d1f15d05ddc9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator apply filters on Shipment Management Page:
      | originHub      | {hub-name}   |
      | destinationHub | {hub-name-2} |
    And Operator save current filters as preset on Shipment Management page
    And Operator refresh page
    Then Operator select created filters preset on Shipment Management page
    And Operator verify selected filters on Shipment Management page:
      | originHub      | {hub-name}   |
      | destinationHub | {hub-name-2} |

  @DeleteFilterTemplate
  Scenario: Preset Setting - Delete Shipment Filter as Preset (uid:c722664d-4ef4-4f13-92d6-5074a3dde4f5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator save current filters as preset on Shipment Management page
    And Operator delete created filters preset on Shipment Management page
    And Operator refresh page
    Then Operator verify filters preset was deleted

  @DeleteShipment
  Scenario Outline: Search Shipment by Filter - <scenarioName>
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator apply filters on Shipment Management Page:
      | <filterName> | <filterValue> |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |
    Examples:
      | scenarioName    | filterName     | filterValue  |
      | Origin Hub      | originHub      | {hub-name}   |
      | Destination Hub | destinationHub | {hub-name-2} |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Type : Air Haul
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Air Haul |
      | shipmentStatus | Pending  |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Type : Land Haul
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Land Haul |
      | shipmentStatus | Pending   |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | LAND_HAUL                 |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Type : Sea Haul
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "SEA_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Sea Haul |
      | shipmentStatus | Pending  |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | SEA_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Type : Others
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "OTHERS" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | Others  |
      | shipmentStatus | Pending |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | OTHERS                    |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Status : Pending
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Pending                |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Status : Closed
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator put created parcel to shipment
    And API Operator closes the created shipment
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Closed                 |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Closed                    |
      | origHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Status : Transit
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator put created parcel to shipment
    And API Operator closes the created shipment
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id}                  |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Transit                |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Transit                   |
      | origHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment @DeleteDriver @DeleteCreatedAirports @DeleteAirportsViaAPI @CancelTrip
  Scenario: Search Shipment by Filter - Shipment Status : Transit To Airport
    Given API Operator create new airport using data below:
      | system_id   | SG        |
      | airportCode | GENERATED |
      | airportName | GENERATED |
      | city        | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator refresh Airports cache
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator put created parcel to shipment
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
    And Operator click on 'Create Tofrom Airport Trip' button in Airport Management page
    And Operator create new airport trip using below data:
      | originFacility      | {hub-name}                                |
      | destinationFacility | {airport-name-1}                          |
      | departureTime       | 12:00                                     |
      | durationhour        | 01                                        |
      | durationminutes     | 55                                        |
      | departureDate       | {gradle-next-1-day-yyyy-MM-dd}            |
      | drivers             | {KEY_LIST_OF_CREATED_DRIVERS[1].username} |
      | comments            | Created by Automation                     |
    And Verify the new airport trip "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} from {hub-name} (Warehouse) to {airport-name-1} (Airport) is created. View Details" created success message
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id} - {hub-name}                                                                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | To ABC Test Airport                                                                                                             |
    And Operator click start inbound
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Transit To Airport     |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Transit to Airport        |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Status : Completed
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator put created parcel to shipment
    And API Operator performs hub inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id-2}                |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Completed              |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Completed                 |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Status : Cancelled
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Cancelled              |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Cancelled                 |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Date
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentDate | {gradle-previous-1-day-yyyy-MM-dd}:00:00,{gradle-current-date-yyyy-MM-dd}:23:30 |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  Scenario: Search Shipment by ID - Search <= 30 Shipments Separated by Coma (,) or Space (uid:373d0602-6f7f-4669-afbb-e606dc6fa5d2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 2 shipment IDs
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | ,                                    |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verifies that error react notification displayed:
      | top    | SERVER_ERROR_EXCEPTION                                                     |
      | bottom | ^.*Error Message: Cannot parse parameter id as Long: For input string: "," |

  @DeleteShipment
  Scenario: Shipment Details (uid:839a572a-8534-4456-8340-b615174dc29c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    And Operator click "Load All Selection" on Shipment Management page
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment

  @KillBrowser @ShouldAlwaysRun @runthis
  Scenario: Kill Browser
    Given no-op