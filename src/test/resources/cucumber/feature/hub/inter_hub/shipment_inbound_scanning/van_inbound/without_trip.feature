@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @VanInbound @WithoutTrip
Feature: Shipment Van Inbound Without Trip Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Van Inbound Completed Shipment In Origin Hub (uid:5cca1cbe-9ae1-4959-bb28-e257a961ec8b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Completed |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-id-2} on Shipment Inbound Scanning page with Completed alert

  @DeleteShipment
  Scenario: Van Inbound Completed Shipment Not In Origin Hub (uid:eab6d9b4-d433-41de-ae68-dfb2da3eb59e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} on Shipment Inbound Scanning page with Cancelled alert

  @DeleteShipment
  Scenario: Van Inbound Cancelled Shipment Not In Origin Hub (uid:a7c716a4-aa89-4af7-b9d0-8d9e37caf766)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page with Cancelled alert

  @DeleteShipment
  Scenario: Van Inbound Completed MAWB In Origin Hub (uid:75139085-89a3-4b01-b750-a82be8a6ccd9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    When API Operator change the status of the shipment into "Completed"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Completed on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB with Completed alert

  @DeleteShipment
  Scenario: Van Inbound Completed MAWB Not In Origin Hub (uid:d024a887-0568-46c9-936b-2201fbf27f84)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    When API Operator change the status of the shipment into "Completed"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Completed on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page using MAWB with Completed alert

  @DeleteShipment
  Scenario: Van Inbound Cancelled MAWB In Origin Hub (uid:7bbe70d1-6d97-4225-a205-5a18db8a88fd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    When API Operator change the status of the shipment into "Cancelled"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Cancelled on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB with Cancelled alert

  @DeleteShipment
  Scenario: Van Inbound Cancelled MAWB Not In Origin Hub (uid:1d9e2602-2905-4984-8393-95ad72fd156e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    When API Operator change the status of the shipment into "Cancelled"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Cancelled on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page using MAWB with Cancelled alert

  @DeleteShipment
  Scenario: Van Inbound Pending Shipment In Origin Hub (uid:12043574-7019-492d-a0f6-0b6147ad518b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Van Inbound Pending Shipment Not In Origin Hub (uid:7f3b7d1b-ece1-4db1-96d3-f0b78e2a8e6f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} on Shipment Inbound Scanning page with pending shipment alert
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Van Inbound Closed Shipment In Origin Hub (uid:b1066eda-3133-457c-904e-f4fc1515582a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
    And Operator close the shipment which has been created
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Closed on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Van Inbound Closed Shipment Not In Origin Hub (uid:ad08e9b7-6905-4c45-be60-03f9859d7f0a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
    And Operator close the shipment which has been created
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Closed on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} on Shipment Inbound Scanning page with closed shipment alert
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Van Inbound Pending MAWB In Origin Hub (uid:6a1d19cd-92aa-4ab8-b9ed-cb377ae6b1a4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page using MAWB
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Van Inbound Pending MAWB Not In Origin Hub (uid:af3cd16a-d73f-495e-b092-1079d6cdad0a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB with pending shipment alert
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Van Inbound Closed MAWB In Origin Hub (uid:b20634af-db8a-4af9-86be-fadfdc68f0a7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
    And Operator close the shipment which has been created
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page using MAWB
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Van Inbound Closed MAWB Not In Origin Hub (uid:9e442b48-ac2c-416b-97b0-c40c973cb2c7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
    And Operator close the shipment which has been created
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB with closed shipment alert
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Van Inbound Wrong Shipment (uid:9596ed71-8be2-4343-b7ad-e35544e6b819)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning wrong Shipment 1 Into Van in hub "{hub-name}" on Shipment Inbound Scanning page
    Then Operator verify error message in shipment inbound scanning is "shipment not found" for shipment "1"

  @DeleteShipment
  Scenario: Van Inbound Transit Shipment In Origin Hub (uid:43f4bacc-e862-4410-89b1-15be54463875)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    And Operator refresh page
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    Then Operator verify error message in shipment inbound scanning is "transit" for shipment "{KEY_CREATED_SHIPMENT_ID}"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | destHubName | {hub-name-2}              |
      | status      | Transit                   |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND   |
      | result | Transit                |
      | userId | automation@ninjavan.co |

  @DeleteShipment
  Scenario: Van Inbound Transit Shipment Not In Origin Hub (uid:b04b3727-aa95-488d-a65c-ee80513fa5df)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    And Operator refresh page
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} on Shipment Inbound Scanning page
    Then Operator verify error message in shipment inbound scanning is "transit" for shipment "{KEY_CREATED_SHIPMENT_ID}"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name-2}              |
      | destHubName | {hub-name-2}              |
      | status      | Transit                   |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND   |
      | result | Transit                |
      | userId | automation@ninjavan.co |

  @DeleteShipment
  Scenario: Van Inbound Pending Shipment In Other Country (uid:cfea52a0-fa58-4815-80a9-825f21efdd3a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator change the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} on Shipment Inbound Scanning page with different country van alert
    When Operator change the country to "Singapore"

  @DeleteShipment @ForceSuccessOrder
  Scenario: Van Inbound Closed Shipment In Other Country (uid:ae4f5350-9e37-4196-b176-f6511d70f6c1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
    And Operator close the shipment which has been created
    When Operator change the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} on Shipment Inbound Scanning page with different country van alert
    When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Van Inbound Transit Shipment In Other Country (uid:d633880e-39e0-4654-9411-87aae90ae478)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator change the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} on Shipment Inbound Scanning page with different country van alert
    When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Van Inbound Completed Shipment In Other Country (uid:71129ef4-306d-409c-bb5e-c65a18384714)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    When Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Completed |
    When Operator change the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} on Shipment Inbound Scanning page with different country van alert
    When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Van Inbound Cancelled Shipment In Other Country (uid:cb1c4d36-e9cb-489a-b36b-3bfd2d9eb7ba)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    When Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |
    When Operator change the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} on Shipment Inbound Scanning page with different country van alert
    When Operator change the country to "Singapore"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op