@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithTrip5
Feature: Shipment Hub Inbound With Trip Scanning 5

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Remove Shipment From Hub Inbounded List (uid:fe33b7eb-a7c9-494f-b61e-abb128865383)
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
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator assign driver to movement trip schedule
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan and close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | shipmentType | Land Haul                          |
      | shipmentId   | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
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
    And Operator verifies Scan Shipment Container color is "#cef0cc"
    And Operator verifies Scanned Shipment "{KEY_CREATED_SHIPMENT_ID}" exist color is "#e1f6e0"
    And Operator enter shipment with id "{KEY_CREATED_SHIPMENT_ID}" in remove shipment
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is successfully removed" is shown on Shipment Inbound Scanning page
    And Operator verifies shipment counter is "0"
    Then Operator verify small message "Successfuly Removed. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Remove Shipment Container

  @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Hub Start Inbound - Trip Completion Dialog for Transit Trip (uid:7a8aa0d0-09cd-482f-b9ea-bef4ec569eea)
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
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    And Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} has arrived." is shown on Shipment Inbound Scanning page
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType    | SHIPMENT HUB INBOUND                                                                                                            |
      | driver         | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |

  @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Hub Start Inbound - No Trip Completion Dialog for Arrived Trip (uid:dd213e6d-f654-432f-8e6e-02713bf0115b)
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
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And API Operator arrival trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType    | SHIPMENT HUB INBOUND                                                                                                            |
      | driver         | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Pending Shipment From Another Country to Hub Inbound (uid:9d27846c-0adc-4f0d-9c8d-c73d7dd68075)
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
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator change the country to "Indonesia"
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
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
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Mismatched hub system ID: shipment destination hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Utilities -> QRCode Printing
    And Operator go to menu Inter-Hub -> Shipment Management
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
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_CREATED |
      | result | Pending          |
      | userId | qa@ninjavan.co   |
    And Operator close current window and switch to Shipment management page

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Closed Shipment From Another Country to Hub Inbound (uid:3abba664-7cd2-4d17-af97-e3aa384f99d5)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator change the country to "Singapore"
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
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator change the country to "Indonesia"
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Set constant order for Indonesia:
      | constantOrder | {indonesia-default-order} |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan and close shipment with data below:
      | origHubName  | {hub-name-temp}           |
      | destHubName  | {hub-name-temp-2}         |
      | shipmentType | Air Haul                  |
      | shipmentId   | {KEY_CREATED_SHIPMENT_ID} |
    And Operator refresh page
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
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Mismatched hub system ID: shipment destination hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Utilities -> QRCode Printing
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Closed                    |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_CLOSED |
      | result | Closed          |
      | userId | qa@ninjavan.co  |
    And Operator close current window and switch to Shipment management page

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Cancelled Shipment From Another Country to Hub Inbound (uid:8cc04fcd-6d84-42f5-bf40-52c57980fd62)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator change the country to "Singapore"
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
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator change the country to "Indonesia"
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
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
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Mismatched hub system ID: shipment destination hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Utilities -> QRCode Printing
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Cancelled                 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_CANCELLED |
      | result | Cancelled          |
      | userId | qa@ninjavan.co     |
    And Operator close current window and switch to Shipment management page

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Completed Shipment From Another Country to Hub Inbound (uid:911c9382-f4d5-497b-831c-8acddc793454)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator change the country to "Singapore"
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
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    When Operator change the country to "Indonesia"
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    And API Operator change the status of the shipment into "Completed"
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
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Mismatched hub system ID: shipment destination hub system ID id and scan hub system ID sg are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Utilities -> QRCode Printing
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Completed                 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_FORCE_COMPLETED |
      | result | Completed                |
      | userId | qa@ninjavan.co           |
    And Operator close current window and switch to Shipment management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op