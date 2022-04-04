@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @VanInbound @WithTrip
Feature: Shipment Van Inbound With Trip Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Start Van Inbound After Select Driver and Trip (uid:26f6c205-bc90-4ce8-991f-77a95f38f4fe)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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

  @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Shipment Cannot Be Found (uid:f28ec73c-3593-4c01-a0b6-e8ef38b3149e)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Remove Shipment From Van Inbounded List (uid:dce75cbd-6b55-43b2-9bab-1167787a494c)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is successfully removed" is shown on Shipment Inbound Scanning page
    And Operator verifies shipment counter is "0"

  @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Remove Shipment That Not Scanned Yet For Van Inbound (uid:303137d9-f8d1-4e78-8ac8-9c8d00733e12)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Scan Closed Shipment That Expected to Be Scanned to Van Inbound (uid:beab388f-b402-4fe6-8c20-d191d3af7444)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co                     |

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Error Shipment Detected as No Path Found (uid:5668954f-32ff-483f-bdd6-78c279cd96ec)
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
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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
    Then Operator verifies shipment with id "{KEY_CREATED_SHIPMENT_ID}" appears in error shipment dialog with result "No path found"
    When Operator click proceed in error shipment dialog
    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page
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
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co                     |
    And Operator verifies event is present for order on Edit order page
      | eventName         | HUB INBOUND SCAN                                  |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan for Pending Shipment In Shipment's Origin Hub (uid:6443468b-ee60-4fb7-ace5-10a6784d6921)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
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
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | HUB INBOUND SCAN                                  |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in trip_shipment_scans table

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Scan Shipment That Is Not Expected to Be Scanned to Van Inbound (uid:6ea2db1e-c863-4f5e-908b-f99298ecef6a)
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
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[3].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | status      | Pending                            |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: View Transit Shipment To Go With Trip for Van Inbound (uid:fe6d3ffe-552a-4020-9e64-d766abb387a6)
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
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 2
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    And Operator close the shipment which has been created
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment color is "#e1f6e0"
    And Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
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
      | shipmentCount  | 1                                                              |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}                                      |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                             |
      | dropOffHub     | {KEY_LIST_OF_CREATED_HUBS[2].name}                             |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name}                             |
      | comments       | Stay in vehicle. Drop off: {KEY_LIST_OF_CREATED_HUBS[2].name}  |
    When Operator clicks shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies it will direct to shipment details page for shipment "{KEY_CREATED_SHIPMENT_ID}"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: View At Transit Hub Shipment To Go With Trip for Van Inbound (uid:fa98b89c-b2a6-4896-a711-75e1e12bc309)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    And Operator close the shipment which has been created
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
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
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
    Then Operator verifies shipment to go with trip is shown with total "1"
    When Operator clicks shipment to go with trip
    Then Operator verifies shipment with trip with data below:
      | shipmentCount  | 1                                  |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | dropOffHub     | -                                  |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | comments       | -                                  |
    When Operator clicks shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies it will direct to shipment details page for shipment "{KEY_CREATED_SHIPMENT_ID}"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: View Many Shipments To Go With Trip for Van Inbound (uid:bccb666c-c8b3-406a-87cd-c00886ad77ae)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create multiple 10 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    And Operator close the shipment which has been created
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
    And API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[10]}                  |
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
    Then Operator verifies shipment to go with trip is shown with total "10"
    When Operator clicks shipment to go with trip
    Then Operator verifies created shipments data in shipment to go with trip with data below:
      | shipmentCount  | 10                                 |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | dropOffHub     | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | comments       | Shipment added to trip             |
    Then Operator verifies it able to scroll into row with shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    When Operator clicks shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    Then Operator verifies it will direct to shipment details page for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Error Shipment Detected as Incorrect Shipment (uid:f902787b-19bd-4771-a9dd-1ed0933774f7)
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
    And API Operator assign CrossDock "{KEY_LIST_OF_CREATED_HUBS[2].id}" for Station "{KEY_LIST_OF_CREATED_HUBS[4].id}"
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[3].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[4].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[3].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[3].id}"
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
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    And API Operator arrival trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_CREATED_SHIPMENT_ID}                               |
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
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].id} - {KEY_LIST_OF_CREATED_HUBS[3].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[3].firstName}{KEY_LIST_OF_CREATED_DRIVERS[3].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[3].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[4].name}                                                                                              |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Wrong origin and destination. Please return shipment to the warehouse. Remove Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment color is "#fe5c5c"
    And Operator clicks end inbound button
    Then Operator verifies shipment with id "{KEY_CREATED_SHIPMENT_ID}" appears in error shipment dialog with result "Wrong origin and destination. Please return shipment to the warehouse."
    When Operator click proceed in error shipment dialog
    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[3].name} |
      | userId | qa@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | HUB INBOUND SCAN                                  |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound with Missing Shipment (uid:6ab1af92-2ff5-4d19-a190-14627dde199e)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And Operator refresh page
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
    And API Operator shipment inbound scan all created shipments with data below:
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
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment color is "#e1f6e0"
    And Operator clicks end inbound button
    Then Operator verifies shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appears in error shipment dialog with result "-"
    When Operator click proceed in error shipment dialog
    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}    |
      | status      | At Transit Hub                        |
    And Operator open the shipment detail for the shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_HUB_INBOUND(MMDA)         |
      | result | At Transit Hub                     |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | qa@ninjavan.co             |
    And DB Operator verify unscanned shipment with following data:
      | shipmentId | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | type       | MISSING                               |
      | scanType   | SHIPMENT_VAN_INBOUND                  |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Completed Shipment to Van Inbound (uid:448ea0fe-200e-47ca-9536-26dccea63ce7)
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
    And API Operator change the status of the shipment into "Completed"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator click start inbound
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    And Click on No, goback on dialog box for shipment "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is in terminal state: [Completed]" is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Completed                          |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_FORCE_COMPLETED |
      | result | Completed                |
      | userId | qa@ninjavan.co   |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Cancelled Shipment to Van Inbound (uid:448ea0fe-200e-47ca-9536-26dccea63ce7)
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
    And API Operator change the status of the shipment into "Cancelled"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator click start inbound
    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    And Click on No, goback on dialog box for shipment "{KEY_CREATED_SHIPMENT_ID}"
