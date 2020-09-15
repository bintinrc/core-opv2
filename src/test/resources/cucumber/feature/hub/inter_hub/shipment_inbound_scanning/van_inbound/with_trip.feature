@ShipmentInboundScanning @InterHub @Shipment @MiddleMile @VanInbound @WithoutTrip @refo
Feature: Shipment Inbound Scanning

#  @LaunchBrowser @ShouldAlwaysRun
#  Scenario: Login to Operator Portal V2
#    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @DeleteDriver @ForceSuccessOrder @SoftDeleteHubViaDb
  Scenario: Start Van Inbound After Select Driver and Trip (uid:26f6c205-bc90-4ce8-991f-77a95f38f4fe)
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
    And API Operator reloads hubs cache
    And API Operator verify new Hubs are created
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_LIST_OF_CREATED_HUBS[1].id} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator put created parcel to shipment
    Given API Operator create new

#    Given Operator success "create a trip"
#    Given Operator success "assign trip to driver"
#    Given Operator success "create a shipment"
#    Given Make sure "trip origin hub" is "same with shipment origin hub"
#    Given Operator open "Shipment Inbound Scanning" page
#    Then Make sure it will direct to "Shipment Inbound Scanning" page
#    When Operator search "trip's origin hub" as Inbound Hub
#    And Operator select Inbound Type "Into Van"
#    Then Make sure "Start Inbound" button is "enable"
#    When Operator search Driver's "name/username"
#    Then Make sure it show toast with message "Please select a trip before start inbound"
#    And Make sure "Start Inbound" button is "disable"
#    When Operator search "movement trip"
#    Then Make sure "Start Inbound" button is "enable"
#    When Operator click "Start Inbound" button
#    Then Make sure it will direct to "another Shipment Inbound Scanning" page
#    And Make sure "selected Inbound Hub" is shown
#    And Make sure "selected Inbound Type" is shown
#    And Make sure "selected Driver" is shown
#    And Make sure "selected Movement Trip" is shown
#    And Make sure "Movement Type" is shown
#    And Make sure "Origin/Destination hub" is shown
#    And Make sure "Departure Time" is shown
#    And Make sure "Existing Van Inbounded Shipments" is shown
#    And operator click
#    And Operator click "Start Van Inbound" button
#    And Make sure "" appear in ""

#  @DeleteShipment @DeleteOrArchiveRoute @ForceSuccessOrder
#  Scenario: Shipment Inbound - Normal (Valid Tracking ID, Same Shipment) (uid:22256332-8766-4e7d-b14b-407e04141a5f)
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    Given API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
#    Given DB Operator gets Hub ID by Hub Name of created parcel
#    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
#    Given API Operator put created parcel to shipment
#    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    And Operator inbound scanning Shipment Into Hub in hub {KEY_CREATED_ORDER.destinationHub} on Shipment Inbound Scanning page
#    Given Operator go to menu Inbounding -> Global Inbound
#    When Operator global inbounds parcel using data below:
#      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
#      | trackingId | GET_FROM_CREATED_ORDER             |
#    Then API Operator verify order info after Global Inbound
#    And API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}} |
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    When Operator go to menu Routing -> Parcel Sweeper Live
#    When Operator provides data on Parcel Sweeper Live page:
#      | hubName    | {KEY_CREATED_ORDER.destinationHub} |
#      | trackingId | CREATED                            |
#    Then Operator verify Route ID on Parcel Sweeper page using data below:
#      | routeId    | {KEY_CREATED_ROUTE_ID} |
#      | driverName | {ninja-driver-name}    |
#      | color      | #55a1e8                |
#    And DB Operator verify the order_events record exists for the created order with type:
#      | 32    |
#      | 27    |



#  @KillBrowser @ShouldAlwaysRun
#  Scenario: Kill Browser
#    Given no-op