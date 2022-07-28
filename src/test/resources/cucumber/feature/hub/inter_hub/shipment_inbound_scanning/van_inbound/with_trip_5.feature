@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @VanInbound @WithTrip5
Feature: Shipment Van Inbound With Trip Scanning 5

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan for Trip with Driver(s) in Transit for Same Trip (Validation at Start Inbound) (uid:8fbc0cd3-24fc-4634-8e99-e4a1725ca59d)
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    Given API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    And API Operator assign following drivers to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
      | primaryDriver    | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | additionalDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And API Operator assign following drivers to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
      | primaryDriver    | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | additionalDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
#    Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
#    And Operator close the shipment which has been created
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    Then Operator verifies toast bottom containing message "Driver {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}, {KEY_LIST_OF_CREATED_DRIVERS[2].firstName} is still in trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} from {KEY_LIST_OF_CREATED_HUBS[2].name} to {KEY_LIST_OF_CREATED_HUBS[1].name} with expected arrival time" is shown on Shipment Inbound Scanning page
    When Operator click force complete trip in shipment inbound scanning page
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} has completed" is shown on Shipment Inbound Scanning page
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType    | SHIPMENT VAN INBOUND                                                                        |
      | driver         | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#cef0cc"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} departed" is shown on Shipment Inbound Scanning page
#    When Operator go to menu Inter-Hub -> Movement Trips
#    And Operator verifies movement Trip page is loaded
#    And Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
#    And Operator clicks on Load Trip Button
#    Then Operator verifies movement trip shown has status value "transit" for trip id "{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}"
#    And Operator verifies trip has departed
#    And Operator verifies event "departed" with status "transit" is present for trip on Trip events page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co                     |
#    And Operator verifies event is present for order on Edit order page
#      | eventName         | HUB INBOUND SCAN                                  |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
#      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in trip_shipment_scans table

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan At Transit Hub Shipment with Stay-over Shipment (uid:a3a1027b-8526-48ba-96b2-e6f331040c49)
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create multiple 2 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[3].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator refresh page
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[3].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    Given API Operator shipment inbound scan all created shipments with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator arrival trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_HUB_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator complete trip with data below:
      | tripId | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | hubId  | {KEY_LIST_OF_CREATED_HUBS[2].id}           |
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_HUB_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
    And Operator click start inbound
    Then Operator verifies shipment to go with trip is shown with total "2"
    When Operator clicks shipment to go with trip
    Then Operator verifies shipment with trip with data below:
      | shipmentCount  | 2                                                             |
      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                         |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | dropOffHub     | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name}                            |
      | comments       | Stay in vehicle. Drop off: {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment color is "#e1f6e0"
    And Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}    |
      | status      | Transit                               |
    And Operator open the shipment detail for the shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co                     |
#    And Operator verifies event is present for order on Edit order page
#      | eventName         | HUB INBOUND SCAN                                  |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
#      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    And DB Operator verify unscanned shipment with following data:
      | shipmentId | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | type       | STAYOVER                              |
      | scanType   | SHIPMENT_VAN_INBOUND                  |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Invalid Scan Stay-over Shipment (uid:97a81421-c6f3-48e5-b5d5-6cfacbbd0fae)
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create multiple 2 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[3].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator refresh page
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[3].name}         |
      | shipmentType | Land Haul                                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}      |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    Given API Operator shipment inbound scan all created shipments with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator arrival trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_HUB_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator complete trip with data below:
      | tripId | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
      | hubId  | {KEY_LIST_OF_CREATED_HUBS[2].id}           |
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_HUB_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
    And Operator click start inbound
    Then Operator verifies shipment to go with trip is shown with total "2"
    When Operator clicks shipment to go with trip
    Then Operator verifies shipment with trip with data below:
      | shipmentCount  | 2                                                             |
      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                         |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                            |
      | dropOffHub     | {KEY_LIST_OF_CREATED_HUBS[2].name}                            |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name}                            |
      | comments       | Stay in vehicle. Drop off: {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment color is "#e1f6e0"
    When Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Duplicate scan for shipment {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" is shown on Shipment Inbound Scanning page

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Pending Shipment From Another Country to Van Inbound (uid:0e92d53f-103b-445a-90ce-4b3a88faa336)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator assign driver to movement trip schedule
    When Operator change the country to "Indonesia"
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator change the country to "Singapore"
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Mismatched hub system ID: shipment origin hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Utilities -> QRCode Printing
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Pending                   |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_CREATED |
      | result | Pending          |
      | userId | qa@ninjavan.co   |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Cancelled Shipment From Another Country to Van Inbound (uid:56226f31-bd34-4e44-a2ac-e3697a3fa8cb)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator assign driver to movement trip schedule
    When Operator change the country to "Indonesia"
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator cancel the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator change the country to "Singapore"
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Mismatched hub system ID: shipment origin hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Cancelled                 |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_CANCELLED |
      | result | Cancelled          |
      | userId | qa@ninjavan.co     |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Completed Shipment From Another Country to Van Inbound (uid:b929b5ef-13b3-46fc-bbd4-30a33ccafb6b)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator assign driver to movement trip schedule
    When Operator change the country to "Indonesia"
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    And API Operator change the status of the shipment into "Completed"
#    And Operator force success the created shipment on Shipment Management page
    When Operator change the country to "Singapore"
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Mismatched hub system ID: shipment origin hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Completed                 |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_FORCE_COMPLETED |
      | result | Completed                |
      | userId | qa@ninjavan.co           |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator change the country to "Singapore"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op