#    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is in terminal state: [Cancelled]" is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Cancelled                          |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_CANCELLED     |
      | result | Cancelled              |
      | userId | qa@ninjavan.co |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Scan to  Remove Shipment at Van Inbound (uid:8beb0c2d-4980-455e-a3bc-9646e6c9e82c)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
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
    And Operator enter shipment with id "{KEY_CREATED_SHIPMENT_ID}" in remove shipment
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is successfully removed" is shown on Shipment Inbound Scanning page
    And Operator verifies shipment counter is "0"
    Then Operator verify small message "Successfuly Removed. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Remove Shipment Container

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Shipment Already Scanned (Duplicate Scan on Van Inbound) (uid:462e4908-f065-4c86-84a7-56ccc1c5596a)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
    Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
    And Operator close the shipment which has been created
    And Operator refresh page
    And Operator refresh page
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
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment color is "#e1f6e0"
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Duplicate scan for shipment {KEY_CREATED_SHIPMENT_ID}" is shown on Shipment Inbound Scanning page

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Check whether Old Scan Message is Cleared after New Scan (Van Inbound) (uid:85bd0840-8af2-4aba-b6ee-3da3f213082e)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
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
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And Operator verifies Scanned Shipment color is "#e1f6e0"
    And Operator enter shipment with id "{KEY_CREATED_SHIPMENT_ID}" in remove shipment
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is successfully removed" is shown on Shipment Inbound Scanning page
    And Operator verifies shipment counter is "0"
    Then Operator verify small message "Successfuly Removed. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Remove Shipment Container
    Then Operator verify small message "" appears in Shipment Inbound Box

  @DeleteShipments @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths @ForceSuccessOrder
  Scenario: Scan MAWB Consisting Duplicate Scanned Shipments (uid:224bb9c0-f3e1-40c8-8126-f12ff7930feb)
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
    Given API Operator create multiple 2 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator refresh page
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    And Operator scan shipment with id "{KEY_SHIPMENT_AWB}"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message containing "Duplicate Shipment" is shown on Shipment Inbound Scanning page
#    Then Operator verifies toast with message "Duplicate Shipment\nShipment IDs: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}, {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" is shown on Shipment Inbound Scanning page
#    And Operator verifies toast bottom with message "Shipment ID: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" is shown on Shipment Inbound Scanning page
#    Then Operator verify small message "Partial Success. MAWB: {KEY_SHIPMENT_AWB}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "2"
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" exist color is "#e1f6e0"
    And Operator verifies Scanned Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" exist color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast with message containing "departed" is shown on Shipment Inbound Scanning page
