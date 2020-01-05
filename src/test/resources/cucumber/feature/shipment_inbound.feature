@ShipmentInbound @Shipment @MiddleMile @ForceNotHeadless
Feature: Shipment Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Shipment Inbound - Normal (Valid Tracking ID, Same Shipment) (uid:22256332-8766-4e7d-b14b-407e04141a5f)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = orderDestHubId
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub orderDestHubName on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub orderDestHubName of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator input the scanned Tracking ID inside the shipment
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inter-Hub -> Shipment Inbound
    When Operator selects the Hub = "orderDestHubName" and the Shipment ID
    And Operator clicks on Continue Button in Shipment Inbound Page
    And Operator inputs the "CREATED" Tracking ID in the Shipment Inbound Page
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | CREATED             |
      | driverName | {ninja-driver-name} |
      | color      | #73deec             |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |

  @DeleteShipment
  Scenario: Shipment Inbound - Normal (Prefix Using) (uid:e2373267-5be0-4ee4-9651-93592740d156)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = orderDestHubId
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub orderDestHubName on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub orderDestHubName of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator input the scanned Tracking ID inside the shipment
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inter-Hub -> Shipment Inbound
    When Operator selects the Hub = "orderDestHubName" and the Shipment ID
    And Operator clicks on Continue Button in Shipment Inbound Page
    And Operator inputs Tracking ID using prefix in the Shipment Inbound Page
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | CREATED             |
      | driverName | {ninja-driver-name} |
      | color      | #73deec             |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |

  @DeleteShipment
  Scenario: Shipment Inbound - Same Hub (No Route) (uid:a66c21aa-b06a-49a5-9a80-c3cb4abeb528)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = orderDestHubId
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub orderDestHubName on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub orderDestHubName of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator input the scanned Tracking ID inside the shipment
    And Operator go to menu Inter-Hub -> Shipment Inbound
    When Operator selects the Hub = "orderDestHubName" and the Shipment ID
    And Operator clicks on Continue Button in Shipment Inbound Page
    And Operator inputs the "CREATED" Tracking ID in the Shipment Inbound Page
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT ROUTED |
      | driverName | NIL        |
      | color      | #73deec    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |

  @DeleteShipment
  Scenario: Shipment Inbound - Invalid Tracking ID (uid:f0b77dd5-f9c8-49e1-9e0d-77e79f167542)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = orderDestHubId
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub orderDestHubName on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub orderDestHubName of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator input the scanned Tracking ID inside the shipment
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inter-Hub -> Shipment Inbound
    When Operator selects the Hub = "orderDestHubName" and the Shipment ID
    And Operator clicks on Continue Button in Shipment Inbound Page
    And Operator inputs the "RANDOMTID" Tracking ID in the Shipment Inbound Page
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT FOUND |
      | driverName | NIL       |
      | color      | #f45050   |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NIL     |
      | color    | #f45050 |
    Then Operator verify Destination Hub on Parcel Sweeper page using data below:
      | hubName | NOT FOUND |
      | color   | #f45050   |

  @DeleteShipment
  Scenario: Shipment Inbound - Routed Tracking ID (uid:21eba800-e004-4b4e-802a-286e5ad99535)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = orderDestHubId
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub orderDestHubName on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Global Inbound
    When Operator select the destination hub orderDestHubName of the shipment
    And Operator select the shipment type
    And Operator select the created shipment by Shipment ID
    And Operator click the add shipment button then continue
    And Operator input the scanned Tracking ID inside the shipment
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inter-Hub -> Shipment Inbound
    When Operator selects the Hub = "orderDestHubName" and the Shipment ID
    And Operator clicks on Continue Button in Shipment Inbound Page
    And Operator inputs the "CREATED" Tracking ID in the Shipment Inbound Page
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | CREATED             |
      | driverName | {ninja-driver-name} |
      | color      | #73deec             |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | FROM CREATED ORDER |
      | color    | #73deec            |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
