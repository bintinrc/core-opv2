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
    Then Operator verify small message "Shipment id {KEY_CREATED_SHIPMENT_ID} cannot change status from Transit to Transit" appears in Shipment Inbound Box
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
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} in Shipment Inbound Scanning page
    Then Operator verify small message "Mismatched hub system ID: shipment origin hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} in Shipment Inbound Scanning page
    Then Operator verify small message "Mismatched hub system ID: shipment origin hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} in Shipment Inbound Scanning page
    Then Operator verify small message "Mismatched hub system ID: shipment origin hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} in Shipment Inbound Scanning page
    Then Operator verify small message "Mismatched hub system ID: shipment origin hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    When Operator inbound scanning Shipment Into Van in hub {hub-name-temp} in Shipment Inbound Scanning page
    Then Operator verify small message "Mismatched hub system ID: shipment origin hub system ID sg and scan hub system ID id are not the same." appears in Shipment Inbound Box
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Singapore"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op