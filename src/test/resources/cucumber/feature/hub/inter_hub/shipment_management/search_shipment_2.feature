@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @SearchShipment2
Feature: Shipment Management - Search Shipment 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Search Shipment by Filter - MAWB (uid:59cc8df2-47e0-46c4-9ca6-08179b099a02)
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator assign mawb "mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" to following shipmentIds
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    When Operator apply filters on Shipment Management Page:
      | mawb | MAWB_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                                   |
      | id           | {KEY_CREATED_SHIPMENT_ID}                  |
      | status       | Pending                                    |
      | userId       | {operator-portal-uid}                      |
      | origHubName  | {hub-name}                                 |
      | currHubName  | {hub-name}                                 |
      | destHubName  | {hub-name-2}                               |
      | mawb         | MAWB_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Shipment Completion (uid:9667bb60-0933-49e3-8879-2bdac54aae68)
    Given Operator go to menu Utilities -> QRCode Printing
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator put created parcel to shipment
    And API Operator performs hub inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id-2}                |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus         | Completed                                                                       |
      | shipmentCompletionDate | {gradle-previous-1-day-yyyy-MM-dd}:00:00,{gradle-current-date-yyyy-MM-dd}:23:30 |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Completed                 |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name-2}              |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Transit Date Time (uid:d78f101e-c251-46ec-9b14-0eef64804627)
    Given Operator go to menu Utilities -> QRCode Printing
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator put created parcel to shipment
    And API Operator closes the created shipment
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id-2}                |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus  | Transit                                                                         |
      | transitDateTime | {gradle-previous-1-day-yyyy-MM-dd}:00:00,{gradle-current-date-yyyy-MM-dd}:23:30 |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | At Transit Hub,Transit    |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name-2}              |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Search Shipment by Filter - Last Inbound Hub (uid:7a2bf3c3-622d-4f31-9851-02ef7797ef1b)
    Given Operator go to menu Utilities -> QRCode Printing
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator put created parcel to shipment
    And API Operator closes the shipment using created shipper id
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id-2}                |
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | lastInboundHub | {hub-name-2} |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Closed                    |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name-2}              |
      | destHubName  | {hub-name-2}              |

  Scenario: Search Shipment by ID - Search <= 30 Shipments without Duplicate (uid:68b7217b-41a8-4259-9da8-e8ce68f0a7b0)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 2 shipment IDs
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |

  Scenario: Search Shipment by ID - Search <= 30 Shipments with Duplicate (uid:6ec523ea-2f26-4d09-b90b-cb686c7c3b0c)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 2 shipment IDs
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify search results contains exactly shipments on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |

  Scenario: Search Shipment by ID - Search > 30 Shipments without Duplicate (uid:a4c69f51-6389-46b4-8348-db2b4fb4dfe5)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 35 shipment IDs
    When Operator enters multiple shipment ids in the Shipment Management Page
    Then Operator verifies number of entered shipment ids on Shipment Management page:
      | entered | 35 |
    When Operator click Search by shipment id on Shipment Management page
    Then Operator verifies that error react notification displayed:
      | top | We cannot process more than 30 shipments |

  Scenario: Search Shipment by ID - Search > 30 Shipments with Duplicate (uid:b57b2ffb-b215-4188-b66e-9ae51dc67278)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 35 shipment IDs
    When Operator enters multiple shipment ids in the Shipment Management Page
    When Operator enters next shipment ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verifies number of entered shipment ids on Shipment Management page:
      | entered   | 35 |
      | duplicate | 2  |
    When Operator click Search by shipment id on Shipment Management page
    Then Operator verifies that error react notification displayed:
      | top | We cannot process more than 30 shipments |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op