#    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} departed" is shown on Shipment Inbound Scanning page
#    When Operator go to menu Inter-Hub -> Movement Trips
#    And Operator verifies movement Trip page is loaded
#    And Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
#    And Operator clicks on Load Trip Button
#    Then Operator verifies movement trip shown has status value "transit"
#    And Operator verifies trip has departed
#    And Operator verifies event "departed" with status "transit" is present for trip on Trip events page
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
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co                     |
#    And Operator verifies event is present for order on Edit order page
#      | eventName         | HUB INBOUND SCAN                                  |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
#      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appear in trip_shipment_scans table
    Then DB Operator verify path for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appear in trip_shipment_scans table

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths @ForceSuccessOrder
  Scenario: Failed to scan MAWB to Van Inbound (uid:73e96d3b-5c0c-4d55-b786-a1d2239166a4)
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
    Given API Operator create multiple 2 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator assign mawb "mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" to following shipmentIds
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_SHIPMENT_AWB}"
    Then Operator verify small message "Scan failed. MAWB: {KEY_SHIPMENT_AWB}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "0"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths @ForceSuccessOrder
  Scenario: Success Scan MAWB Partially at Van Inbound (uid:875cb4b6-cdfb-4a5e-b5c0-ed834065198a)
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
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    Given API Operator create multiple 1 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}"
    And API Operator assign mawb "mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" to following shipmentIds
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator refresh page
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    And Operator scan shipment with id "{KEY_SHIPMENT_AWB}"
    Then Operator verify small message "Scan failed. MAWB: {KEY_SHIPMENT_AWB}" appears in Shipment Inbound Box
    And Operator verifies shipment counter is "1"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths @ForceSuccessOrder
  Scenario: Scan Correct MAWB to Van Inbound (uid:494da16d-189b-4180-8e97-8f70b110358a)
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
    Given API Operator create multiple 2 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator refresh page
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[2].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
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
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
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
    Then Operator verifies toast with message containing "departed" is shown on Shipment Inbound Scanning page
#    When Operator go to menu Inter-Hub -> Movement Trips
#    And Operator verifies movement Trip page is loaded
#    And Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
#    And Operator clicks on Load Trip Button
#    Then Operator verifies movement trip shown has status value "transit"
#    And Operator verifies trip has departed
#    And Operator verifies event "departed" with status "transit" is present for trip on Trip events page
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
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co                     |
#    And Operator verifies event is present for order on Edit order page
#      | eventName         | HUB INBOUND SCAN                                  |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
#      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appear in trip_shipment_scans table
    Then DB Operator verify path for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appear in trip_shipment_scans table

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths @ForceSuccessOrder
  Scenario: Check whether Driver&Trip  Values are cleared after changing Hub Inbound (uid:c37d486b-36b9-498f-9cf0-8923bb00699c)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub  | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | inboundType | Into Van                                                              |
    Then Operator verify start inbound button is "enabled"
    When Operator fill Shipment Inbound Scanning page with data:
      | driver | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#    Then Operator verify small message "Please select a trip before start inbound" "appears" in Start Inbound Box
    And Operator verify start inbound button is "disabled"
    When Operator fill Shipment Inbound Scanning page with data:
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify start inbound button is "enabled"
    When Operator fill Shipment Inbound Scanning page with data:
      | inboundHub  | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | inboundType | Into Hub                           |
    Then Operator verify driver and movement trip is cleared
