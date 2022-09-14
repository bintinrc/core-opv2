@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithTrip
Feature: Shipment Hub Inbound With Trip Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
#  Scenario: Hub Inbound Scan Stayover Shipment with different drop-off trip (uid:716ecf67-5763-4dd8-9cfe-fdfd99fb3e8f)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    When Operator change the country to "Singapore"
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    Given API Operator creates 2 new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | CROSSDOCK |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator creates 2 new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | STATION   |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator verify new Hubs are created
#    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
#    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[4].id}"
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    And API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[4].id}
#    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
#    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
#    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
#    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
#    Given API Operator shipment inbound scan all created shipments with data below:
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_VAN_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#    And Operator refresh page
#    And API Operator shipment end inbound with trip with data below:
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_VAN_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
#    And API Operator depart trip with data below:
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#    And Operator refresh page
#    And API Operator arrival trip with data below:
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#    Given API Operator shipment inbound scan with trip with data below:
#      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_HUB_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#    And Operator refresh page
#    And API Operator complete trip with data below:
#      | tripId | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} |
#      | hubId  | {KEY_LIST_OF_CREATED_HUBS[2].id}           |
#    And API Operator shipment end inbound with trip with data below:
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_HUB_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
#    And Operator refresh page
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
#    And Operator click start inbound
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
#    And Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    And Capture the toast with message is shown on Shipment Inbound Scanning page
#    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" is shown on Shipment Inbound Scanning page
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].id} - {KEY_LIST_OF_CREATED_HUBS[3].name}                                                           |
#      | inboundType          | Into Hub                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
#    And Operator click start inbound
#    And Operator click proceed in trip completion dialog
#    Then Operator verifies shipment to go with trip is shown with total "1"
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    Then Operator verify small message "Shipment not listed. Remove Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appears in Shipment Inbound Box
#    And Operator verifies Scanned Shipment color is "#fe5c5c"
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
#    Then Operator verify small message "Destination reached. Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appears in Shipment Inbound Box
#    And Operator clicks end inbound button
#    Then Operator verifies shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appears in error shipment dialog with result "Shipment not listed. Expected drop-off hub: {KEY_LIST_OF_CREATED_HUBS[2].name}."
#    When Operator click proceed in error shipment dialog
#    And Capture the toast with message is shown on Shipment Inbound Scanning page
#    Then Operator verifies toast with message "Hub Inbound has ended" is shown on Shipment Inbound Scanning page
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    Then Operator verify parameters of shipment on Shipment Management page:
#      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
#      | currHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}    |
#      | destHubName | {KEY_LIST_OF_CREATED_HUBS[4].name}    |
#      | status      | At Transit Hub                        |
#    And Operator open the shipment detail for the shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management Page
#    Then Operator verify shipment event on Shipment Details page:
#      | source | SHIPMENT_HUB_INBOUND(OpV2)         |
#      | result | At Transit Hub                     |
#      | hub    | {KEY_LIST_OF_CREATED_HUBS[3].name} |
#      | userId | qa@ninjavan.co             |
#    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" on Edit order page
#      | eventName         | SHIPMENT VAN INBOUNDED                         |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}             |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}               |
#      | descriptionString | Shipment {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" on Edit order page
#      | eventName         | SHIPMENT COMPLETED                             |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[3].name}             |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[3].id}               |
#      | descriptionString | Shipment {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Hub Inbound Skip Scan Stayover Shipment with different drop off trip (uid:18780560-c00f-4b9b-af9f-32f59e732117)
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
    And API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
