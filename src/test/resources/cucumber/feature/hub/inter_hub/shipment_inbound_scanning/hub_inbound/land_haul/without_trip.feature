@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithoutTrip
Feature: Shipment Hub Inbound Without Trip Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteShipment
  Scenario: Hub Inbound Pending Shipment In Destination Hub (uid:69f49406-b51b-4629-bf0e-5291cff60d28)
	Given Operator go to menu Utilities -> QRCode Printing
	When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                  |
	  | id           | {KEY_CREATED_SHIPMENT_ID} |
	  | status       | Completed                 |
	  | userId       | {operator-portal-uid}     |
	  | origHubName  | {hub-name}                |
	  | currHubName  | {hub-name-2}              |
	  | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Hub Inbound Pending Shipment Not In Destination Hub (uid:a3a982d6-0e94-4d2a-8fec-f61a9b0f4930)
	Given Operator go to menu Utilities -> QRCode Printing
	When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                  |
	  | id           | {KEY_CREATED_SHIPMENT_ID} |
	  | status       | At Transit Hub            |
	  | userId       | {operator-portal-uid}     |
	  | origHubName  | {hub-name}                |
	  | currHubName  | {hub-name}                |
	  | destHubName  | {hub-name-2}              |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Hub Inbound Closed Shipment In Destination Hub (uid:e4b180de-b6f4-401b-84fa-3388a53342cc)
	Given Operator go to menu Utilities -> QRCode Printing
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	Given API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{hub-id} } |
	When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given Operator go to menu Inter-Hub -> Add To Shipment
	When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
	And Operator close the shipment which has been created
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                  |
	  | id           | {KEY_CREATED_SHIPMENT_ID} |
	  | status       | Closed                    |
	  | userId       | {operator-portal-uid}     |
	  | origHubName  | {hub-name}                |
	  | currHubName  | {hub-name}                |
	  | destHubName  | {hub-name-2}              |
	When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                  |
	  | id           | {KEY_CREATED_SHIPMENT_ID} |
	  | status       | Completed                 |
	  | userId       | {operator-portal-uid}     |
	  | origHubName  | {hub-name}                |
	  | currHubName  | {hub-name-2}              |
	  | destHubName  | {hub-name-2}              |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Hub Inbound Closed Shipment Not In Destination Hub (uid:44e84034-0171-4feb-83a9-0f2f15ba0482)
	Given Operator go to menu Utilities -> QRCode Printing
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	Given API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{hub-id} } |
	When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given Operator go to menu Inter-Hub -> Add To Shipment
	When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
	And Operator close the shipment which has been created
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                  |
	  | id           | {KEY_CREATED_SHIPMENT_ID} |
	  | status       | Closed                    |
	  | userId       | {operator-portal-uid}     |
	  | origHubName  | {hub-name}                |
	  | currHubName  | {hub-name}                |
	  | destHubName  | {hub-name-2}              |
	When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | shipmentType | AIR_HAUL                  |
	  | id           | {KEY_CREATED_SHIPMENT_ID} |
	  | status       | At Transit Hub            |
	  | userId       | {operator-portal-uid}     |
	  | origHubName  | {hub-name}                |
	  | currHubName  | {hub-name}                |
	  | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Hub Inbound Pending Shipment In Other Country (uid:9e17df8b-32ee-4ef9-8e3d-086c99c5330f)
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Singapore"
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	When Operator change the country to "Indonesia"
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator inbound scanning Shipment Into Hub in hub {hub-name-temp} on Shipment Inbound Scanning page
	Then Operator verify small message "Mismatched hub system ID: shipment destination hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Singapore"

  @DeleteShipment @ForceSuccessOrder
  Scenario: Hub Inbound Closed Shipment In Other Country (uid:82e16097-1c55-4c6c-b6c9-443f6da987d0)
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Singapore"
	Given API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	Given API Operator Global Inbound parcel using data below:
	  | globalInboundRequest | { "hubId":{hub-id} } |
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	When Operator create Shipment on Shipment Management page:
	  | origHubName | {hub-name}                                                          |
	  | destHubName | {hub-name-2}                                                        |
	  | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
	Given Operator go to menu Inter-Hub -> Add To Shipment
	When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
	And Operator close the shipment which has been created
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Indonesia"
	When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator inbound scanning Shipment Into Hub in hub {hub-name-temp} on Shipment Inbound Scanning page
	Then Operator verify small message "Mismatched hub system ID: shipment destination hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Hub Inbound Transit Shipment In Other Country (uid:55af1d76-d503-42f0-9f8d-1ee26c6a90b1)
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Singapore"
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Indonesia"
	When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator inbound scanning Shipment Into Hub in hub {hub-name-temp} on Shipment Inbound Scanning page
	Then Operator verify small message "Mismatched hub system ID: shipment destination hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Hub Inbound Completed Shipment In Other Country (uid:0d696345-fb79-43bd-9ea7-db003977e066)
	Given Operator go to menu Utilities -> QRCode Printing
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	When API Operator change the status of the shipment into "Completed"
	When Operator change the country to "Singapore"
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | id     | {KEY_CREATED_SHIPMENT_ID} |
	  | status | Completed                 |
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Indonesia"
	When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator inbound scanning Shipment Into Hub in hub {hub-name-temp} on Shipment Inbound Scanning page
	Then Operator verify small message "Mismatched hub system ID: shipment destination hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Hub Inbound Cancelled Shipment In Other Country (uid:850c0816-c8de-4e1d-888f-690fcc87e1e1)
	Given Operator go to menu Utilities -> QRCode Printing
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	When API Operator change the status of the shipment into "Cancelled"
	When Operator change the country to "Singapore"
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	Then Operator verify parameters of shipment on Shipment Management page:
	  | id     | {KEY_CREATED_SHIPMENT_ID} |
	  | status | Cancelled                 |
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Indonesia"
	When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
	When Operator inbound scanning Shipment Into Hub in hub {hub-name-temp} on Shipment Inbound Scanning page
	Then Operator verify small message "Mismatched hub system ID: shipment destination hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator change the country to "Singapore"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op