#    And Operator verify small message "Please select a trip before start inbound" "not appears" in Start Inbound Box
    And Operator verify start inbound button is "enabled"

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan for Trip with Driver(s) in Transit for Different Trips (Validation at End Inbound) (uid:0c0bb89c-49a0-46ed-bb17-5417c9b936ce)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    Given API Operator creates 3 new Hub using data below:
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
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign following drivers to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[3].id}"
      | primaryDriver    | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | additionalDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    And Operator close the shipment which has been created
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
    And Operator click start inbound
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType    | SHIPMENT VAN INBOUND                                                                                                            |
      | driver         | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast bottom containing following messages is shown on Shipment Inbound Scanning page:
      | Driver {KEY_LIST_OF_CREATED_DRIVERS[2].firstName} is still in trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} from {KEY_LIST_OF_CREATED_HUBS[2].name} to {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | Driver {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} is still in trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} from {KEY_LIST_OF_CREATED_HUBS[1].name} to {KEY_LIST_OF_CREATED_HUBS[2].name} |
    When Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} departed" is shown on Shipment Inbound Scanning page
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
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | HUB INBOUND SCAN                                  |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan for Trip with Driver(s) in Transit for Different Trips (Validation at Start Inbound) (uid:a4916525-06ff-4cd6-b416-ecb5679c48e5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    Given API Operator creates 3 new Hub using data below:
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
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign following drivers to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[3].id}"
      | primaryDriver    | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | additionalDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And API Operator reloads hubs cache
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].name}
    And Operator close the shipment which has been created
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    And Operator click start inbound
    Then Operator verifies toast bottom containing following messages is shown on Shipment Inbound Scanning page:
      | Driver {KEY_LIST_OF_CREATED_DRIVERS[2].firstName} is still in trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} from {KEY_LIST_OF_CREATED_HUBS[2].name} to {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | Driver {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} is still in trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} from {KEY_LIST_OF_CREATED_HUBS[1].name} to {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType    | SHIPMENT VAN INBOUND                                                                                                            |
      | driver         | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} departed" is shown on Shipment Inbound Scanning page
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
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co             |
#    And Operator verifies event is present for order on Edit order page
#      | eventName         | HUB INBOUND SCAN                                  |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
#      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: View At Transit Hub Shipment To Go With Trip - Shipment in Transit Trip is not shown on Shipments to Go list (uid:bc9b23da-e4fe-4553-b0d6-3e94b03079ed)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    Given API Operator creates 4 new Hub using data below:
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
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[4].id}
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[4].id}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 1
    And API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" plus hours 1
    And API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}" plus hours 2
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[3].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[3].id}"
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator close shipment with data below:
      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[4].name}         |
      | shipmentType | Land Haul                  |
      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[4].name}
