@OperatorV2 @HappyPath @Hub @InterHub @ShipmentManagement @SearchShipment
Feature: Shipment Management - Search Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Search Shipment by Filter - MAWB (uid:59cc8df2-47e0-46c4-9ca6-08179b099a02)
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator assign mawb "mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" to following shipmentIds
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    When Operator apply filters on Shipment Management Page:
      | mawb | mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                   |
      | id           | {KEY_CREATED_SHIPMENT_ID}                  |
      | status       | Pending                                    |
      | userId       | {operator-portal-uid}                      |
      | origHubName  | {hub-name}                                 |
      | currHubName  | {hub-name}                                 |
      | destHubName  | {hub-name-2}                               |
      | mawb         | mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |

  @DeleteShipment
  Scenario: Search Shipment by Filter - End Hub (uid:21fbac4f-372b-427e-be82-c49c1be439ae)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator filter End Hub = {hub-name-2} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Status (uid:2b6e7569-727c-47b2-a32e-907e848179f7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator filter Shipment Status = Pending on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Search Shipment by Filter - Start Hub (uid:9d91500a-c139-402a-a13a-f9e449041e80)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator filter Start Hub = {hub-name} on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  Scenario: Search Shipment by ID - Search <= 30 Shipments without Duplicate (uid:68b7217b-41a8-4259-9da8-e8ce68f0a7b0)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 2 shipment IDs
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |

  @DeleteShipment
  Scenario: Search Shipment by ID - Search > 30 Shipments without Duplicate (uid:d7913466-1c85-466d-baf5-1fe260bb1653)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 35 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page
    Then Operator verifies that error react notification displayed:
      | top | We cannot process more than 30 shipments |

  @DeleteShipment
  Scenario: Shipment Details (uid:e18b2c67-8dc0-4627-99f0-2845e2f39c0b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op