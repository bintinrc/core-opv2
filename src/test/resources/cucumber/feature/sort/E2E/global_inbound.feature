@Sort @Routing @E2EPGlobalInbound
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Global Inbound Parcel With Changes in size - e2e (uid:b84edf3c-a535-4e0c-9bc8-c092b9c9c64b)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-3}                               |
      | trackingId   | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideSize | S                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator make sure size changed to "S"
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Global Inbound Parcel With Changes In Weight - e2e (uid:e1cc9a06-a6e4-4e0e-8b8c-aafb675fbac1)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 7                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Then Operator verifies dimensions information on Edit Order page:
      | weight | 7 |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Global Inbound With Changes In Dimension - e2e (uid:dcd01994-7c0a-4850-bc2a-7153476b91e1)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-3}                               |
      | trackingId        | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideDimHeight | 2                                          |
      | overrideDimWidth  | 3                                          |
      | overrideDimLength | 5                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Global Inbound Override The Weight And Recalculate The Price - e2e (uid:463c843d-0e0d-4e9d-9c58-82b6541425e8)
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from": {"name": "QA-SO-Test-UIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "22 Chuan Hoe Ave, Singapore 549854","address2": "","country": "SG","postcode": "549854","latitude":1.284711,"longitude":103.809378}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 70                                         |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And API Operator get order details
    Then API Operator verify order info after Global Inbound
    When API Operator save current order cost
    When API Operator recalculate order price
    When API Operator verify the order price is updated
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Then Operator verifies dimensions information on Edit Order page:
      | weight | 70 |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Order Tagging with Global Inbound - Total tags is less/equal 4 - e2e (uid:fd80fe31-4be0-4b43-91ee-035faa84c72b)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | tags       | OPV2AUTO1,OPV2AUTO2,OPV2AUTO3              |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Order Tagging with Global Inbound - Total tags is more than 4 - e2e (uid:93503331-909a-466f-9dae-50a9b43a1dd2)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | tags       | OPV2AUTO1,OPV2AUTO2,OPV2AUTO3,SORTAUTO02   |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And Operator verify failed tagging error toast is shown
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | PRIOR |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Global Inbound On Hold Order - Resolve PENDING MISSING Ticket Type - e2e (uid:5cf67989-15c7-492f-8abe-6d6fd3efc336)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    When API Operator create recovery ticket using data below:
      | ticketType              | 2                           |
      | entrySource             | 1                           |
      | investigatingParty      | 448                         |
      | investigatingHubId      | 1                           |
      | outcomeName             | ORDER OUTCOME (MISSING)     |
      | outComeValue            | REPACKED/RELABELLED TO SEND |
      | comments                | Automation Testing.         |
      | shipperZendeskId        | 1                           |
      | ticketNotes             | Automation Testing.         |
      | issueDescription        | Automation Testing.         |
      | creatorUserId           | 106307852128204474889       |
      | creatorUserName         | Niko Susanto                |
      | creatorUserEmail        | niko.susanto@ninjavan.co    |
      | TicketCreationSource    | TICKET_MANAGEMENT           |
      | ticketTypeId            | 17                          |
      | entrySourceId           | 13                          |
      | trackingIdFieldId       | 2                           |
      | investigatingPartyId    | 15                          |
      | investigatingHubFieldId | 67                          |
      | outcomeNameId           | 64                          |
      | commentsId              | 26                          |
      | shipperZendeskFieldId   | 36                          |
      | ticketNotesId           | 32                          |
      | issueDescriptionId      | 45                          |
      | creatorUserFieldId      | 30                          |
      | creatorUserNameId       | 39                          |
      | creatorUserEmailId      | 66                          |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator removes all ticket status filters
    And Operator enters the Tracking Id
    And Operator chooses Created At Filter
      | toDate | {gradle-next-1-day-yyyy-MM-dd} |
    Then Operator chooses the ticket status as "RESOLVED"
    And Operator enters the tracking id and verifies that is exists
    Then API Operator make sure "TICKET_RESOLVED" event is exist
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Global Inbound On Hold Order - DO NOT Resolve NON-MISSING ticket type - e2e (uid:77eaba9f-29f8-4882-a6a6-2c95ceaaaba5)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
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
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | ON HOLD - SHIPPER ISSUE |
      | rackInfo       | RECOVERY                |
      | color          | #e86161                 |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator removes all ticket status filters
    And Operator enters the Tracking Id
    Then Operator chooses the ticket status as "PENDING"
    And Operator enters the tracking id and verifies that is exists
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    When API Operator update recovery ticket status
      | status         | RESOLVED                         |
      | reporterName   | Niko susanto                     |
      | reporterId     | 106307852128204474889            |
      | reporterEmail  | niko.susanto@ninjavan.co         |
      | resolvedName   | ORDER OUTCOME (DUPLICATE PARCEL) |
      | resolvedValue  | REPACKED/RELABELLED TO SEND      |
      | StatusId       | 398                              |
      | resolvedNameId | 1232677                          |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op