#    And Operator close the shipment which has been created
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    Given API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                   |
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
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                     |
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    And Operator refresh page
    Given API Operator arrival trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    And API Operator shipment inbound scan with trip with data below:
      | scanValue      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_HUB_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    And Operator refresh page
    And API Operator complete trip with data below:
      | tripId | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} |
      | hubId  | {KEY_LIST_OF_CREATED_HUBS[3].id}           |
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].id} - {KEY_LIST_OF_CREATED_HUBS[3].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[3].firstName}{KEY_LIST_OF_CREATED_DRIVERS[3].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[3].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[4].name}                                                                                              |
    And Operator click start inbound
    Then Operator verifies shipment to go with trip is shown with total "2"
    When Operator clicks shipment to go with trip
    Then Operator verifies shipment with trip with data below:
      | shipmentCount  | 1                                                              |
      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}                          |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name}                             |
      | dropOffHub     | {KEY_LIST_OF_CREATED_HUBS[3].name}                             |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[4].name}                             |
      | comments       | Stay in vehicle. Drop off: {KEY_LIST_OF_CREATED_HUBS[3].name}  |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan for Trip with Driver(s) in Transit for Same Trip (Validation at End Inbound) (uid:0a874092-f3e3-4b07-a3cf-d8c8b1d1e97e)
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
#    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator assign following drivers to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
      | primaryDriver    | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | additionalDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And API Operator assign following drivers to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
      | primaryDriver    | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | additionalDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And Operator refresh page
    And API Operator reloads hubs cache
    Given Operator go to menu Inter-Hub -> Add To Shipment
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
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]}              |
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType    | SHIPMENT VAN INBOUND                                                                        |
      | driver         | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast bottom containing message "Driver {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}, {KEY_LIST_OF_CREATED_DRIVERS[2].firstName} is still in trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} from {KEY_LIST_OF_CREATED_HUBS[2].name} to {KEY_LIST_OF_CREATED_HUBS[1].name} with expected arrival time" is shown on Shipment Inbound Scanning page
    When Operator click force complete trip in shipment inbound scanning page
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} has completed" is shown on Shipment Inbound Scanning page
#    When Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    Then Operator verifies toast with message containing "departed" is shown on Shipment Inbound Scanning page
#    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} departed" is shown on Shipment Inbound Scanning page
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
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co             |
#    And Operator verifies event is present for order on Edit order page
#      | eventName         | HUB INBOUND SCAN                                  |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
#      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in trip_shipment_scans table

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan for Trip with Driver(s) in Transit for Same Trip (Validation at Start Inbound) (uid:8fbc0cd3-24fc-4634-8e99-e4a1725ca59d)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator assign following drivers to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
      | primaryDriver    | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | additionalDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And API Operator assign following drivers to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
      | primaryDriver    | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | additionalDriver | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
    Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
    And Operator close the shipment which has been created
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
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
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
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co             |
#    And Operator verifies event is present for order on Edit order page
#      | eventName         | HUB INBOUND SCAN                                  |
#      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
#      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
#      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in trip_shipment_scans table

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan At Transit Hub Shipment with Stay-over Shipment (uid:a3a1027b-8526-48ba-96b2-e6f331040c49)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
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
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}    |
      | status      | Transit                               |
    And Operator open the shipment detail for the shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | userId | qa@ninjavan.co             |
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    When Operator change the country to "Indonesia"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
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
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_CREATED       |
      | result | Pending                |
      | userId | qa@ninjavan.co |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Cancelled Shipment From Another Country to Van Inbound (uid:56226f31-bd34-4e44-a2ac-e3697a3fa8cb)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    When Operator change the country to "Indonesia"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
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
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Cancelled                 |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_CANCELLED     |
      | result | Cancelled              |
      | userId | qa@ninjavan.co |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Completed Shipment From Another Country to Van Inbound (uid:b929b5ef-13b3-46fc-bbd4-30a33ccafb6b)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    When Operator change the country to "Indonesia"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
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
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Completed                 |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_FORCE_COMPLETED |
      | result | Completed                |
      | userId | qa@ninjavan.co   |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Closed Shipment From Another Country to Van Inbound (uid:8064cfab-1620-425a-bb6b-38a24312d6bb)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    When Operator change the country to "Indonesia"
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name-temp}                                                     |
      | destHubName | {hub-name-temp-2}                                                   |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
#    And API Operator put created parcel to shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {hub-name-temp} to hub id = {hub-name-temp-2}
    And Operator close the shipment which has been created
