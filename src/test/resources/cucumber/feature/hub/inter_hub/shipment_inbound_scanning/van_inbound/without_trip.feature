@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @VanInbound @WithoutTrip
Feature: Shipment Van Inbound Without Trip Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Van Inbound Transit Shipment Not In Origin Hub (uid:b04b3727-aa95-488d-a65c-ee80513fa5df)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    And Operator refresh page
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} on Shipment Inbound Scanning page
    Then Operator verify error message in shipment inbound scanning is "Transit" for shipment "{KEY_CREATED_SHIPMENT_ID}"
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
      | source | SHIPMENT_VAN_INBOUND(OpV2)   |
      | result | Transit                      |
      | userId | qa@ninjavan.co               |

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
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
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
    When Operator filter Shipment Status = Completed on Shipment Management page
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
    When Operator filter Shipment Status = Cancelled on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |
    When Operator change the country to "Indonesia"
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} on Shipment Inbound Scanning page with different country van alert
    When Operator change the country to "Singapore"

  @DeleteShipment
  Scenario: Van Inbound MAWB with Mix Status In Origin Hub (uid:3803c0f8-e188-44b5-9ab3-a8971f8586c6)
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
    When Operator inbound scanning Shipment "Into Van" in hub "{hub-name}" on Shipment Inbound Scanning page using MAWB check session using MAWB
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
      | source | SHIPMENT_VAN_INBOUND   |
      | result | Transit                |
      | hub    | {hub-name}             |
      | userId | automation@ninjavan.co |

  @DeleteShipment
  Scenario: Van Inbound MAWB with Mix Status Not In Origin Hub (uid:ed30531a-fc2a-4fe0-9a1a-fa0cc96969bb)
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
    When Operator inbound scanning Shipment "Into Van" in hub "{hub-name-2}" on Shipment Inbound Scanning page using MAWB check session using MAWB
    Then Operator verify error message in shipment inbound scanning is "Pending" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
    Then Operator verify result in shipment inbound scanning session log is "Pending" for shipment "{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}"
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
      | source | SHIPMENT_VAN_INBOUND   |
      | result | Transit                |
      | hub    | {hub-name-2}           |
      | userId | automation@ninjavan.co |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op