#    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[4].id}"

    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[4].id}
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan and close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | shipmentType | Land Haul                          |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And DB Operator verify sla in movement_events table is succeed for the following data:
      | shipmentIds | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}|
      | extData     | {"path_cache":{"full_path":["{KEY_LIST_OF_CREATED_HUBS[1].name} (sg)","{KEY_LIST_OF_CREATED_HUBS[2].name} (sg)","{KEY_LIST_OF_CREATED_HUBS[4].name} (sg)"],"full_path_hub_ids":null,"trip_path":[{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]},{KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}]},"crossdock_detail":null,"error_message":null} |
    And Operator refresh page
    And Operator scan and close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | shipmentType | Land Haul                          |
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
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    And Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" is shown on Shipment Inbound Scanning page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].id} - {KEY_LIST_OF_CREATED_HUBS[3].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    Then Operator verifies shipment to go with trip is shown with total "1"
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    Then Operator verify small message "Destination reached. Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment color is "#e1f6e0"
    When Operator clicks end inbound button
    When Operator clicks proceed in end inbound dialog "Hub Inbound"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Hub Inbound has ended" is shown on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[4].name}    |
      | status      | Transit                               |
    And Operator open the shipment detail for the shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co                     |
    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" on Edit order page
      | eventName         | HUB INBOUND SCAN                                  |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" on Edit order page
      | eventName         | SHIPMENT COMPLETED                             |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[3].name}             |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[3].id}               |
      | descriptionString | Shipment {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Scan to  Remove Stayover Shipment at Hub Inbound With Different Dropoff Trip (uid:f4aeaff5-b11a-4e99-a8a6-a94242b1fc6e)
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
    And API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[4].id}"
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[4].id}
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan and close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[4].name} |
      | shipmentType | Land Haul                          |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator refresh page
    And Operator scan and close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | shipmentType | Land Haul                          |
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
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    And Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" is shown on Shipment Inbound Scanning page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].id} - {KEY_LIST_OF_CREATED_HUBS[3].name}                                                           |
      | inboundType          | Into Hub                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator click start inbound
    And Operator click proceed in trip completion dialog
    Then Operator verifies shipment to go with trip is shown with total "1"
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    Then Operator verify small message "Shipment not listed. Remove Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment color is "#fe5c5c"
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    Then Operator verify small message "Destination reached. Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appears in Shipment Inbound Box
    And Operator clicks end inbound button
    Then Operator verifies shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appears in error shipment dialog with result "Shipment not listed. Expected drop-off hub: {KEY_LIST_OF_CREATED_HUBS[2].name}."
    When Operator close error shipment dialog on Shipment Inbound Scanning page
    And Operator enter shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" in remove shipment
    Then Operator verifies toast with message "Shipment {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} is successfully removed" is shown on Shipment Inbound Scanning page
    And Operator clicks end inbound button
    When Operator clicks proceed in end inbound dialog "Hub Inbound"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Hub Inbound has ended" is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[4].name}    |
      | status      | Transit                               |
    And Operator open the shipment detail for the shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | DEL_FROM_HUB_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | userId | qa@ninjavan.co                     |
    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" on Edit order page
      | eventName         | HUB INBOUND SCAN                                  |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" on Edit order page
      | eventName         | SHIPMENT COMPLETED                             |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[3].name}             |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[3].id}               |
      | descriptionString | Shipment {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |

#  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
#  Scenario: Hub Inbound Scan Stayover Shipment With the same drop-off trip (uid:571b97b7-145a-45c6-beb6-540d94c65635)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    Given API Operator creates 2 new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | CROSSDOCK |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator creates new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | STATION   |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator verify new Hubs are created
#    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
#    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
#    Given Operator go to menu Inter-Hub -> Add To Shipment
#    And Operator scan and close shipment with data below:
#      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[3].name} |
#      | shipmentType | Land Haul                          |
#      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    And Operator refresh page
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
#    And Operator click start inbound
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    And Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} departed" is shown on Shipment Inbound Scanning page
#    And Operator refresh page
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
#      | inboundType          | Into Hub                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
#    And Operator click start inbound
#    And Operator click proceed in trip completion dialog
#    And Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} has arrived." is shown on Shipment Inbound Scanning page
#    And Operator clicks end inbound button
#    When Operator clicks proceed in end inbound dialog "Hub Inbound"
#    And Capture the toast with message is shown on Shipment Inbound Scanning page
#    Then Operator verifies toast with message "Hub Inbound has ended" is shown on Shipment Inbound Scanning page
#    And Operator refresh page
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
#    And Operator click start inbound
#    Then Operator verifies shipment to go with trip is shown with total "1"
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    And Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" is shown on Shipment Inbound Scanning page
#    And Operator refresh page
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].id} - {KEY_LIST_OF_CREATED_HUBS[3].name}                                                           |
#      | inboundType          | Into Hub                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
#    And Operator click start inbound
#    And Operator click proceed in trip completion dialog
#    Then Operator verifies shipment to unload is shown with total "1"
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    Then Operator verify small message "Destination reached. Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appears in Shipment Inbound Box
#    And Operator clicks end inbound button
#    And Operator click proceed in error shipment dialog
#    And Capture the toast with message is shown on Shipment Inbound Scanning page
#    Then Operator verifies toast with message "Hub Inbound has ended" is shown on Shipment Inbound Scanning page
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    Then Operator verify parameters of shipment on Shipment Management page:
#      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
#      | currHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}    |
#      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}    |
#      | status      | Completed                             |
#    And Operator open the shipment detail for the shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management Page
#    Then Operator verify shipment event on Shipment Details page:
#      | source | SHIPMENT_HUB_INBOUND(OpV2)               |
#      | result | Completed                          |
#      | hub    | {KEY_LIST_OF_CREATED_HUBS[3].name} |
#      | userId | qa@ninjavan.co             |
#    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" on Edit order page
#      | eventName         | SHIPMENT COMPLETED                             |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[3].name}             |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[3].id}               |
#      | descriptionString | Shipment {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#
#  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
#  Scenario: Hub Inbound Skip Scan Stayover Shipment With the same drop off trip (uid:d18b25a8-b312-4678-8eda-4744b29ed7a4)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    Given API Operator creates 2 new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | CROSSDOCK |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator creates new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | STATION   |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator verify new Hubs are created
#    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
#    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
#    Given Operator go to menu Inter-Hub -> Add To Shipment
#    And Operator scan and close shipment with data below:
#      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[3].name} |
#      | shipmentType | Land Haul                          |
#      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    And Operator refresh page
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
#    And Operator click start inbound
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    And Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} departed" is shown on Shipment Inbound Scanning page
#    And Operator refresh page
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
#      | inboundType          | Into Hub                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
#    And Operator click start inbound
#    And Operator click proceed in trip completion dialog
#    And Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} has arrived." is shown on Shipment Inbound Scanning page
#    And Operator clicks end inbound button
#    When Operator clicks proceed in end inbound dialog "Hub Inbound"
#    And Capture the toast with message is shown on Shipment Inbound Scanning page
#    Then Operator verifies toast with message "Hub Inbound has ended" is shown on Shipment Inbound Scanning page
#    And Operator refresh page
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
#    And Operator click start inbound
#    Then Operator verifies shipment to go with trip is shown with total "1"
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    And Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" is shown on Shipment Inbound Scanning page
#    And Operator refresh page
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].id} - {KEY_LIST_OF_CREATED_HUBS[3].name}                                                           |
#      | inboundType          | Into Hub                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
#    And Operator click start inbound
#    And Operator click proceed in trip completion dialog
#    Then Operator verifies shipment to unload is shown with total "1"
#    And Operator clicks end inbound button
#    And Operator click proceed in error shipment dialog
#    And Capture the toast with message is shown on Shipment Inbound Scanning page
#    Then Operator verifies toast with message "Hub Inbound has ended" is shown on Shipment Inbound Scanning page
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    Then Operator verify parameters of shipment on Shipment Management page:
#      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
#      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
#      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}    |
#      | status      | Transit                               |
#    And Operator open the shipment detail for the shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management Page
#    Then Operator verify shipment event on Shipment Details page:
#      | source | SHIPMENT_VAN_INBOUND(OpV2)               |
#      | result | Transit                          |
#      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | userId | qa@ninjavan.co             |
#    And Operator verifies event is present for order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" on Edit order page
#      | eventName         | SHIPMENT VAN INBOUNDED                         |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}             |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}               |
#      | descriptionString | Shipment {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Transit Shipment From Another Country to Hub Inbound (uid:476d787f-f99b-4375-a218-6893e319e440)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator change the country to "Singapore"
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan and close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | shipmentType | Land Haul                          |
      | shipmentId   | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator refresh page
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
    When Operator change the country to "Indonesia"
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
    And Operator clicks on assign_driver icon on the action column in movement schedule page
    And Operator assign driver "{id-driver-username}" to created movement schedule
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].name}      |
      | inboundType          | Into Hub                                |
      | driver               | {id-driver-name} ({id-driver-username}) |
      | movementTripSchedule | {hub-name-temp}                         |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Mismatched hub system ID: shipment destination hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator change the country to "Singapore"
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA) |
      | result | Transit                    |
      | userId | qa@ninjavan.co             |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op