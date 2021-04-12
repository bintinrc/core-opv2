@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @HubInbound @WithoutTrip
Feature: Shipment Hub Inbound Without Trip Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Hub Inbound Transit Shipment Not In Destination Hub (uid:8dba78a8-564e-4296-bf12-59f533a5aae4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Hub Inbound Transit Shipment In Destination Hub (uid:c4fb9ebd-7928-4872-996d-b942be649b3d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Completed on Shipment Management page
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Hub Inbound Transit MAWB In Destination Hub (uid:2afb0308-c133-4b95-8c41-3dc84e454edc)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Completed on Shipment Management page
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Hub Inbound Completed Shipment In Destination Hub (uid:c902a96e-576e-4911-b3c2-651d3515efa7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator refresh page
    When API Operator change the status of the shipment into "Completed"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Completed |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page with Completed alert

  @DeleteShipment
  Scenario: Hub Inbound Completed Shipment Not In Destination Hub (uid:3eedde95-b367-4898-9ce1-a65427ac2241)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Completed |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page with Completed alert

  @DeleteShipment
  Scenario: Hub Inbound Cancelled Shipment In Destination Hub (uid:2af315a0-4d44-4004-a4fd-8228ef6ce55b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page with Cancelled alert

  @DeleteShipment
  Scenario: Hub Inbound Cancelled Shipment Not In Destination Hub (uid:5cd67385-6a4b-4d0b-9658-f81ebfac6dd5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page with Cancelled alert

  @DeleteShipment
  Scenario: Hub Inbound Completed MAWB In Destination Hub (uid:cf1439be-e2bf-48d4-81a0-d1b0ddb14d07)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB with Completed alert

  @DeleteShipment
  Scenario: Hub Inbound Completed MAWB Not In Destination Hub (uid:56d7f8b3-9734-4d7e-87d1-adcbaa8ac232)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page using MAWB with Completed alert

  @DeleteShipment
  Scenario: Hub Inbound Cancelled MAWB In Destination Hub (uid:6e3fb952-dfb6-44fd-b7c3-fe2c26c0b1a4)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB with Cancelled alert

  @DeleteShipment
  Scenario: Hub Inbound Cancelled MAWB Not In Destination Hub (uid:a9ed7efe-87a3-4c4c-9562-c87d8293fbd4)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page using MAWB with Cancelled alert

  @DeleteShipment
  Scenario: Hub Inbound Pending Shipment In Destination Hub (uid:69f49406-b51b-4629-bf0e-5291cff60d28)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Hub Inbound Pending Shipment Not In Destination Hub (uid:a3a982d6-0e94-4d2a-8fec-f61a9b0f4930)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Hub Inbound Closed Shipment In Destination Hub (uid:e4b180de-b6f4-401b-84fa-3388a53342cc)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Hub Inbound Closed Shipment Not In Destination Hub (uid:44e84034-0171-4feb-83a9-0f2f15ba0482)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Hub Inbound Pending MAWB In Destination Hub (uid:983fe4f9-fd46-486b-920c-abea23e34820)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Hub Inbound Pending MAWB Not In Destination Hub (uid:0ccc78fe-6921-45ef-b0e6-48fda469fd07)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page using MAWB
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Hub Inbound Closed MAWB In Destination Hub (uid:bba1b181-9cdf-4a06-9eb1-e9c9ceae9733)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page using MAWB
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment @ForceSuccessOrder
  Scenario: Hub Inbound Closed MAWB Not In Destination Hub (uid:e80f57b1-3646-40a2-ad5c-25fadcf0e7af)
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

  @DeleteShipment
  Scenario: Hub Inbound Pending Shipment In Other Country (uid:9e17df8b-32ee-4ef9-8e3d-086c99c5330f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator change the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-temp} on Shipment Inbound Scanning page with different country hub alert
    When Operator change the country to "Singapore"

  @DeleteShipment @ForceSuccessOrder
  Scenario: Hub Inbound Closed Shipment In Other Country (uid:82e16097-1c55-4c6c-b6c9-443f6da987d0)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-temp} on Shipment Inbound Scanning page with different country hub alert
    When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Hub Inbound Transit Shipment In Other Country (uid:55af1d76-d503-42f0-9f8d-1ee26c6a90b1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Shipment Management
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    When Operator change the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-temp} on Shipment Inbound Scanning page with different country hub alert
    When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Hub Inbound Completed Shipment In Other Country (uid:0d696345-fb79-43bd-9ea7-db003977e066)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-temp} on Shipment Inbound Scanning page with different country hub alert
    When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Hub Inbound Cancelled Shipment In Other Country (uid:850c0816-c8de-4e1d-888f-690fcc87e1e1)
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
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-temp} on Shipment Inbound Scanning page with different country hub alert
    When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Hub Inbound Transit MAWB Not In Destination Hub (uid:d2456b1b-4cfd-4c68-9490-52743be767c1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | origHubName | {hub-name}                                                           |
      | destHubName | {hub-name-2}                                                         |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page using MAWB
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page using MAWB
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = At Transit Hub on Shipment Management page
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Hub Inbound MAWB with Mix Status In Destination Hub (uid:e071bed5-1dd6-4cdd-b6e8-21b5dcf17966)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator assign mawb "AUTO-{gradle-current-date-yyyyMMddHHmmsss}" to following shipmentIds
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]} |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator open add to shipment for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" in hub "{hub-name}" to hub id = "{hub-name-2}" with shipmentType "Air Haul"
    And Operator close the shipment which has been created
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]}" with type "Into Van" in hub "{hub-name}" on Shipment Inbound Scanning page
    When API Operator change the status of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]}" into "Completed"
    When API Operator change the status of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]}" into "Cancelled"
    And Operator refresh page
    When Operator inbound scanning Shipment "Into Hub" in hub "{hub-name-2}" on Shipment Inbound Scanning page using MAWB check session using MAWB
    Then Operator verify error message in shipment inbound scanning is "Completed" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]}"
    And Operator verify error message in shipment inbound scanning is "Cancelled" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]}"
    Then Operator verify result in shipment inbound scanning session log is "Completed" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]}"
    And Operator verify result in shipment inbound scanning session log is "Cancelled" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]}"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]} |
    Then Operator verify the following parameters of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management page:
      | status | Pending |
    Then Operator verify the following parameters of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" on Shipment Management page:
      | status | Closed |
    Then Operator verify the following parameters of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]}" on Shipment Management page:
      | status | Transit |
    Then Operator verify the following parameters of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]}" on Shipment Management page:
      | status | Completed |
    Then Operator verify the following parameters of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]}" on Shipment Management page:
      | status | Cancelled |
    Then Operator verifies event is present for shipment on Shipment Detail page
      | source | SHIPMENT_HUB_INBOUND   |
      | result | Completed              |
      | hub    | {hub-name-2}           |
      | userId | automation@ninjavan.co |

  @DeleteShipment
  Scenario: Hub Inbound MAWB with Mix Status Not In Destination Hub (uid:e6e4ab94-f532-461a-8ed5-12b51ed24cd2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create multiple 5 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator assign mawb "AUTO-{gradle-current-date-yyyyMMddHHmmsss}" to following shipmentIds
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]} |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator open add to shipment for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" in hub "{hub-name}" to hub id = "{hub-name-2}" with shipmentType "Air Haul"
    And Operator close the shipment which has been created
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]}" with type "Into Van" in hub "{hub-name}" on Shipment Inbound Scanning page
    When API Operator change the status of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]}" into "Completed"
    When API Operator change the status of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]}" into "Cancelled"
    And Operator refresh page
    When Operator inbound scanning Shipment "Into Hub" in hub "{hub-name}" on Shipment Inbound Scanning page using MAWB check session using MAWB
    Then Operator verify error message in shipment inbound scanning is "Completed" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]}"
    And Operator verify error message in shipment inbound scanning is "Cancelled" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]}"
    Then Operator verify result in shipment inbound scanning session log is "Completed" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]}"
    And Operator verify result in shipment inbound scanning session log is "Cancelled" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]}"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]} |
    Then Operator verify the following parameters of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" on Shipment Management page:
      | status | Pending |
    Then Operator verify the following parameters of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[2]}" on Shipment Management page:
      | status | Closed |
    Then Operator verify the following parameters of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[3]}" on Shipment Management page:
      | status | Transit |
    Then Operator verify the following parameters of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[4]}" on Shipment Management page:
      | status | Completed |
    Then Operator verify the following parameters of shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[5]}" on Shipment Management page:
      | status | Cancelled |
    Then Operator verifies event is present for shipment on Shipment Detail page
      | source | SHIPMENT_HUB_INBOUND   |
      | result | At Transit Hub         |
      | hub    | {hub-name}             |
      | userId | automation@ninjavan.co |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op