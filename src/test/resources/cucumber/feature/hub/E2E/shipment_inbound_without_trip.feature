@Hub @E2EShipmentInboundWithoutTrip
Feature: E2E Without Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment In Shipment Destination Hub - e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | 82602           |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":1116, "hubId":381, "vehicleId":19036, "driverId":1608 } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "opv2no1" and "Ninjitsu89"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | originHub      | {hub-name}                        |
      | destinationHub | {hub-name-2}                       |
      | shipmentType   | Land Haul                          |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator close shipment on Add to Shipment page
    And API Operator get shipment details by created shipment id
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id} - {hub-name}  |
      | inboundType          | Into Van               |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | status      | Transit                   |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id-2} - {hub-name-2}  |
      | inboundType          | Into Hub                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}                               |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}            |
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
      | name    | HUB INBOUND SCAN          |
      | hubName | {hub-name-2}              |
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


  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel with Missing Ticket In Shipment - e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | 82602           |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":1116, "hubId":381, "vehicleId":19036, "driverId":1608 } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "opv2no1" and "Ninjitsu89"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | originHub      | {hub-name}                        |
      | destinationHub | {hub-name-2}                       |
      | shipmentType   | Land Haul                          |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator close shipment on Add to Shipment page
    And API Operator get shipment details by created shipment id
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id} - {hub-name}  |
      | inboundType          | Into Van               |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | status      | Transit                   |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id-2} - {hub-name-2}  |
      | inboundType          | Into Hub                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
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
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}                               |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}            |
      | overrideSize | S                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    And Operator verify order event on Edit order page using data below:
      | name | TICKET RESOLVED |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator make sure size changed to "S"
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN          |
      | hubName | {hub-name-2}              |
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

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel with Non Missing Ticket In Shipment - e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | 82602           |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":1116, "hubId":381, "vehicleId":19036, "driverId":1608 } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "opv2no1" and "Ninjitsu89"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | originHub      | {hub-name}                        |
      | destinationHub | {hub-name-2}                       |
      | shipmentType   | Land Haul                          |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator close shipment on Add to Shipment page
    And API Operator get shipment details by created shipment id
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id} - {hub-name}  |
      | inboundType          | Into Van               |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | status      | Transit                   |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id-2} - {hub-name-2}  |
      | inboundType          | Into Hub                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
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
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}                               |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}            |
      | overrideSize | S                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | ON HOLD - SHIPPER ISSUE |
      | rackInfo       | RECOVERY                |
      | color          | #e86161                 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    When API Operator update recovery ticket status
      | status         | RESOLVED                         |
      | reporterName   | Niko susanto                     |
      | reporterId     | 106307852128204474889            |
      | reporterEmail  | niko.susanto@ninjavan.co         |
      | resolvedName   | ORDER OUTCOME (DUPLICATE PARCEL) |
      | resolvedValue  | REPACKED/RELABELLED TO SEND      |
      | StatusId       | 398                              |
      | resolvedNameId | 1232677                          |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}                               |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}            |
      | overrideSize | S                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    And Operator verify order event on Edit order page using data below:
      | name | TICKET RESOLVED |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    And Operator make sure size changed to "S"
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN          |
      | hubName | {hub-name-2}              |
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

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment In Shipment Destination Hub - Add to Existing Route - Fail Delivery -  e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | 82602           |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":1116, "hubId":381, "vehicleId":19036, "driverId":1608 } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "opv2no1" and "Ninjitsu89"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | originHub      | {hub-name}                        |
      | destinationHub | {hub-name-2}                       |
      | shipmentType   | Land Haul                          |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator close shipment on Add to Shipment page
    And API Operator get shipment details by created shipment id
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id} - {hub-name}  |
      | inboundType          | Into Van               |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | status      | Transit                   |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id-2} - {hub-name-2}  |
      | inboundType          | Into Hub                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}                               |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}            |
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
      | name    | HUB INBOUND SCAN          |
      | hubName | {hub-name-2}              |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_FAIL"
    And Operator verify order status is "Delivery fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment In Shipment Destination Hub - Add to Existing Route - Fail Delivery -  e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | 82602           |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":1116, "hubId":381, "vehicleId":19036, "driverId":1608 } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "opv2no1" and "Ninjitsu89"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | originHub      | {hub-name}                        |
      | destinationHub | {hub-name-2}                       |
      | shipmentType   | Land Haul                          |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator close shipment on Add to Shipment page
    And API Operator get shipment details by created shipment id
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id} - {hub-name}  |
      | inboundType          | Into Van               |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | status      | Transit                   |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id-2} - {hub-name-2}  |
      | inboundType          | Into Hub                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}                               |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}            |
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
      | name    | HUB INBOUND SCAN          |
      | hubName | {hub-name-2}              |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_FAIL"
    And Operator verify order status is "Delivery fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page


  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment In Shipment Destination Hub - Add to Existing Route - Success Delivery -  e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | 82602           |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":1116, "hubId":381, "vehicleId":19036, "driverId":1608 } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "opv2no1" and "Ninjitsu89"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | originHub      | {hub-name}                        |
      | destinationHub | {hub-name-2}                       |
      | shipmentType   | Land Haul                          |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator close shipment on Add to Shipment page
    And API Operator get shipment details by created shipment id
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id} - {hub-name}  |
      | inboundType          | Into Van               |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | status      | Transit                   |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id-2} - {hub-name-2}  |
      | inboundType          | Into Hub                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}                               |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}            |
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
      | name    | HUB INBOUND SCAN          |
      | hubName | {hub-name-2}              |
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


  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment In Shipment Destination Hub - Add to New Route - Success Delivery - e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | 82602           |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":1116, "hubId":381, "vehicleId":19036, "driverId":1608 } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "opv2no1" and "Ninjitsu89"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | originHub      | {hub-name}                        |
      | destinationHub | {hub-name-2}                       |
      | shipmentType   | Land Haul                          |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator close shipment on Add to Shipment page
    And API Operator get shipment details by created shipment id
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id} - {hub-name}  |
      | inboundType          | Into Van               |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | status      | Transit                   |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id-2} - {hub-name-2}  |
      | inboundType          | Into Hub                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}                               |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}            |
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
      | name    | HUB INBOUND SCAN          |
      | hubName | {hub-name-2}              |
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


  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment In Shipment Destination Hub - Add to Existing Route - Reversion Failed Delivery to Success - e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | 82602           |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":1116, "hubId":381, "vehicleId":19036, "driverId":1608 } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "opv2no1" and "Ninjitsu89"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | originHub      | {hub-name}                        |
      | destinationHub | {hub-name-2}                       |
      | shipmentType   | Land Haul                          |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator close shipment on Add to Shipment page
    And API Operator get shipment details by created shipment id
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id} - {hub-name}  |
      | inboundType          | Into Van               |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | status      | Transit                   |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id-2} - {hub-name-2}  |
      | inboundType          | Into Hub                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}                               |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}            |
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
      | name    | HUB INBOUND SCAN          |
      | hubName | {hub-name-2}              |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver fail all created parcels successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_FAIL"
    And Operator verify order status is "Delivery fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    When API Driver Reversion Failed Delivery to Success
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page


  @DeleteShipment @ForceSuccessOrder
  Scenario: Inbound Parcel In Completed Shipment In Shipment Destination Hub - Add to New Route - Reversion Failed Delivery to Success - e2e
    When API Operator create new shipper address V2 using data below:
      | shipperId       | 82602           |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":1116, "hubId":381, "vehicleId":19036, "driverId":1608 } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "opv2no1" and "Ninjitsu89"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | originHub      | {hub-name}                        |
      | destinationHub | {hub-name-2}                       |
      | shipmentType   | Land Haul                          |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
    And Operator close shipment on Add to Shipment page
    And API Operator get shipment details by created shipment id
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id} - {hub-name}  |
      | inboundType          | Into Van               |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | status      | Transit                   |
    Given Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator fill Shipment Inbound Scanning page with data below:
      | inboundHub           | {hub-id-2} - {hub-name-2}  |
      | inboundType          | Into Hub                   |
    And Operator click start inbound
    And Operator scan shipment with id "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "Last Scanned {KEY_CREATED_SHIPMENT_ID}" appears in Shipment Inbound Box
    When API Operator refresh created order data
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName      | {hub-name-2}                               |
      | trackingId   | {KEY_CREATED_ORDER_TRACKING_ID}            |
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
      | name    | HUB INBOUND SCAN          |
      | hubName | {hub-name-2}              |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver fail all created parcels successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_FAIL"
    And Operator verify order status is "Delivery fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    When API Driver Reversion Failed Delivery to Success
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op