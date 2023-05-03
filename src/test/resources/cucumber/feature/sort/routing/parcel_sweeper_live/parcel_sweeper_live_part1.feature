@Sort @Routing @ParcelSweeperLive @ParcelSweeperLivePart1
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @happy-path
  Scenario: Parcel Sweeper Live - Pending Pickup (uid:2c161a4a-6452-4c70-8fb1-1bfc8f059ba3)
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Parcel Sweeper Live
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-not-inbounded} |
      | routeId               | Error                    |
      | routeInfoColor        | {white-hex-color}        |
      | driverName            | Not Inbounded            |
      | routeDescriptionColor | {white-hex-color}        |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page

  @CloseNewWindows @happy-path
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt unrouted (uid:27d72aac-23ad-4111-8b9f-e2a10c727f62)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"{country}","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor | {success-bg-inbound} |
    When DB Core - operator get waypoints details for "{KEY_CREATED_ORDER.transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_RTS_ZONE_TYPE.name}      |
      | zoneShortName | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
      | textColor     | {blue-hex-color}                   |
    When DB Sort - get next sorting task
      | zoneName   | {KEY_SORT_RTS_ZONE_TYPE.name} |
      | sourceName | {hub-name}                    |
    Then Operator verify Next Sorting Hub on Parcel Sweeper page using data below:
      | nextSortingHub | {KEY_SORT_NEXT_SORT_TASK} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {KEY_CREATED_ORDER.destinationHub} |
      | textColor | {dark-gray-hex-color}              |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub = physical hub, route's date = today (uid:ca0f7cf5-13ac-4265-934d-052136902ec7)
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"{country}","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    When API Operator refresh created order data
    And Operator refresh page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {success-bg-inbound}   |
      | routeId               | {KEY_CREATED_ROUTE_ID} |
      | routeInfoColor        | {blue-hex-color}       |
      | driverName            | {ninja-driver-name}    |
      | routeDescriptionColor | {dark-gray-hex-color}  |
    When DB Core - operator get waypoints details for "{KEY_CREATED_ORDER.transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_RTS_ZONE_TYPE.name}      |
      | zoneShortName | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
      | textColor     | {blue-hex-color}                   |
    When DB Sort - get next sorting task
      | zoneName   | {KEY_SORT_RTS_ZONE_TYPE.name} |
      | sourceName | {hub-name}                    |
    Then Operator verify Next Sorting Hub on Parcel Sweeper page using data below:
      | nextSortingHub | {KEY_SORT_NEXT_SORT_TASK} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | GLOBAL INBOUND        |
      | textColor | {dark-gray-hex-color} |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify the order_events record exists for the created order with type:
      | 31 |
      | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verifies event is present for order on Edit order page
      | eventName | OUTBOUND SCAN |
      | hubName   | {hub-name}    |
      | hubId     | {hub-id}      |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub different from physical hub, route's date = today (uid:2cc6f8a6-d783-46dd-8408-19f2de63dadd)
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"{country}","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    When API Operator refresh created order data
    And Operator refresh page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name-10} |
      | trackingId | CREATED       |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {success-bg-inbound}   |
      | routeId               | {KEY_CREATED_ROUTE_ID} |
      | routeInfoColor        | {blue-hex-color}       |
      | driverName            | {ninja-driver-name}    |
      | routeDescriptionColor | {dark-gray-hex-color}  |
    When DB Core - operator get waypoints details for "{KEY_CREATED_ORDER.transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_RTS_ZONE_TYPE.name}      |
      | zoneShortName | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
      | textColor     | {blue-hex-color}                   |
    When DB Sort - get next sorting task
      | zoneName   | {KEY_SORT_RTS_ZONE_TYPE.name} |
      | sourceName | {hub-name}                    |
    Then Operator verify Next Sorting Hub on Parcel Sweeper page using data below:
      | nextSortingHub | {KEY_SORT_NEXT_SORT_TASK} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | GLOBAL INBOUND        |
      | textColor | {dark-gray-hex-color} |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED     |
      | hubId      | {hub-id-10} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name-10}       |
      | hubId     | {hub-id-10}         |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub = physical hub, route's date is NOT today (uid:a7076aa8-6f42-4255-b5ac-1cc0aa79e3dd)
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"{country}","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-1-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-1-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    When API Operator refresh created order data
    And Operator refresh page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator refresh page
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-invalid}     |
      | routeId               | {KEY_CREATED_ROUTE_ID} |
      | routeInfoColor        | {white-hex-color}      |
      | driverName            | NOT ROUTED TODAY       |
      | routeDescriptionColor | {white-hex-color}      |
    When DB Core - operator get waypoints details for "{KEY_CREATED_ORDER.transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_RTS_ZONE_TYPE.name}      |
      | zoneShortName | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
      | textColor     | {white-hex-color}                  |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | GLOBAL INBOUND    |
      | textColor | {white-hex-color} |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub different from physical hub, route's date is NOT today (uid:6ef626ff-51d4-456d-9fb3-b0de0714dae1)
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"{country}","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-1-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-1-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    When API Operator refresh created order data
    And Operator refresh page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name-2} |
      | trackingId | CREATED      |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-invalid}     |
      | routeId               | {KEY_CREATED_ROUTE_ID} |
      | routeInfoColor        | {white-hex-color}      |
      | driverName            | NOT ROUTED TODAY       |
      | routeDescriptionColor | {white-hex-color}      |
    When DB Core - operator get waypoints details for "{KEY_CREATED_ORDER.transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_RTS_ZONE_TYPE.name}      |
      | zoneShortName | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
      | textColor     | {white-hex-color}                  |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {hub-name} |
      | textColor | #ffffff    |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED    |
      | hubId      | {hub-id-2} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name-2}        |
      | hubId     | {hub-id-2}          |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @CloseNewWindows @happy-path
  Scenario: Parcel Sweeper Live - RTS Order (uid:b2541a22-8243-41bf-8210-b558c83fb4be)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":"738078","country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator refresh created order data
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator refresh created order data
    When Operator refresh page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER.getId}"
    And Operator verifies Latest Event is "UPDATE AV" on Edit Order page
    And  Operator verify order delivery title is "Return to Sender" on Edit Order page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator refresh page
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify RTS label on Parcel Sweeper Live page
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | backgroundColor | {success-bg-inbound} |
    When DB Core - operator get waypoints details for "{KEY_CREATED_ORDER.transactions[3].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_RTS_ZONE_TYPE.name}      |
      | zoneShortName | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
      | textColor     | {blue-hex-color}                   |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | GLOBAL INBOUND        |
      | textColor | {dark-gray-hex-color} |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - On Hold Order - NON-MISSING TICKET (uid:481ea9da-b9bd-4718-a73d-04fcd515f80a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator create recovery ticket using data below:
      | ticketType              | 5                                |
      | subTicketType           | 9                                |
      | entrySource             | 1                                |
      | investigatingParty      | 448                              |
      | investigatingHubId      | 1                                |
      | outcomeName             | ORDER OUTCOME (DUPLICATE PARCEL) |
      | outComeValue            | REPACKED/RELABELLED TO SEND      |
      | comments                | Automation Testing.              |
      | shipperZendeskId        | 1                                |
      | ticketNotes             | Automation Testing.              |
      | issueDescription        | Automation Testing.              |
      | creatorUserId           | 106307852128204474889            |
      | creatorUserName         | Niko Susanto                     |
      | creatorUserEmail        | niko.susanto@ninjavan.co         |
      | TicketCreationSource    | TICKET_MANAGEMENT                |
      | ticketTypeId            | 17                               |
      | subTicketTypeId         | 17                               |
      | entrySourceId           | 13                               |
      | trackingIdFieldId       | 2                                |
      | investigatingPartyId    | 15                               |
      | investigatingHubFieldId | 67                               |
      | outcomeNameId           | 64                               |
      | commentsId              | 26                               |
      | shipperZendeskFieldId   | 36                               |
      | ticketNotesId           | 32                               |
      | issueDescriptionId      | 45                               |
      | creatorUserFieldId      | 30                               |
      | creatorUserNameId       | 39                               |
      | creatorUserEmailId      | 66                               |
    And API Operator refresh created order data
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-invalid} |
      | routeId               | Recovery           |
      | routeInfoColor        | {white-hex-color}  |
      | driverName            | On Hold            |
      | routeDescriptionColor | {white-hex-color}  |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And DB Operator verify ticket status
      | status | 1 |

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - On Hold Order - Resolve PENDING MISSING Ticket (uid:85edd7d1-f479-471a-bd26-563d387ca91e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator create recovery ticket using data below:
      | ticketType              | 2                        |
      | entrySource             | 1                        |
      | investigatingParty      | 448                      |
      | investigatingHubId      | 1                        |
      | outcomeName             | ORDER OUTCOME (MISSING)  |
      | comments                | Automation Testing.      |
      | shipperZendeskId        | 1                        |
      | ticketNotes             | Automation Testing.      |
      | issueDescription        | Automation Testing.      |
      | creatorUserId           | 106307852128204474889    |
      | creatorUserName         | Niko Susanto             |
      | creatorUserEmail        | niko.susanto@ninjavan.co |
      | TicketCreationSource    | TICKET_MANAGEMENT        |
      | ticketTypeId            | 17                       |
      | subTicketTypeId         | 17                       |
      | entrySourceId           | 13                       |
      | trackingIdFieldId       | 2                        |
      | investigatingPartyId    | 15                       |
      | investigatingHubFieldId | 67                       |
      | outcomeNameId           | 64                       |
      | commentsId              | 26                       |
      | shipperZendeskFieldId   | 36                       |
      | ticketNotesId           | 32                       |
      | issueDescriptionId      | 45                       |
      | creatorUserFieldId      | 30                       |
      | creatorUserNameId       | 39                       |
      | creatorUserEmailId      | 66                       |
    And API Operator refresh created order data
    And Operator refresh page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor | {success-bg-inbound} |
    When DB Core - operator get waypoints details for "{KEY_CREATED_ORDER.transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_RTS_ZONE_TYPE.name}      |
      | zoneShortName | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
      | textColor     | {blue-hex-color}                   |
    When DB Sort - get next sorting task
      | zoneName   | {KEY_SORT_RTS_ZONE_TYPE.name} |
      | sourceName | {hub-name}                    |
    Then Operator verify Next Sorting Hub on Parcel Sweeper page using data below:
      | nextSortingHub | {KEY_SORT_NEXT_SORT_TASK} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {KEY_CREATED_ORDER.destinationHub} |
      | textColor | {dark-gray-hex-color}              |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order event on Edit order page using data below:
      | name | TICKET RESOLVED |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And DB Operator verify ticket status
      | status | 3 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op