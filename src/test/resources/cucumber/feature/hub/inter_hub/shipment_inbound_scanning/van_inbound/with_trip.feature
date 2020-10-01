@ShipmentInboundScanning @InterHub @Shipment @MiddleMile @VanInbound @WithTrip @Refo
Feature: Shipment Inbound Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  @DeleteShipment @ForceSuccessOrder @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: Start Van Inbound After Select Driver and Trip (uid:26f6c205-bc90-4ce8-991f-77a95f38f4fe)
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
#    And API Operator verify new Hubs are created
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator put created parcel to shipment
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator assign driver to movement trip schedule
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
#      | inboundType          | Into Van                                                                                    |
#      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#      | movementTripSchedule | {KEY_MOVEMENT_TRIP_DETAIL_SHIPMENT_SCANNING}                                                |
#    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
#    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
#      | inboundHub       | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
#      | inboundType      | Into Van                                                                                    |
#      | driver           | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#      | movementTrip     | {KEY_MOVEMENT_TRIP_DETAIL_SHIPMENT_SCANNING}                                                |
#      | stringShipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                   |
#
#  @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: Shipment Cannot Be Found (uid:f28ec73c-3593-4c01-a0b6-e8ef38b3149e)
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
#    And API Operator verify new Hubs are created
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
#    And API Operator assign driver to movement trip schedule
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
#      | inboundType          | Into Van                                                                                    |
#      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#      | movementTripSchedule | {KEY_MOVEMENT_TRIP_DETAIL_SHIPMENT_SCANNING}                                                |
#    And Operator scan shipment with id "Shipment_123"
#    Then Operator verifies toast with message "Shipment Shipment_123 can not be found." is shown on Shipment Inbound Scanning page
#    And Operator verifies Scan Shipment Container color is "#ffe7ec"
#    When Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog
#    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} has departed." is shown on Shipment Inbound Scanning page
#
#  @DeleteShipment @ForceSuccessOrder @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: Remove Shipment From Van Inbounded List (uid:dce75cbd-6b55-43b2-9bab-1167787a494c)
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
#    And API Operator verify new Hubs are created
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator put created parcel to shipment
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator assign driver to movement trip schedule
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
#      | inboundType          | Into Van                                                                                    |
#      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#      | movementTripSchedule | {KEY_MOVEMENT_TRIP_DETAIL_SHIPMENT_SCANNING}                                                |
#    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
#    When Operator click remove button in scanned shipment table
#    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is successfully removed" is shown on Shipment Inbound Scanning page
#    And Operator verifies shipment counter is "0"
#    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
#    And Operator enter shipment with id "{KEY_CREATED_SHIPMENT_ID}" in remove shipment
#    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is successfully removed" is shown on Shipment Inbound Scanning page
#    And Operator verifies shipment counter is "0"
#
#  @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: Shipment Cannot Be Found (uid:f28ec73c-3593-4c01-a0b6-e8ef38b3149e)
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
#    And API Operator verify new Hubs are created
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
#    And API Operator assign driver to movement trip schedule
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
#      | inboundType          | Into Van                                                                                    |
#      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#      | movementTripSchedule | {KEY_MOVEMENT_TRIP_DETAIL_SHIPMENT_SCANNING}                                                |
#    And Operator enter shipment with id "Shipment_123" in remove shipment
#    Then Operator verifies toast with message "Shipment Shipment_123 can not be found." is shown on Shipment Inbound Scanning page
#
#  @DeleteShipment @ForceSuccessOrder @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: Scan Closed Shipment That Expected to Be Scanned to Van Inbound (uid:beab388f-b402-4fe6-8c20-d191d3af7444)
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
#    And API Operator verify new Hubs are created
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator put created parcel to shipment
#    And API Operator change the status of the shipment into "Completed"
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator assign driver to movement trip schedule
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
#      | inboundType          | Into Van                                                                                    |
#      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#      | movementTripSchedule | {KEY_MOVEMENT_TRIP_DETAIL_SHIPMENT_SCANNING}                                                |
#    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
#    Then Operator verifies toast with message "Shipment {KEY_CREATED_SHIPMENT_ID} is in terminal state: [Completed]" is shown on Shipment Inbound Scanning page
#    When Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog
#    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} has departed." is shown on Shipment Inbound Scanning page
#
#  @DeleteShipment @ForceSuccessOrder @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: Error Shipment Detected as No Path Found (uid:5668954f-32ff-483f-bdd6-78c279cd96ec)
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
#      | facilityType | CROSSDOCK |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator verify new Hubs are created
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    And API Operator put created parcel to shipment
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator assign driver to movement trip schedule
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
#      | inboundType          | Into Van                                                                                    |
#      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#      | movementTripSchedule | {KEY_MOVEMENT_TRIP_DETAIL_SHIPMENT_SCANNING}                                                |
#    When Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
#    And Operator clicks end inbound button
#    Then Operator verifies shipment with id "{KEY_CREATED_SHIPMENT_ID}" appears in error shipment dialog with result "No path found"
#    When Operator click proceed in error shipment dialog
#    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} has departed." is shown on Shipment Inbound Scanning page
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_CREATED_SHIPMENT_ID} |
#    Then Operator verify parameters of shipment on Shipment Management page using data below:
#      | id          | {KEY_CREATED_SHIPMENT_ID}          |
#      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | status      | Transit                            |
#    And Operator open the shipment detail for the created shipment on Shipment Management Page
#    Then Operator verify shipment event on Shipment Details page using data below:
#      | source | SHIPMENT_VAN_INBOUND               |
#      | result | Transit                            |
#      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | userId | automation@ninjavan.co             |
#    And Operator verifies event is present for order on Edit order page
#      | eventName | HUB INBOUND SCAN                   |
#      | hubName   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | hubId     | {KEY_LIST_OF_CREATED_HUBS[1].id}   |
#
#  @DeleteShipment @ForceSuccessOrder @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: Van Inbound Scan for Pending Shipment In Shipment's Origin Hub (uid:6443468b-ee60-4fb7-ace5-10a6784d6921)
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
#    And API Operator verify new Hubs are created
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator put created parcel to shipment
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator assign driver to movement trip schedule
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
#      | inboundType          | Into Van                                                                                    |
#      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#      | movementTripSchedule | {KEY_MOVEMENT_TRIP_DETAIL_SHIPMENT_SCANNING}                                                |
#    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
#    Then Operator verify small message "Shipment added to trip. Shipment: {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
#    Then Operator verify the trip Details is correct on shipment inbound scanning page using data below:
#      | inboundHub       | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
#      | inboundType      | Into Van                                                                                    |
#      | driver           | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#      | movementTrip     | {KEY_MOVEMENT_TRIP_DETAIL_SHIPMENT_SCANNING}                                                |
#      | stringShipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                   |
#    And Operator verifies shipment counter is "1"
#    And Operator verifies Scan Shipment Container color is "#e1f6e0"
#    When Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog
#    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} has departed." is shown on Shipment Inbound Scanning page
#    When Operator go to menu Inter-Hub -> Movement Trips
#    And Operator verifies movement Trip page is loaded
#    And Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
#    And Operator clicks on Load Trip Button
#    Then Operator verifies movement trip shown has status value "transit"
#    And Operator verifies trip has departed
#    And Operator verifies event "departed" with status "transit" is present for trip on Trip events page
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_CREATED_SHIPMENT_ID} |
#    Then Operator verify parameters of shipment on Shipment Management page using data below:
#      | id          | {KEY_CREATED_SHIPMENT_ID}          |
#      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | currHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | status      | Transit                            |
#    And Operator open the shipment detail for the created shipment on Shipment Management Page
#    Then Operator verify shipment event on Shipment Details page using data below:
#      | source | SHIPMENT_VAN_INBOUND               |
#      | result | Transit                            |
#      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | userId | automation@ninjavan.co             |
#    And Operator verifies event is present for order on Edit order page
#      | eventName | HUB INBOUND SCAN                   |
#      | hubName   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | hubId     | {KEY_LIST_OF_CREATED_HUBS[1].id}   |
#    Then DB Operator verify path for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in shipment_paths table
#    Then DB Operator verify inbound type "SHIPMENT_VAN_INBOUND" for shipment "{KEY_CREATED_SHIPMENT_ID}" appear in trip_shipment_scans table
#
#  @DeleteShipment @ForceSuccessOrder @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: Scan Shipment That Is Not Expected to Be Scanned to Van Inbound (uid:6ea2db1e-c863-4f5e-908b-f99298ecef6a)
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
#      | facilityType | CROSSDOCK |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator verify new Hubs are created
#    And API Operator reloads hubs cache
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
#    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[3].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator put created parcel to shipment
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator assign driver to movement trip schedule
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[1].name}                                                          |
#      | inboundType          | Into Van                                                                                    |
#      | driver               | {KEY_CREATED_DRIVER.firstName}{KEY_CREATED_DRIVER.lastName} ({KEY_CREATED_DRIVER.username}) |
#      | movementTripSchedule | {KEY_MOVEMENT_TRIP_DETAIL_SHIPMENT_SCANNING}                                                |
#    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
#    Then Operator verifies toast with message containing "Shipment {KEY_CREATED_SHIPMENT_ID} is [Pending], but scanned at [{KEY_LIST_OF_CREATED_HUBS[1].name}], please inbound into van in" is shown on Shipment Inbound Scanning page
#    And Operator verifies Scan Shipment Container color is "#ffe7ec"
#    When Operator clicks end inbound button
#    And Operator clicks proceed in end inbound dialog
#    Then Operator verifies toast with message "Trip {KEY_CURRENT_MOVEMENT_TRIP_ID} has departed." is shown on Shipment Inbound Scanning page
#    When Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_CREATED_SHIPMENT_ID} |
#    Then Operator verify parameters of shipment on Shipment Management page using data below:
#      | id          | {KEY_CREATED_SHIPMENT_ID}          |
#      | origHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
#      | currHubName | {KEY_LIST_OF_CREATED_HUBS[3].name} |
#      | status      | Pending                            |

