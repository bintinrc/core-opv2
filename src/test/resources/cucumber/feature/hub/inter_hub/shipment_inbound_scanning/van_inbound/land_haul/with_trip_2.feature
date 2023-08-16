@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @VanInbound @WithTrip2
Feature: Shipment Van Inbound With Trip Scanning 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteShipment @ForceSuccessOrder @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Start Van Inbound After Select Driver and Trip (uid:26f6c205-bc90-4ce8-991f-77a95f38f4fe)
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
	And API Operator verify new Hubs are created
	And API Operator reloads hubs cache
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	Given API Operator create new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
	And API Operator assign driver to movement trip schedule
	And Operator refresh page
	Given Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
	And Operator close the shipment which has been created
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
	  | inboundType          | Into Van                                                                                    |
	  | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
	  | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
	And Operator click start inbound
	And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
	Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
	  | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
	  | inboundType    | SHIPMENT VAN INBOUND                                                                        |
	  | driver         | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
	  | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
	And Operator verifies shipment counter is "1"

  @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Shipment Cannot Be Found (uid:f28ec73c-3593-4c01-a0b6-e8ef38b3149e)
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
	And API Operator verify new Hubs are created
	And API Operator reloads hubs cache
	Given API Operator create new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
	And API Operator assign driver to movement trip schedule
	And Operator refresh page
	When Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
	  | inboundType          | Into Van                                                                                    |
	  | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
	  | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
	And Operator click start inbound
	And Operator scan shipment with id "Shipment_123"
	And Capture the toast with message is shown on Shipment Inbound Scanning page
	Then Operator verifies toast with message "Shipment Shipment_123 can not be found." is shown on Shipment Inbound Scanning page
	And Operator verifies Scan Shipment Container color is "#ffe7ec"
	When Operator clicks end inbound button
	And Operator clicks proceed in end inbound dialog "Van Inbound"
	Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page

  @DeleteShipment @ForceSuccessOrder @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Remove Shipment From Van Inbounded List (uid:dce75cbd-6b55-43b2-9bab-1167787a494c)
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
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	When API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
	Given API Operator create new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
	And API Operator assign driver to movement trip schedule
	Given Operator go to menu Inter-Hub -> Add To Shipment
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
	Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
	And Operator close the shipment which has been created
	And Operator refresh page
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
	  | inboundType          | Into Van                                                                                    |
	  | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
	  | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
	And Operator click start inbound
	And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
	When Operator remove scanned shipment from remove button in scanned shipment table
#    And Capture the toast with message is shown on Shipment Inbound Scanning page
	Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is successfully removed" is shown on Shipment Inbound Scanning page
	And Operator verifies shipment counter is "0"

  @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Remove Shipment That Not Scanned Yet For Van Inbound (uid:303137d9-f8d1-4e78-8ac8-9c8d00733e12)
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
	And API Operator verify new Hubs are created
	And API Operator reloads hubs cache
	Given API Operator create new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
	And API Operator assign driver to movement trip schedule
	And Operator refresh page
	When Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
	  | inboundType          | Into Van                                                                                    |
	  | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
	  | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
	And Operator click start inbound
	And Operator enter shipment with id "Shipment_123" in remove shipment
	And Capture the toast with message is shown on Shipment Inbound Scanning page
	Then Operator verifies toast with message "Shipment Shipment_123 can not be found." is shown on Shipment Inbound Scanning page

  @DeleteShipment @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Scan Closed Shipment That Expected to Be Scanned to Van Inbound (uid:beab388f-b402-4fe6-8c20-d191d3af7444)
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
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	Given API Operator create new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
#    And API Operator assign driver to movement trip schedule
	Given Operator go to menu Inter-Hub -> Movement Trips
	And Operator verifies movement Trip page is loaded
	When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
	And Operator clicks on Load Trip Button
	And Operator verify Load Trip Button is gone
	And Operator clicks on "assign_driver" icon on the action column
	And Operator assign driver "({KEY_LIST_OF_CREATED_DRIVERS[1].username})" to created movement trip
	Given Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
	And Operator close the shipment which has been created
	And Operator refresh page
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	And Operator refresh page
	When Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
	  | inboundType          | Into Van                                                                                    |
	  | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
	  | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
	And Operator click start inbound
	When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
	When Operator clicks end inbound button
	And Operator clicks proceed in end inbound dialog "Van Inbound"
	Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page
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

  @DeleteShipment @ForceSuccessOrder @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Error Shipment Detected as No Path Found (uid:5668954f-32ff-483f-bdd6-78c279cd96ec)
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
	  | facilityType | CROSSDOCK |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	And API Operator verify new Hubs are created
	And API Operator reloads hubs cache
	Given API Operator create new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
	And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    And API Operator put created parcel to shipment
	Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
	And API Operator assign driver to movement trip schedule
	Given Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
	And Operator close the shipment which has been created
	And Operator refresh page
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
	  | inboundType          | Into Van                                                                                    |
	  | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
	  | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
	And Operator click start inbound
	When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
	And Operator clicks end inbound button
	Then Operator verifies shipment with id "{KEY_CREATED_SHIPMENT_ID}" appears in error shipment dialog with result "Shipment doesn't have SLA."
	When Operator click proceed in error shipment dialog
	Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page
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
	And Operator verifies event is present for order on Edit order page
	  | eventName         | HUB INBOUND SCAN                                  |
	  | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
	  | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
	  | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |

  @DeleteShipment @ForceSuccessOrder @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan for Pending Shipment In Shipment's Origin Hub (uid:6443468b-ee60-4fb7-ace5-10a6784d6921)
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
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
	And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	And API Operator put created parcel to shipment
	Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
	And API Operator assign driver to movement trip schedule
	Given Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
	And Operator close the shipment which has been created
	And Operator refresh page
	Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
	  | inboundType          | Into Van                                                                                    |
	  | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
	  | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
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
	Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page
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
	And Operator verifies event is present for order on Edit order page
	  | eventName         | HUB INBOUND SCAN                                  |
	  | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
	  | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
	  | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
	Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table
	Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in trip_shipment_scans table

  @DeleteShipment @ForceSuccessOrder @DeleteDriverV2 @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Scan Shipment That Is Not Expected to Be Scanned to Van Inbound (uid:6ea2db1e-c863-4f5e-908b-f99298ecef6a)
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
	  | facilityType | CROSSDOCK |
	  | city         | GENERATED |
	  | country      | GENERATED |
	  | latitude     | GENERATED |
	  | longitude    | GENERATED |
	And API Operator verify new Hubs are created
	And API Operator reloads hubs cache
	Given API Operator create new Driver using data below:
	  | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
	And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[3].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
	And API Operator put created parcel to shipment
	Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
	And API Operator assign driver to movement trip schedule
	And Operator refresh page
	When Operator fill Shipment Inbound Scanning page with data below:
	  | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
	  | inboundType          | Into Van                                                                                                                        |
	  | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
	  | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
	And Operator click start inbound
	And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
	And Capture the toast with message is shown on Shipment Inbound Scanning page
	Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is [Pending], but scanned at [{KEY_LIST_OF_CREATED_HUBS[1].name}], please inbound into van in the origin hub [{KEY_LIST_OF_CREATED_HUBS[3].name}]." is shown on Shipment Inbound Scanning page
	And Operator verifies Scan Shipment Container color is "#ffe7ec"
	When Operator clicks end inbound button
	And Operator clicks proceed in end inbound dialog "Van Inbound"
	Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | id          | {KEY_CREATED_SHIPMENT_ID}          |
	  | origHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
	  | currHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
	  | status      | Pending                            |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op