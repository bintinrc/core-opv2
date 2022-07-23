@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithTrip6 @CWF
Feature: Shipment Hub Inbound With Trip Scanning 6

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Scan Pending Air Haul Shipment in Shipment's Destination Hub - Hub Inbound into Land Haul Trip (uid:7bdff44d-eea7-4054-a443-fceee8c84841)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator assign driver to movement trip schedule
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator verifies message "You cannot start shipment inbound because the selected trip hasn’t arrived at the destination. Do you want to confirm arrival of this trip now?" show on dialog
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Destination reached. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#cef0cc"
    And Operator verifies Scanned Shipment "{KEY_CREATED_SHIPMENT_ID}" exist color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Hub Inbound"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Hub Inbound has ended" is shown on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Completed                     |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_HUB_INBOUND(OpV2)         |
      | result | Completed                     |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source | PATH_RECALCULATION |
      | status | FAILED         |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths @RT
  Scenario: Scan Closed Air Haul Shipment in Shipment's Destination Hub - Hub Inbound into Land Haul Trip (uid:093daade-16dc-473b-b96a-cccae0b65c79)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
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
      | shipmentType | Air Haul                          |
      | shipmentId   | {KEY_CREATED_SHIPMENT_ID}          |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    And Operator verifies message "You cannot start shipment inbound because the selected trip hasn’t arrived at the destination. Do you want to confirm arrival of this trip now?" show on dialog
    And Operator click proceed in trip completion dialog
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Destination reached. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#cef0cc"
    And Operator verifies Scanned Shipment "{KEY_CREATED_SHIPMENT_ID}" exist color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Hub Inbound"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Hub Inbound has ended" is shown on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Completed                     |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_HUB_INBOUND(OpV2)         |
      | result | Completed                          |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator refresh page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | ADD_TO_HUB_INBOUND         |
      | result | Closed                     |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator refresh page
    Then Operator verify movement event on Shipment Details page using data below:
      | source | PATH_RECALCULATION |
      | status | FAILED         |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
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
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Hub Inbound"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Hub Inbound has ended" is shown on Shipment Inbound Scanning page
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
      | source | SHIPMENT_HUB_INBOUND(OpV2)         |
      | result | Completed                          |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | qa@ninjavan.co                     |
    And Operator verifies event is present for order on Edit order page
      | eventName         | SHIPMENT COMPLETED                 |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[2].id}   |
      | descriptionString | Shipment {KEY_CREATED_SHIPMENT_ID} |

  @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Hub Start Inbound - Trip Completion Dialog for Transit Trip (uid:7a8aa0d0-09cd-482f-b9ea-bef4ec569eea)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
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
    And Capture the toast with message is shown on Shipment Inbound Scanning page
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
      | userId | qa@ninjavan.co |
    And Operator close current window and switch to Shipment management page

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Closed Shipment From Another Country to Hub Inbound (uid:3abba664-7cd2-4d17-af97-e3aa384f99d5)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Set constant order for Indonesia:
      | constantOrder  | {indonesia-default-order} |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan and close shipment with data below:
      | origHubName  | {hub-name-temp}         |
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
      | userId | qa@ninjavan.co |
    And Operator close current window and switch to Shipment management page

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Cancelled Shipment From Another Country to Hub Inbound (uid:8cc04fcd-6d84-42f5-bf40-52c57980fd62)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Capture the toast with message is shown on Shipment Inbound Scanning page
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
      | userId | qa@ninjavan.co |
    And Operator close current window and switch to Shipment management page



  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op