#  @DeleteShipment @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: View Transit Shipment To Go With Trip for Van Inbound (uid:fe6d3ffe-552a-4020-9e64-d766abb387a6)
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
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    And API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator create new "STATIONS" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
#    Given API Operator shipment inbound scan with trip with data below:
#      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}                               |
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | hubSystemId    | sg                                                      |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_VAN_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
#      | movementTripSchedule | To {KEY_LIST_OF_CREATED_HUBS[3].name}, Departure                                                                                |
#    Then Operator verifies shipment to go with trip is shown with total "1"
#    When Operator clicks shipment to go with trip
#    Then Operator verifies shipment to go with trip with data below:
#      | shipmentCount  | 1                                  |
#      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
#      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | dropOffHub     | {KEY_LIST_OF_CREATED_HUBS[2].name} |
#      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
#      | comments       | Shipment added to trip             |
#    When Operator clicks shipment with id "{KEY_CREATED_SHIPMENT_ID}"
#    Then Operator verifies it will direct to shipment details page for shipment "{KEY_CREATED_SHIPMENT_ID}"

#  @DeleteShipment @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: View At Transit Hub Shipment To Go With Trip for Van Inbound (uid:fa98b89c-b2a6-4896-a711-75e1e12bc309)
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
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    And API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator create new "STATIONS" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
#    Given API Operator shipment inbound scan with trip with data below:
#      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}                               |
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_VAN_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
#    Given API Operator shipment inbound scan with trip with data below:
#      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}                               |
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_HUB_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].name}                                                                                              |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
#    Then Operator verifies shipment to go with trip is shown with total "1"
#    When Operator clicks shipment to go with trip
#    Then Operator verifies shipment to go with trip with data below:
#      | shipmentCount  | 1                                  |
#      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
#      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | dropOffHub     | -                                  |
#      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
#      | comments       | -                                  |
#    When Operator clicks shipment with id "{KEY_CREATED_SHIPMENT_ID}"
#    Then Operator verifies it will direct to shipment details page for shipment "{KEY_CREATED_SHIPMENT_ID}"

