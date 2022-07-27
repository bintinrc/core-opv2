@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @SearchShipment2
Feature: Shipment Management - Search Shipment 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Search Shipment by Filter - MAWB (uid:59cc8df2-47e0-46c4-9ca6-08179b099a02)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API get all Vendors
    And API get all Airports
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page based on "mawb" using data below:
      | origHubName     | {hub-name-2}                                                        |
      | destHubName     | {hub-name}                                                          |
      | comments        | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb            | {KEY_CREATED_SHIPMENT_ID}                                           |
      | mawbVendor      | KEY_LIST_OF_VENDORS[1]                                              |
      | MawbOrigin      | KEY_LIST_OF_AIRPORTS[1]                                             |
      | MawbDestination | KEY_LIST_OF_AIRPORTS[2]                                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter shipment based on MAWB value on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Completion (uid:9667bb60-0933-49e3-8879-2bdac54aae68)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    Given Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-2}           |
      | trackingId | GET_FROM_CREATED_ORDER |
    Then API Operator verify order info after Global Inbound
    And Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Completed on Shipment Management page
    When Operator filter shipment based on "Shipment Completion Date Time" Date on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment via API on Shipment Management page

  @DeleteShipment
  Scenario: Search Shipment by Filter - Transit Date Time (uid:d78f101e-c251-46ec-9b14-0eef64804627)
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
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = At Transit Hub on Shipment Management page
    When Operator filter Shipment Status = Transit on Shipment Management page
    When Operator filter shipment based on "Transit Date Time" Date on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Search Shipment by Filter - Last Inbound Hub (uid:7a2bf3c3-622d-4f31-9851-02ef7797ef1b)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = At Transit Hub on Shipment Management page
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  Scenario: Search Shipment by ID - Search <= 30 Shipments without Duplicate (uid:68b7217b-41a8-4259-9da8-e8ce68f0a7b0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 10 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page
    Then Operator verifies the searched shipment ids result is right

  Scenario: Search Shipment by ID - Search <= 30 Shipments with Duplicate (uid:6ec523ea-2f26-4d09-b90b-cb686c7c3b0c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 10 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page with "duplicated"
    And Operator verifies the searched shipment ids result is right

  Scenario: Search Shipment by ID - Search > 30 Shipments without Duplicate (uid:a4c69f51-6389-46b4-8348-db2b4fb4dfe5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 35 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page
    Then Operator verifies that more than 30 warning toast shown

  Scenario: Search Shipment by ID - Search > 30 Shipments with Duplicate (uid:b57b2ffb-b215-4188-b66e-9ae51dc67278)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 35 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page with "duplicated"
    Then Operator verifies that more than 30 warning toast shown

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op