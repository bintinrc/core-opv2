@ShipmentManagement @InterHub @Shipment @MiddleMile @SearchShipment
Feature: Shipment Management - Search Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  @DeleteShipment
#  Scenario: Search Shipment by Filter - MAWB (uid:59cc8df2-47e0-46c4-9ca6-08179b099a02)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Shipment Management
#    When Operator create Shipment on Shipment Management page using data below:
#      | origHubName | {hub-name}                                                          |
#      | destHubName | {hub-name-2}                                                        |
#      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
#    When Operator click "Load All Selection" on Shipment Management page
#    When Operator edit Shipment on Shipment Management page including MAWB using data below:
#      | destHubName | {hub-name-2}                                                         |
#      | origHubName | {hub-name}                                                           |
#      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
#      | mawb        | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                           |
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Shipment Management
#    When Operator filter shipment based on MAWB value on Shipment Management page
#    And Operator click "Load All Selection" on Shipment Management page
#    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Completion (uid:9667bb60-0933-49e3-8879-2bdac54aae68)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
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
    When Operator filter shipment based on "Shipment Completion Date Time" Date on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment via API on Shipment Management page

  @DeleteShipment
  Scenario: Search Shipment by Filter - Transit Date Time (uid:d78f101e-c251-46ec-9b14-0eef64804627)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan the created order to shipment in hub {hub-name}
    And Operator close the shipment which has been created
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter shipment based on "Transit Date Time" Date on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Search Shipment by Filter - Last Inbound Hub (uid:7a2bf3c3-622d-4f31-9851-02ef7797ef1b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan the created order to shipment in hub {hub-name}
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
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

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

  Scenario: Search Shipment by ID - Search <= 30 Shipments with Invalid Shipment (uid:bc7c0cdf-fbcb-4db2-8c0d-a16b39e617a5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 10 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page with "invalid"
    Then Operator verifies that there is a search error modal shown with "valid shipment"
    And Operator verifies the searched shipment ids result is right

  Scenario: Search Shipment by ID - Search <= 30 Shipments with Empty Line (uid:a2945cf0-7404-427f-80f9-7feb06288d75)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 10 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page with "empty line"
    Then Operator verifies that there is a search error modal shown with "valid shipment"
    And Operator verifies the searched shipment ids result is right

  @DeleteFilersPreset
  Scenario: Preset Setting - Save Current Shipment Filter as Preset (uid:81c46be2-466f-4c5f-b7ba-d1f15d05ddc9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Pending on Shipment Management page
    And Operator filter Start Hub = {hub-name} on Shipment Management page
    And Operator filter End Hub = {hub-name-2} on Shipment Management page
    And Operator filter Shipment Type = Air Haul on Shipment Management page
    And Operator save current filters as preset on Shipment Management page
    And Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Inter-Hub -> Shipment Management
    Then Operator select created filters preset on Shipment Management page
    And Operator verify parameters of selected filters preset on Shipment Management page

  @DeleteFilersPreset
  Scenario: Preset Setting - Delete Shipment Filter as Preset (uid:c722664d-4ef4-4f13-92d6-5074a3dde4f5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Pending on Shipment Management page
    And Operator save current filters as preset on Shipment Management page
    And Operator delete created filters preset on Shipment Management page
    And Operator refresh page
    Then Operator verify filters preset was deleted

  @DeleteShipment
  Scenario Outline: Search Shipment by Filter - <scenarioName> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator filter <filterName> = <filterValue> on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | Note                                        | scenarioName    | hiptest-uid                              | filterName      | filterValue  |
      | Search Shipment by Filter - Start Hub       | Start Hub       | uid:6fe69d4d-a6fe-4640-ac42-6a84c2617d17 | Start Hub       | {hub-name}   |
      | Search Shipment by Filter - End Hub         | End Hub         | uid:b8bf98ae-d33f-4686-a0f5-0bf4ce8eed47 | End Hub         | {hub-name-2} |
      | Search Shipment by Filter - Shipment Type   | Shipment Type   | uid:2c1f7ae7-0e00-43ea-8fcf-be5e699a4ffe | Shipment Type   | Air Haul     |
      | Search Shipment by Filter - Shipment Status | Shipment Status | uid:6cebf48f-e62c-4366-80ee-ec36fbbc6a82 | Shipment Status | Pending      |

  @DeleteShipment
  Scenario Outline: Search Shipment by Filter - <scenarioName> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator filter shipment based on "<filterName>" Date on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | Note                                        | scenarioName    | hiptest-uid                              | filterName      |
      | Search Shipment by Filter - ETA (Date Time) | ETA (Date Time) | uid:5a65a7ea-12ef-4a59-a8b0-a15f261b52d2 | ETA (Date Time) |
      | Search Shipment by Filter - Shipment Date   | Shipment Date   | uid:e10f1ad8-cdc0-4795-b816-2ae3015a36d3 | Shipment Date   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op