#  @DeleteShipment @DeleteDriver @SoftDeleteHubViaDb
#  Scenario: View Many Shipments To Go With Trip for Van Inbound (uid:bccb666c-c8b3-406a-87cd-c00886ad77ae)
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
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    And API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
#    Given API Operator create multiple 10 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And API Operator create new "STATIONS" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
#    Given API Operator shipment inbound scan all created shipments with data below:
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_VAN_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#    And API Operator shipment end inbound with trip with data below:
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_VAN_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
#    And API Operator shipment inbound scan with trip with data below:
#      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[10]}                   |
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_HUB_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#    And API Operator shipment end inbound with trip with data below:
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | actionType     | ADD                                                     |
#      | scanType       | SHIPMENT_HUB_INBOUND                                    |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
#    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
#      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
#      | inboundType          | Into Van                                                                                                                        |
#      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
#      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
#    Then Operator verifies shipment to go with trip is shown with total "10"
#    When Operator clicks shipment to go with trip
#    Then Operator verifies created shipments data in shipment to go with trip with data below:
#      | shipmentCount  | 10                                 |
#      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | dropOffHub     | {KEY_LIST_OF_CREATED_HUBS[2].name} |
#      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[3].name} |
#      | comments       | Shipment added to trip             |
#    Then Operator verifies it able to scroll into row with shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    When Operator clicks shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
#    Then Operator verifies it will direct to shipment details page for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"

  @DeleteShipment @DeleteDriver @SoftDeleteHubViaDb
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
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create multiple 10 new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator create new "STATIONS" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[2].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[3].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[2].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given API Operator shipment inbound scan all created shipments with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_VAN_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    And API Operator shipment inbound scan with trip with data below:
      | shipmentId     | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[10]}                   |
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_HUB_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And API Operator shipment end inbound with trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | actionType     | ADD                                                     |
      | scanType       | SHIPMENT_HUB_INBOUND                                    |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
      | driverId       | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                     |
    When Operator inbound scanning Into Van Shipment Inbound Scanning page with data below:
      | inboundHub           | {KEY_LIST_OF_CREATED_HUBS[2].id} - {KEY_LIST_OF_CREATED_HUBS[2].name}                                                           |
      | inboundType          | Into Van                                                                                                                        |
      | driver               | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}{KEY_LIST_OF_CREATED_DRIVERS[2].lastName} ({KEY_LIST_OF_CREATED_DRIVERS[2].username}) |
      | movementTripSchedule | {KEY_LIST_OF_CREATED_HUBS[3].name}                                                                                              |
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


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op