#    Given Operator go to menu Inter-Hub -> Add To Shipment
#    And Operator close shipment with data below:
#      | origHubName  | {hub-name-temp}           |
#      | destHubName  | {hub-name-temp-2}         |
#      | shipmentType | Air Haul                  |
#      | shipmentId   | {KEY_CREATED_SHIPMENT_ID} |
    And Operator refresh page
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
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator change the country to "Indonesia"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-temp}           |
      | currHubName | {hub-name-temp}           |
      | destHubName | {hub-name-temp-2}         |
      | status      | Closed                    |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_CLOSED        |
      | result | Closed                 |
      | userId | qa@ninjavan.co |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Invalid to Scan Transit Shipment From Another Country to Van Inbound (uid:48377ad2-c189-473c-b7f5-ac4d2a8d4183)
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Operator close shipment with data below:
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
    And Operator clicks on assign_driver icon on the action column in movement schedule page
    And Operator assign driver "{id-driver-username}" to created movement schedule
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[3].name}      |
      | inboundType          | Into Van                                |
      | driver               | {id-driver-name} ({id-driver-username}) |
      | movementTripSchedule | {hub-name-temp}                         |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Mismatched hub system ID: shipment origin hub system ID sg and scan hub system ID id are not the same." is shown on Shipment Inbound Scanning page
    And Operator verifies Scan Shipment Container color is "#ffe7ec"
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator change the country to "Singapore"
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)   |
      | result | Transit                      |
      | userId | qa@ninjavan.co       |

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan for Trip with Driver in Transit using 2 tabs (Validation at Start&End Inbound) (uid:2bae42b6-23d5-4f01-ae18-d1bf0262badd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    Given API Operator creates 3 new Hub using data below:
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[3].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
    Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
    And Operator close the shipment which has been created
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[3].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]}              |
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    Then Operator verifies toast bottom containing message "Driver {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} is still in trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} from {KEY_LIST_OF_CREATED_HUBS[2].name} to {KEY_LIST_OF_CREATED_HUBS[3].name} with expected arrival time" is shown on Shipment Inbound Scanning page
    When Operator click force complete trip in shipment inbound scanning page
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[3]} has completed" is shown on Shipment Inbound Scanning page
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType    | SHIPMENT VAN INBOUND                                                                                                            |
      | driver         | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    When Operator opens new tab and switch to new tab in shipment inbound scanning page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" is shown on Shipment Inbound Scanning page
    And Operator close new tab in shipment inbound scanning page
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast bottom containing message "Driver {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} is still in trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} from {KEY_LIST_OF_CREATED_HUBS[2].name} to {KEY_LIST_OF_CREATED_HUBS[1].name} with expected arrival time" is shown on Shipment Inbound Scanning page
    When Operator click force complete trip in shipment inbound scanning page
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} has completed" is shown on Shipment Inbound Scanning page
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} departed" is shown on Shipment Inbound Scanning page
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
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | HUB INBOUND SCAN                                  |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in trip_shipment_scans table

  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Van Inbound Scan for Trip with Driver(s) in Transit using 2 tabs (Validation at End Inbound) (uid:224fb1d6-3954-413b-9655-826f204367fd)
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
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator put created parcel to shipment
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
#    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
    And Operator close the shipment which has been created
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                                                           |
      | inboundType    | SHIPMENT VAN INBOUND                                                                                                            |
      | driver         | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
    And Operator verifies shipment counter is "1"
    And Operator verifies Scan Shipment Container color is "#e1f6e0"
    When Operator opens new tab and switch to new tab in shipment inbound scanning page
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}{KEY_LIST_OF_CREATED_DRIVERS[1].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[1].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                                                              |
    And Operator click start inbound
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    And Capture the toast with message is shown on Shipment Inbound Scanning page
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" is shown on Shipment Inbound Scanning page
    And Operator close new tab in shipment inbound scanning page
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
    Then Operator verifies toast bottom containing message "Driver {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} is still in trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} from {KEY_LIST_OF_CREATED_HUBS[2].name} to {KEY_LIST_OF_CREATED_HUBS[1].name} with expected arrival time" is shown on Shipment Inbound Scanning page
    When Operator click force complete trip in shipment inbound scanning page
    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} has completed" is shown on Shipment Inbound Scanning page
    When Operator clicks end inbound button
    And Operator clicks proceed in end inbound dialog "Van Inbound"
#    Then Operator verifies toast with message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]} departed" is shown on Shipment Inbound Scanning page
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
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | userId | qa@ninjavan.co             |
    And Operator verifies event is present for order on Edit order page
      | eventName         | HUB INBOUND SCAN                                  |
      | hubName           | {KEY_LIST_OF_CREATED_HUBS[1].name}                |
      | hubId             | {KEY_LIST_OF_CREATED_HUBS[1].id}                  |
      | descriptionString | Inbounded at Hub {KEY_LIST_OF_CREATED_HUBS[1].id} |
    Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table
    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in trip_shipment_scans table

  @DeleteShipment @ForceSuccessOrder @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
  Scenario: Shipment Detected as No SLA Found
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver to movement trip schedule
    And Operator refresh page
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType          | Into Van                                                                                    |
      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Shipment doesn't have SLA. Remove Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
      | inboundHub     | {KEY_LIST_OF_CREATED_HUBS[1].id} - {KEY_LIST_OF_CREATED_HUBS[1].name}                       |
      | inboundType    | SHIPMENT VAN INBOUND                                                                        |
      | driver         | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                          |
    And Operator verifies shipment counter is "1"

