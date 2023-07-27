@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @EditShipment7
Feature: Shipment Management - Edit Shipment 7

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Edit Shipment with Edit MAWB
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator clicks Edit action button on Shipment Management page
    And Operator clicks mawb link button on Shipment Management page
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | RANDOM           |
      | vendor      | {vendor-name}    |
      | origin      | {airport-name-1} |
      | destination | {airport-name-2} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipment
  Scenario: Cancel Shipment with Transit Status
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
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
      | hubId      | {hub-id}                  |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Transit                |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator cancel the created shipment on Shipment Management page
    And Operator click Edit filter on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Cancelled |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |

  @DeleteShipment
  Scenario: Cancel Shipment with Closed Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator put created parcel to shipment
    And API Operator closes the created shipment
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator clear all filters on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentType   | {shipment-dialog-type} |
      | shipmentStatus | Closed                 |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator cancel the created shipment on Shipment Management page
    And Operator click Edit filter on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Cancelled |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
