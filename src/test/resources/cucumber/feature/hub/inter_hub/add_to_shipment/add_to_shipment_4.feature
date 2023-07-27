@OperatorV2 @MiddleMile @Hub @InterHub @AddToShipment4
Feature: Add To Shipment 4

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments @ForceSuccessOrder
  Scenario: Add Completed Parcel to Shipment (uid:b703c8fe-a10f-4b92-b4c7-1afb577164e5)
	Given Operator go to menu Utilities -> QRCode Printing
	And API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator force created order status to Completed
	And DB Operator gets Hub ID by Hub Name of created parcel
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
	When Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_CREATED_ORDER.destinationHub}
	And Operator close the shipment which has been created

  @DeleteCreatedShipments @ForceSuccessOrder
  Scenario: Add Arrived at Sorting Hub to Shipment (uid:4a1176a8-bb81-4713-8d4d-78f0eb7c625a)
	Given Operator go to menu Utilities -> QRCode Printing
	And API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{hub-id} } |
	And DB Operator gets Hub ID by Hub Name of created parcel
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
	When Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_CREATED_ORDER.destinationHub}
	And Operator close the shipment which has been created

  @DeleteCreatedShipments @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Add Pending Reschedule Parcel to Shipment (uid:63b05de8-14e2-4ea0-8b66-7d4ec1a4746b)
	Given Operator go to menu Utilities -> QRCode Printing
	And API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{hub-id} } |
	And API Operator create new route using data below:
	  | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
	And API Operator add parcel to the route using data below:
	  | addParcelToRouteRequest | { "type":"DD" } |
	And API Driver collect all his routes
	And API Driver get pickup/delivery waypoint of the created order
	And API Operator Van Inbound parcel
	And API Operator start the route
	And API Driver failed the delivery of the created parcel
	And DB Operator gets Hub ID by Hub Name of created parcel
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
	When Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_CREATED_ORDER.destinationHub}
	And Operator close the shipment which has been created

  @DeleteCreatedShipments @DeleteOrArchiveRoute @ForceSuccessOrder
  Scenario: Add Returned to Sender Parcel to Shipment (uid:c9a90e68-17e2-42b8-b527-a45010410e88)
	Given Operator go to menu Utilities -> QRCode Printing
	And API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{hub-id} } |
	And API Operator create new route using data below:
	  | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
	And API Operator add parcel to the route using data below:
	  | addParcelToRouteRequest | { "type":"DD" } |
	And API Driver collect all his routes
	And API Driver get pickup/delivery waypoint of the created order
	And API Operator Van Inbound parcel
	And API Operator start the route
	And API Driver failed the delivery of the created parcel
	And API Operator RTS created order:
	  | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
	And DB Operator gets Hub ID by Hub Name of created parcel
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
	When Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_CREATED_ORDER.destinationHub}
	And Operator close the shipment which has been created

  @DeleteCreatedShipments @ForceSuccessOrder
  Scenario: Add On Hold Non Missing Parcel to Shipment (uid:0dd82e6d-3bf3-4343-9295-3b739733be11)
	Given Operator go to menu Utilities -> QRCode Printing
	And API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator create recovery ticket using data below:
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
	And DB Operator gets Hub ID by Hub Name of created parcel
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
	When Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_CREATED_ORDER.destinationHub}
	And Operator close the shipment which has been created

  @HappyPath @DeleteCreatedShipments @ForceSuccessOrder
  Scenario: Add Parcel with Tag to Shipment (uid:3d303265-3fae-445e-a59b-982a9d1f281d)
	Given Operator go to menu Utilities -> QRCode Printing
	And API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Shipper tags "{KEY_CREATED_ORDER_ID}" parcel with following tags:
	  | {order-tag-id}   |
	  | {order-tag-id-2} |
	  | {order-tag-id-3} |
	And API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{hub-id} } |
	And DB Operator gets Hub ID by Hub Name of created parcel
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
	When Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_CREATED_ORDER.destinationHub}
	Then Operator verifies tags are displayed on Add to Shipment page:
	  | {order-tag-name}   |
	  | {order-tag-name-2} |
	  | {order-tag-name-3} |
	When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
	Then Operator verify order status is "Transit" on Edit Order page
	And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
	And Operator verify order event on Edit order page using data below:
	  | name        | ADDED TO SHIPMENT                                                                                              |
	  | hubName     | {hub-name}                                                                                                     |
	  | description | Shipment {KEY_CREATED_SHIPMENT_ID} bound for Hub {KEY_DESTINATION_HUB_ID} ({KEY_CREATED_ORDER.destinationHub}) |
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                           |
	  | id           | {KEY_CREATED_SHIPMENT_ID}          |
	  | status       | Pending                            |
	  | origHubName  | {hub-name}                         |
	  | currHubName  | {hub-name}                         |
	  | destHubName  | {KEY_CREATED_ORDER.destinationHub} |
	  | ordersCount  | 1                                  |

  @DeleteCreatedShipments @ForceSuccessOrder
  Scenario: Close Shipment without Print Shipment Label - Single 70x50 mm
	Given Operator go to menu Utilities -> QRCode Printing
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	When Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
	Then Operator verifies shipment label settings are "Single, 70 x 50 mm, No print when closing" on Add to Shipment page
	When Operator set shipment label sticker settings on Add to Shipment page:
	  | version | Single     |
	  | size    | 70 x 50 mm |
	Then Operator verifies shipment label settings are "Single, 70 x 50 mm, No print when closing" on Add to Shipment page
	And Operator close the shipment which has been created
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | id     | {KEY_CREATED_SHIPMENT_ID} |
	  | status | Closed                    |

  @DeleteCreatedShipments @ForceSuccessOrder
  Scenario: Close Shipment without Print Shipment Label - Folded 70x50 mm
	Given Operator go to menu Utilities -> QRCode Printing
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	When Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
	When Operator set shipment label sticker settings on Add to Shipment page:
	  | version | Folded     |
	  | size    | 70 x 50 mm |
	Then Operator verifies shipment label settings are "Folded, 70 x 50 mm, No print when closing" on Add to Shipment page
	And Operator close the shipment which has been created
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | id     | {KEY_CREATED_SHIPMENT_ID} |
	  | status | Closed                    |

  @DeleteCreatedShipments @ForceSuccessOrder
  Scenario: Close Shipment without Print Shipment Label - Single 100x150 mm
	Given Operator go to menu Utilities -> QRCode Printing
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	When Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
	When Operator set shipment label sticker settings on Add to Shipment page:
	  | version | Single       |
	  | size    | 100 x 150 mm |
	Then Operator verifies shipment label settings are "Single, 100 x 150 mm, No print when closing" on Add to Shipment page
	And Operator close the shipment which has been created
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | id     | {KEY_CREATED_SHIPMENT_ID} |
	  | status | Closed                    |

  @DeleteCreatedShipments @ForceSuccessOrder
  Scenario: Close Shipment without Print Shipment Label - Folded 100x150 mm
	Given Operator go to menu Utilities -> QRCode Printing
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	When Operator go to menu Inter-Hub -> Add To Shipment
	Then Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
	When Operator set shipment label sticker settings on Add to Shipment page:
	  | version | Folded       |
	  | size    | 100 x 150 mm |
	Then Operator verifies shipment label settings are "Folded, 100 x 150 mm, No print when closing" on Add to Shipment page
	And Operator close the shipment which has been created
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | id     | {KEY_CREATED_SHIPMENT_ID} |
	  | status | Closed                    |

  @DeleteCreatedShipments
  Scenario: Create New Shipment - with selected origin hub
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Add To Shipment
	And Operator select values on Add to Shipment page:
	  | originHub | {hub-name} |
	And Operator clicks Create Shipment on Add to Shipment page
	Then Operator verifies fields in Create Shipment modal on Add to Shipment page:
	  | originHub | {hub-name} |
	When Operator set values in Create Shipment modal on Add to Shipment page:
	  | destinationHub | {hub-name-2}                                        |
	  | shipmentType   | Air Haul                                            |
	  | comments       | created by AT {gradle-current-date-yyyyMMddHHmmsss} |
	And Operator clicks Create Shipment in Create Shipment modal on Add to Shipment page
	Then Operator verifies that Created new shipment notification displayed
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType    | AIR_HAUL                                            |
	  | id              | {KEY_CREATED_SHIPMENT_ID}                           |
	  | userId          | {operator-portal-uid}                               |
	  | entrySource     | MANUAL                                              |
	  | createdAt       | ^{gradle-current-date-yyyy-MM-dd}.*                 |
	  | transitAt       | null                                                |
	  | status          | Pending                                             |
	  | origHubName     | {hub-name}                                          |
	  | currHubName     | {hub-name}                                          |
	  | destHubName     | {hub-name-2}                                        |
	  | arrivalDatetime | null                                                |
	  | sla             | null                                                |
	  | ordersCount     | 0                                                   |
	  | comments        | created by AT {gradle-current-date-yyyyMMddHHmmsss} |
	  | mawb            | null                                                |

  @DeleteCreatedShipments
  Scenario: Create New Shipment - with selected destination hub
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Add To Shipment
	And Operator select values on Add to Shipment page:
	  | destinationHub | {hub-name-2} |
	And Operator clicks Create Shipment on Add to Shipment page
	Then Operator verifies fields in Create Shipment modal on Add to Shipment page:
	  | destinationHub | {hub-name-2} |
	When Operator set values in Create Shipment modal on Add to Shipment page:
	  | originHub    | {hub-name}                                          |
	  | shipmentType | Air Haul                                            |
	  | comments     | created by AT {gradle-current-date-yyyyMMddHHmmsss} |
	And Operator clicks Create Shipment in Create Shipment modal on Add to Shipment page
	Then Operator verifies that Created new shipment notification displayed
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType    | AIR_HAUL                                            |
	  | id              | {KEY_CREATED_SHIPMENT_ID}                           |
	  | userId          | {operator-portal-uid}                               |
	  | entrySource     | MANUAL                                              |
	  | createdAt       | ^{gradle-current-date-yyyy-MM-dd}.*                 |
	  | transitAt       | null                                                |
	  | status          | Pending                                             |
	  | origHubName     | {hub-name}                                          |
	  | currHubName     | {hub-name}                                          |
	  | destHubName     | {hub-name-2}                                        |
	  | arrivalDatetime | null                                                |
	  | sla             | null                                                |
	  | ordersCount     | 0                                                   |
	  | comments        | created by AT {gradle-current-date-yyyyMMddHHmmsss} |
	  | mawb            | null                                                |

  @DeleteCreatedShipments
  Scenario Outline: Create New Shipment - with selected shipment type - <shipmentType>
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Add To Shipment
	And Operator select values on Add to Shipment page:
	  | shipmentType | <shipmentTypeTable> |
	And Operator clicks Create Shipment on Add to Shipment page
	Then Operator verifies fields in Create Shipment modal on Add to Shipment page:
	  | shipmentType | <shipmentType> |
	When Operator set values in Create Shipment modal on Add to Shipment page:
	  | originHub      | {hub-name}                                          |
	  | destinationHub | {hub-name-2}                                        |
	  | comments       | created by AT {gradle-current-date-yyyyMMddHHmmsss} |
	And Operator clicks Create Shipment in Create Shipment modal on Add to Shipment page
	Then Operator verifies that Created new shipment notification displayed
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType    | <shipmentTypeTable>                                 |
	  | id              | {KEY_CREATED_SHIPMENT_ID}                           |
	  | userId          | {operator-portal-uid}                               |
	  | entrySource     | MANUAL                                              |
	  | createdAt       | ^{gradle-current-date-yyyy-MM-dd}.*                 |
	  | transitAt       | null                                                |
	  | status          | Pending                                             |
	  | origHubName     | {hub-name}                                          |
	  | currHubName     | {hub-name}                                          |
	  | destHubName     | {hub-name-2}                                        |
	  | arrivalDatetime | null                                                |
	  | sla             | null                                                |
	  | ordersCount     | 0                                                   |
	  | comments        | created by AT {gradle-current-date-yyyyMMddHHmmsss} |
	  | mawb            | null                                                |
	Examples:
	  | shipmentType | shipmentTypeTable |
	  | Air Haul     | AIR_HAUL          |
	  | Land Haul    | LAND_HAUL         |
	  | Sea Haul     | SEA_HAUL          |
	  | Others       | OTHERS            |

  @HappyPath @DeleteCreatedShipments
  Scenario: Create New Shipment - with selected all mandatory fields
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Add To Shipment
	And Operator select values on Add to Shipment page:
	  | originHub      | {hub-name}   |
	  | destinationHub | {hub-name-2} |
	  | shipmentType   | AIR_HAUL     |
	And Operator clicks Create Shipment on Add to Shipment page
	Then Operator verifies fields in Create Shipment modal on Add to Shipment page:
	  | originHub      | {hub-name}   |
	  | destinationHub | {hub-name-2} |
	  | shipmentType   | Air Haul     |
	When Operator set values in Create Shipment modal on Add to Shipment page:
	  | comments | created by AT {gradle-current-date-yyyyMMddHHmmsss} |
	And Operator clicks Create Shipment in Create Shipment modal on Add to Shipment page
	Then Operator verifies that Created new shipment notification displayed
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType    | AIR_HAUL                                            |
	  | id              | {KEY_CREATED_SHIPMENT_ID}                           |
	  | userId          | {operator-portal-uid}                               |
	  | entrySource     | MANUAL                                              |
	  | createdAt       | ^{gradle-current-date-yyyy-MM-dd}.*                 |
	  | transitAt       | null                                                |
	  | status          | Pending                                             |
	  | origHubName     | {hub-name}                                          |
	  | currHubName     | {hub-name}                                          |
	  | destHubName     | {hub-name-2}                                        |
	  | arrivalDatetime | null                                                |
	  | sla             | null                                                |
	  | ordersCount     | 0                                                   |
	  | comments        | created by AT {gradle-current-date-yyyyMMddHHmmsss} |
	  | mawb            | null                                                |

  @HappyPath @DeleteCreatedShipments
  Scenario: Create New Shipment - without selected any fields
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Add To Shipment
	And Operator clicks Create Shipment on Add to Shipment page
	And Operator set values in Create Shipment modal on Add to Shipment page:
	  | originHub      | {hub-name}                                          |
	  | destinationHub | {hub-name-2}                                        |
	  | shipmentType   | Air Haul                                            |
	  | comments       | created by AT {gradle-current-date-yyyyMMddHHmmsss} |
	And Operator clicks Create Shipment in Create Shipment modal on Add to Shipment page
	Then Operator verifies that Created new shipment notification displayed
	And Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType    | AIR_HAUL                                            |
	  | id              | {KEY_CREATED_SHIPMENT_ID}                           |
	  | userId          | {operator-portal-uid}                               |
	  | entrySource     | MANUAL                                              |
	  | createdAt       | ^{gradle-current-date-yyyy-MM-dd}.*                 |
	  | transitAt       | null                                                |
	  | status          | Pending                                             |
	  | origHubName     | {hub-name}                                          |
	  | currHubName     | {hub-name}                                          |
	  | destHubName     | {hub-name-2}                                        |
	  | arrivalDatetime | null                                                |
	  | sla             | null                                                |
	  | ordersCount     | 0                                                   |
	  | comments        | created by AT {gradle-current-date-yyyyMMddHHmmsss} |
	  | mawb            | null                                                |

  @DeleteCreatedShipments
  Scenario: Create New Shipment - with selected same origin and destination hub
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Add To Shipment
	And Operator clicks Create Shipment on Add to Shipment page
	And Operator set values in Create Shipment modal on Add to Shipment page:
	  | originHub      | {hub-name} |
	  | destinationHub | {hub-name} |
	Then Operator verifies same hubs alert in Create Shipment modal on Add to Shipment page
	And Operator verifies Create Shipment button is disabled in Create Shipment modal on Add to Shipment page

  @HappyPath @DeleteCreatedShipments @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Can not create new shipment using virtual hubs
	Given Operator go to menu Utilities -> QRCode Printing
	And API Operator creates new Hub using data below:
	  | name         | GENERATED  |
	  | displayName  | GENERATED  |
	  | facilityType | CROSSDOCK  |
	  | city         | GENERATED  |
	  | country      | GENERATED  |
	  | latitude     | GENERATED  |
	  | longitude    | GENERATED  |
	  | parentHub    | {hub-name} |
	  | parentHubId  | {hub-id}   |
	  | virtual      | true       |
	When Operator go to menu Inter-Hub -> Add To Shipment
	And Operator clicks Create Shipment on Add to Shipment page
	Then Operator verifies "{KEY_CREATED_HUB.name}" Origin Hub is not shown in Create Shipment modal on Add to Shipment page
	Then Operator verifies "{KEY_CREATED_HUB.name}" Destination Hub is not shown in Create Shipment modal on Add to Shipment page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op