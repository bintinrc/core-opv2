@OperatorV2 @HappyPath @Hub @InterHub @ShipmentInboundScanning @VanInbound @WithTrip
Feature: Shipment Van Inbound With Trip Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI
  Scenario: Start Van Inbound After Select Driver and Trip (uid:b9598c79-7362-4022-9db1-89550e0d5d4d)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
      | inboundType    | Into Van                                                                                    |
      | driver         | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator verifies shipment counter is "1"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI
  Scenario: View Transit Shipment To Go With Trip for Van Inbound (uid:b25c140f-1f09-4aaf-a602-3606a95e0e15)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "STATIONS" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
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
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
    And Operator click start inbound
    Then Operator verifies shipment to go with trip is shown with total "1"
    When Operator clicks shipment to go with trip
    Then Operator verifies shipment with trip with data below:
      | shipmentCount  | 1                                  |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | dropOffHub     | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | comments       | Shipment added to trip             |
    When Operator clicks shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies it will direct to shipment details page for shipment "{KEY_CREATED_SHIPMENT_ID}"

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI
  Scenario: Van Inbound Scan for Pending Shipment In Shipment's Origin Hub (uid:b28b3541-8d56-462a-b525-1575b1aa6997)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
      | inboundType    | Into Van                                                                                    |
      | driver         | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} has departed." is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    Then Operator verifies movement trip shown has status value "transit"
    And Operator verifies trip has departed
    And Operator verifies event "departed" with status "transit" is present for trip on Trip events page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | automation@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | HUB INBOUND SCAN                                  |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in trip_shipment_scans table

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI
  Scenario: Remove Shipment From Van Inbounded List (uid:d64807fc-8bb0-46a4-9ce7-518f7052d266)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    When Operator remove scanned shipment from remove button in scanned shipment table
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is successfully removed" is shown on Shipment Inbound Scanning page
    And Operator verifies shipment counter is "0"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @ForceSuccessOrder
  Scenario: Scan Correct MAWB to Van Inbound (uid:06042018-e5ee-4c19-b7fb-ef7b2650191a)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Shipper create V4 order using data below:
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
    And API Operator assign mawb "mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" to following shipmentIds
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_SHIPMENT_AWB}"
    Then Operator verify small message "Scan successful. MAWB: {KEY_SHIPMENT_AWB}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "2"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" exist color is "#e1f6e0"
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" exist color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} has departed." is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    Then Operator verifies movement trip shown has status value "transit"
    And Operator verifies trip has departed
    And Operator verifies event "departed" with status "transit" is present for trip on Trip events page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | status      | Transit                               |
    And Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | status      | Transit                               |
    Then Operator verifies event is present for shipment on Shipment Detail page
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | automation@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | HUB INBOUND SCAN                                  |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appear in trip_shipment_scans table
    Then DB Operator verify path for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appear in trip_shipment_scans table

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI
  Scenario: Scan to  Remove Shipment at Van Inbound (uid:c4b4a1d7-b81e-42d8-87b6-94fe372b5839)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    And Operator enter shipment with id "{KEY_CREATED_SHIPMENT_ID}" in remove shipment
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is successfully removed" is shown on Shipment Inbound Scanning page
    And Operator verifies shipment counter is "0"
    Then Operator verify small message "Successfuly Removed. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Remove Shipment Container

    # TODO: IMPLEMENT ME
  Scenario: Van Inbound Scan for Trip with Driver(s) in Transit for Different Trips (Validation at End Inbound) (uid:ff970b91-5463-456e-894e-8c3e6163a0eb)
    Given no-op

    # TODO: IMPLEMENT ME
  Scenario: Van Inbound Scan for Trip with Driver(s) in Transit for Different Trips (Validation at Start Inbound) (uid:c35030b6-81b6-4481-9938-cf9123594758)
    Given no-op

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op