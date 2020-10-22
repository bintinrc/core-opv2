@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithTrip
Feature: Shipment Hub Inbound With Trip Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Invalid to Shipment Already Scanned (Duplicate Scan on Hub Inbound) (uid:461f477f-c49e-493a-811d-50e73389162f)
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
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                       |
      | inboundType          | Into Hub                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Destination reached. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment color is "#e1f6e0"
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies toast with message "Duplicate scan for shipment {KEY_CREATED_SHIPMENT_ID}" is shown on Shipment Inbound Scanning page

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Remove Shipment Not Expected For Hub Inbound (uid:702b9928-6e78-4a1a-b1e0-3f0e7e2247df)
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
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                       |
      | inboundType          | Into Hub                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator enter shipment with id "{KEY_CREATED_SHIPMENT_ID}" in remove shipment
    Then Operator verifies toast with message "There is no SHIPMENT_HUB_INBOUND scan for shipment {KEY_CREATED_SHIPMENT_ID} and trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}" is shown on Shipment Inbound Scanning page

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Scan Completed Shipment to Hub Inbound (uid:4e81d8c9-9c65-4818-991a-b6afdacdbdcd)
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
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator change the status of the shipment into "Completed"
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                       |
      | inboundType          | Into Hub                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is in terminal state: [Completed]" is shown on Shipment Inbound Scanning page

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Scan Cancelled Shipment to Hub Inbound (uid:7aea061e-08d2-46fc-9df1-fd92faed3f94)
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
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator change the status of the shipment into "Cancelled"
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                       |
      | inboundType          | Into Hub                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is in terminal state: [Cancelled]" is shown on Shipment Inbound Scanning page

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb @ForceSuccessOrder
  Scenario: Failed to scan MAWB to Hub Inbound (uid:472fd7d1-abcd-4e78-8e86-6220019f8756)
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
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator assign mawb "mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" to following shipmentIds
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_SHIPMENT_AWB}"
    Then Operator verify small message "Scan failed. MAWB: {KEY_SHIPMENT_AWB}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "2"
    And Operator verifies Scanned Shipment color is "#fe5c5c"

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb @ForceSuccessOrder
  Scenario: Success Scan MAWB Partially at Hub Inbound (uid:89e24f29-ad80-4a8a-ae49-de0ebbb14e1c)
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
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator assign mawb "mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" to following shipmentIds
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_SHIPMENT_AWB}"
    Then Operator verify small message "Partial Success. MAWB: {KEY_SHIPMENT_AWB}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "2"
    And Operator verifies Scan Shipment Container color is "#eaf4f9"
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" exist color is "#e1f6e0"
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" exist color is "#fe5c5c"

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb @ForceSuccessOrder
  Scenario: Scan Correct MAWB to Hub Inbound at Destination Hub (uid:88e76751-a121-4082-b727-a561e7972e0d)
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
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_SHIPMENT_AWB}"
    Then Operator verify small message "Scan successful. MAWB: {KEY_SHIPMENT_AWB}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "2"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" exist color is "#e1f6e0"
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" exist color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Hub Inbound"
    Then Operator verifies toast with message "Hub inbound has ended." is shown on Shipment Inbound Scanning page
    Then Operator verifies event is present for shipment on Shipment Detail page
      | source | SHIPMENT_HUB_INBOUND               |
      | result | Completed                          |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | automation@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | SHIPMENT COMPLETED                 |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[2].id}   |
      | descriptionString | Shipment                           |

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb @ForceSuccessOrder
  Scenario: Scan Correct MAWB to Hub Inbound at Transit Hub (uid:a5b22da0-6f93-4feb-ad16-10c08f5ebab2)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "STATIONS" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
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
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_SHIPMENT_AWB}"
    Then Operator verify small message "Scan successful. MAWB: {KEY_SHIPMENT_AWB}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "2"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" exist color is "#e1f6e0"
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" exist color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Hub Inbound"
    Then Operator verifies toast with message "Hub inbound has ended." is shown on Shipment Inbound Scanning page
    Then Operator verifies event is present for shipment on Shipment Detail page
      | source | SHIPMENT_HUB_INBOUND               |
      | result | At Transit Hub                     |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | automation@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | SHIPMENT VAN INBOUNDED                                                                             |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                 |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                                                                   |
      | descriptionString | Hub {KEY_LIST_OF_CREATED_HUBS[3].id} ({KEY_LIST_OF_CREATED_HUBS[3].name}) Hub Location Type ORIGIN |

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Start Hub Inbound After Select Driver and Trip (uid:026a1de3-00a4-4fb3-990e-5514ea40f19b)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                       |
      | inboundType          | Into Hub                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
      | inboundType    | Into Hub                                                                                    |
      | driver         | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Scan Correct Shipment to Destination Hub Inbound (uid:847aafe2-b443-4567-9ec3-5bbb2dc91c69)
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
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator put created parcel to shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Destination reached. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    And Operator verifies Scanned Shipment "{KEY_CREATED_SHIPMENT_ID}" exist color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Hub Inbound"
    Then Operator verifies toast with message "Hub inbound has ended." is shown on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Completed                          |
    Then Operator verifies event is present for shipment on Shipment Detail page
      | source | SHIPMENT_HUB_INBOUND               |
      | result | Completed                          |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | automation@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | SHIPMENT COMPLETED                 |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[2].id}   |
      | descriptionString | Shipment {KEY_CREATED_SHIPMENT_ID} |

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Scan Correct Shipment to Transit Hub Inbound (uid:f7dd1fb0-485a-4b1a-a3b2-cf1c786b5c9e)
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
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "STATIONS" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator put created parcel to shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "At transit hub. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    And Operator verifies Scanned Shipment "{KEY_CREATED_SHIPMENT_ID}" exist color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Hub Inbound"
    Then Operator verifies toast with message "Hub inbound has ended." is shown on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | status      | At Transit Hub                     |
    Then Operator verifies event is present for shipment on Shipment Detail page
      | source | SHIPMENT_HUB_INBOUND               |
      | result | At Transit Hub                     |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | automation@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | SHIPMENT VAN INBOUNDED                                                                             |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                 |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                                                                   |
      | descriptionString | Hub {KEY_LIST_OF_CREATED_HUBS[3].id} ({KEY_LIST_OF_CREATED_HUBS[3].name}) Hub Location Type ORIGIN |

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Scan Incorrect Shipment to Hub Inbound (uid:e0ebe28c-a18c-4c82-bb16-5c19932d1447)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                       |
      | inboundType          | Into Hub                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
      | inboundType    | Into Hub                                                                                    |
      | driver         | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
    And Operator scan shipment with id "INCORRECT_SHIPMENT"
    Then Operator verifies toast with message "Shipment INCORRECT_SHIPMENT can not be found." is shown on Shipment Inbound Scanning page
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Hub Inbound"
    Then Operator verifies toast with message "Hub inbound has ended." is shown on Shipment Inbound Scanning page

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: View Shipments To Unload for Hub Inbound (uid:95ed3788-2005-4b0b-ac45-4a706dec9f5e)
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
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    Then Operator verifies shipment to unload is shown with total "1"
    When Operator clicks shipment to unload
    Then Operator verifies shipment with trip with data below:
      | shipmentCount  | 1                                  |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | dropOffHub     | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | comments       | -                                  |
      | inboundType    | Into Hub                           |
    When Operator clicks shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies it will direct to shipment details page for shipment "{KEY_CREATED_SHIPMENT_ID}"

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Scan to  Remove Shipment at Hub Inbound (uid:3423558a-2ed8-4a5a-8692-c2477a5ceeb5)
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
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                       |
      | inboundType          | Into Hub                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Destination reached. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator enter shipment with id "{KEY_CREATED_SHIPMENT_ID}" in remove shipment
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is successfully removed" is shown on Shipment Inbound Scanning page
    And Operator verifies shipment counter is "0"
    Then Operator verify small message "Successfuly Removed. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Remove Shipment Container

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Check whether Old Scan Message is Cleared after New Scan (Hub Inbound) (uid:6f6e795c-c893-4b56-b2d0-d11569e8bd53)
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
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                       |
      | inboundType          | Into Hub                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Destination reached. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator enter shipment with id "{KEY_CREATED_SHIPMENT_ID}" in remove shipment
    Then Operator verify small message "Successfuly Removed. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Remove Shipment Container
    And Operator verify small message "" appears in Shipment Inbound Box

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Scan Shipment to Hub Inbound with Different Driver for Next Trip (uid:5d4e9d41-ce9c-4fef-9176-2d54fa6eb62a)
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
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
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
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Shipment not listed. Remove shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment "{KEY_CREATED_SHIPMENT_ID}" exist color is "#fe5c5c"
    And Operator clicks end inbound button
    Then Operator verifies shipment with id "{KEY_CREATED_SHIPMENT_ID}" appears in error shipment dialog with result "Shipment not listed. Expected drop-off hub: {KEY_LIST_OF_CREATED_HUBS[2].name}."
    When Operator click proceed in error shipment dialog
    Then Operator verifies toast with message "Hub inbound has ended." is shown on Shipment Inbound Scanning page

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Missing Scan Shipment From Shipment to Unload List (uid:e050e36c-938c-454e-a99d-d785a696d282)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    When Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    Then Operator verify small message "Destination reached. Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" exist color is "#e1f6e0"
    And Operator clicks end inbound button
    Then Operator verifies shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appears in error shipment dialog with result "Shipment hasn't been scanned"
    When Operator click proceed in error shipment dialog
    Then Operator verifies toast with message "Hub inbound has ended." is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status      | Completed                             |
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status      | Transit                               |
    Then Operator verifies event is present for shipment id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Detail page
      | source | SHIPMENT_HUB_INBOUND               |
      | result | Completed                          |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | automation@ninjavan.co             |
    Then Operator verifies event is present for shipment id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" on Shipment Detail page
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | automation@ninjavan.co             |
    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER[1].id}" on Edit order page
      | eventName         | SHIPMENT COMPLETED                             |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[2].name}             |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[2].id}               |
      | descriptionString | Shipment {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER[2].id}" on Edit order page
      | eventName         | SHIPMENT VAN INBOUNDED                                                                             |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                 |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                                                                   |
      | descriptionString | Hub {KEY_LIST_OF_CREATED_HUBS[2].id} ({KEY_LIST_OF_CREATED_HUBS[2].name}) Hub Location Type ORIGIN |

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Scan Shipment with No Path Found (uid:75cb600a-19e8-4262-b1ff-2f2b5ca6a114)
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
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator put created parcel to shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "No path found. Remove shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment "{KEY_CREATED_SHIPMENT_ID}" exist color is "#fe5c5c"
    And Operator clicks end inbound button
    Then Operator verifies shipment with id "{KEY_CREATED_SHIPMENT_ID}" appears in error shipment dialog with result "No path found."
    When Operator click proceed in error shipment dialog
    Then Operator verifies toast with message "Hub inbound has ended." is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | status      | At Transit Hub                     |
    Then Operator verifies event is present for shipment id "{KEY_CREATED_SHIPMENT_ID}" on Shipment Detail page
      | source | SHIPMENT_HUB_INBOUND               |
      | result | At Transit Hub                     |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | automation@ninjavan.co             |
    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER[1].id}" on Edit order page
      | eventName         | SHIPMENT VAN INBOUNDED                                                                             |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                 |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                                                                   |
      | descriptionString | Hub {KEY_LIST_OF_CREATED_HUBS[3].id} ({KEY_LIST_OF_CREATED_HUBS[3].name}) Hub Location Type ORIGIN |

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Scan Shipment to Hub Inbound with Incorrect Drop Off Trip (uid:0513a12e-b252-4dbb-a00f-e3961dac2298)
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
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator put created parcel to shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Expected to stay in van. Remove shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment "{KEY_CREATED_SHIPMENT_ID}" exist color is "#fe5c5c"
    And Operator clicks end inbound button
    Then Operator verifies shipment with id "{KEY_CREATED_SHIPMENT_ID}" appears in error shipment dialog with result "Expected to stay in van. Expected drop-off hub: {KEY_LIST_OF_CREATED_HUBS[3].name}."
    When Operator click proceed in error shipment dialog
    Then Operator verifies toast with message "Hub inbound has ended." is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | status      | At Transit Hub                     |
    Then Operator verifies event is present for shipment id "{KEY_CREATED_SHIPMENT_ID}" on Shipment Detail page
      | source | SHIPMENT_HUB_INBOUND               |
      | result | At Transit Hub                     |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | automation@ninjavan.co             |
    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER[1].id}" on Edit order page
      | eventName         | SHIPMENT VAN INBOUNDED                                                                             |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                 |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                                                                   |
      | descriptionString | Hub {KEY_LIST_OF_CREATED_HUBS[3].id} ({KEY_LIST_OF_CREATED_HUBS[3].name}) Hub Location Type ORIGIN |

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: End Inbound with Missing Scanned and Unregistered Shipments (uid:0baf34aa-c3eb-4ae0-a3a0-57916fc91697)
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
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
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
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    When Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    Then Operator verify small message "No path found. Remove shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" exist color is "#fe5c5c"
    And Operator clicks end inbound button
    Then Operator verifies shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appears in error shipment dialog with result "Shipment hasn't been scanned" in "missing shipments"
    Then Operator verifies shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appears in error shipment dialog with result "No path found." in "unregistered shipments"
    When Operator click proceed in error shipment dialog
    Then Operator verifies toast with message "Hub inbound has ended." is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | status      | Transit                               |
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}    |
      | status      | At Transit Hub                        |
    Then Operator verifies event is present for shipment id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Detail page
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | automation@ninjavan.co             |
    Then Operator verifies event is present for shipment id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" on Shipment Detail page
      | source | SHIPMENT_HUB_INBOUND               |
      | result | At Transit Hub                     |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | automation@ninjavan.co             |
    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER[1].id}" on Edit order page
      | eventName         | SHIPMENT VAN INBOUNDED                                                                             |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                 |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                                                                   |
      | descriptionString | Hub {KEY_LIST_OF_CREATED_HUBS[2].id} ({KEY_LIST_OF_CREATED_HUBS[2].name}) Hub Location Type ORIGIN |
    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER[2].id}" on Edit order page
      | eventName         | SHIPMENT VAN INBOUNDED                                                                             |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                 |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                                                                   |
      | descriptionString | Hub {KEY_LIST_OF_CREATED_HUBS[3].id} ({KEY_LIST_OF_CREATED_HUBS[3].name}) Hub Location Type ORIGIN |

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Invalid to Scan Pending Shipment From Another Country to Hub Inbound (uid:9d27846c-0adc-4f0d-9c8d-c73d7dd68075)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator change the country to "Indonesia"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator change the country to "Singapore"
    And Operator refresh page
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies toast with message "Mismatched hub system ID: shipment destination hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Pending                   |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_CREATED       |
      | result | Pending                |
      | userId | automation@ninjavan.co |
    And Operator close current window and switch to Shipment management page

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Invalid to Scan Closed Shipment From Another Country to Hub Inbound (uid:3abba664-7cd2-4d17-af97-e3aa384f99d5)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator change the country to "Indonesia"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator close shipment with data below:
      | origHubName  | {hub-name-temp}           |
      | shipmentType | Air Haul                  |
      | shipmentId   | {KEY_CREATED_SHIPMENT_ID} |
    When Operator change the country to "Singapore"
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator refresh page
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies toast with message "Mismatched hub system ID: shipment destination hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Closed                    |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_CLOSED        |
      | result | Closed                 |
      | userId | automation@ninjavan.co |
    And Operator close current window and switch to Shipment management page

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Invalid to Scan Cancelled Shipment From Another Country to Hub Inbound (uid:8cc04fcd-6d84-42f5-bf40-52c57980fd62)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator change the country to "Indonesia"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator cancel the created shipment on Shipment Management page
    When Operator change the country to "Singapore"
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator refresh page
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies toast with message "Mismatched hub system ID: shipment destination hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Cancelled                 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_CANCELLED     |
      | result | Cancelled              |
      | userId | automation@ninjavan.co |
    And Operator close current window and switch to Shipment management page

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Invalid to Scan Completed Shipment From Another Country to Hub Inbound (uid:911c9382-f4d5-497b-831c-8acddc793454)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator change the country to "Indonesia"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator force success the created shipment on Shipment Management page
    When Operator change the country to "Singapore"
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator refresh page
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies toast with message "Mismatched hub system ID: shipment destination hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Completed                 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_FORCE_COMPLETED |
      | result | Completed                |
      | userId | automation@ninjavan.co   |
    And Operator close current window and switch to Shipment management page

  @DeleteShipment @DeleteDriver @DeleteHubsViaDb
  Scenario: Invalid to Scan Transit Shipment From Another Country to Hub Inbound (uid:476d787f-f99b-4375-a218-6893e319e440)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    When Operator change the country to "Indonesia"
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator create new Middle Mile Driver with details:
      | name   | hub           | contactNumber | licenseNumber | employmentType | username |
      | RANDOM | COUNTRY_BASED | 08176586525   | RANDOM        | FULL_TIME      | RANDOM   |
    And Operator refresh page
    Given Operator go to menu Hubs -> Facilities Management
    When Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED       |
      | displayName  | GENERATED       |
      | facilityType | CROSSDOCK       |
      | region       | Greater Jakarta |
      | city         | GENERATED       |
      | country      | ID              |
      | latitude     | GENERATED       |
      | longitude    | GENERATED       |
    And Operator refresh page
    And Operator refresh hubs cache on Facilities Management page
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | destinationHub | {hub-name-temp}                    |
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | schedules[1].originHub      | {KEY_LIST_OF_CREATED_HUBS[3].name}                            |
      | schedules[1].destinationHub | {hub-name-temp}                                               |
      | schedules[1].movementType   | Air Haul                                                      |
      | schedules[1].departureTime  | 15:15                                                         |
      | schedules[1].durationDays   | 1                                                             |
      | schedules[1].durationTime   | 16:30                                                         |
      | schedules[1].daysOfWeek     | all                                                           |
      | schedules[1].comment        | Created by automated test at {gradle-current-date-yyyy-MM-dd} |
    And Operator refresh page
    When Movement Management page is loaded
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | destinationHub | {hub-name-temp}                    |
    And Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].firstName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username})" to created movement schedule
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}                                  |
      | destHubName | {hub-name-temp}                                                     |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator refresh page
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                     |
      | inboundType          | Into Van                                                                               |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {hub-name-temp}                                                                        |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    And Operator refresh page
    When Operator change the country to "Singapore"
    And Operator refresh page
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies toast with message "Mismatched hub system ID: shipment destination hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | destHubName | {hub-name-temp}                    |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND   |
      | result | Transit                |
      | userId | automation@ninjavan.co |
    And Operator close current window and switch to Shipment management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op