#  @DeleteShipment @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb @DeletePaths
#  Scenario: Van Inbound with pagination
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    Given API Operator creates new Hub using data below:
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
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    And API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Operator create multiple 101 new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
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
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[6]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[7]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[8]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[9]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[10]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[11]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[12]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[13]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[14]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[15]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[16]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[17]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[18]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[19]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[20]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[21]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[22]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[23]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[24]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[25]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[26]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[27]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[28]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[29]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[30]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[31]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[32]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[33]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[34]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[35]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[36]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[37]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[38]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[39]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[40]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[41]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[42]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[43]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[44]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[45]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[46]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[47]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[48]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[49]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[50]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[51]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[52]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[53]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[54]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[55]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[56]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[57]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[58]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[59]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[60]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[61]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[62]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[63]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[64]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[65]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[66]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[67]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[68]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[69]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[70]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[71]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[72]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[73]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[74]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[75]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[76]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[77]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[78]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[79]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[80]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[81]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[82]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[83]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[84]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[85]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[86]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[87]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[88]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[89]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[90]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[91]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[92]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[93]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[94]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[95]}"
#    And Operator refresh page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[96]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[97]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[98]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[99]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[100]}"
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator put created parcel to shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[101]}"
#    And Operator refresh page
#    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
#    And Operator refresh page
#    Given Operator go to menu Inter-Hub -> Add To Shipment
#    And Operator close multiple shipments with data below:
#      | origHubName  | {KEY_LIST_OF_CREATED_HUBS[1].name}         |
#      | destHubName  | {KEY_LIST_OF_CREATED_HUBS[3].name}         |
#      | shipmentType | Land Haul                                  |
#      | shipmentId   | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[%s]}     |
#      | shipmentCount| 101                                        |
#    And Operator refresh page
#    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
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
#    And API Operator shipment inbound scan all created shipments with data below:
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
##    Given API Operator shipment inbound scan all created shipments with data below:
##      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
##      | actionType     | ADD                                                     |
##      | scanType       | SHIPMENT_VAN_INBOUND                                    |
##      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
##    And Operator refresh page
##    And API Operator shipment end inbound with trip with data below:
##      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
##      | actionType     | ADD                                                     |
##      | scanType       | SHIPMENT_VAN_INBOUND                                    |
##      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
##      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
##    And API Operator depart trip with data below:
##      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
##      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
##    And Operator refresh page
##    And API Operator arrival trip with data below:
##      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
##      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#    And Operator refresh page
#    When Operator fill Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
#    And Operator click start inbound
#    Then Operator verifies shipment to go with trip is shown with total "101"
#    And Operator scan shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[101]}"
##    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" appears in Shipment Inbound Box
##    And Operator verifies Scanned Shipment color is "#e1f6e0"
##    And Operator clicks end inbound button
##    Then Operator verifies shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" appears in error shipment dialog with result "-"
##    When Operator click proceed in error shipment dialog
##    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} departed" is shown on Shipment Inbound Scanning page
##    When Operator go to menu Inter-Hub -> Shipment Management
##    And Operator search shipments by given Ids on Shipment Management page:
##      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
##    Then Operator verify parameters of shipment on Shipment Management page using data below:
##      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
##      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}    |
##      | currHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}    |
##      | destHubName | {KEY_LIST_OF_CREATED_HUBS[3].name}    |
##      | status      | At Transit Hub                        |
##    And Operator open the shipment detail for the shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management Page
##    Then Operator verify shipment event on Shipment Details page using data below:
##      | source | SHIPMENT_HUB_INBOUND(MMDA)         |
##      | result | At Transit Hub                     |
##      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
##      | userId | qa@ninjavan.co             |
##    And DB Operator verify unscanned shipment with following data:
##      | shipmentId | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
##      | type       | MISSING                               |
##      | scanType   | SHIPMENT_VAN_INBOUND                  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op