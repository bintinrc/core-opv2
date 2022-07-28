@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @EditShipment3
Feature: Shipment Management - Edit Shipment 3

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Re-open Shipment - Invalid Shipment Status - Pending (uid:5ddf5f14-3298-4e4e-a747-aa832bb234bd)
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
    When Operator clicks on reopen shipment button under the Apply Action
    Then Operator verifies that the Reopen Shipment Button is disabled

  @DeleteShipment
  Scenario: Re-open Shipment - Invalid Shipment Status - Transit (uid:f8ccf5c9-85be-420a-b870-54bd4868b793)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator adds parcels to shipment using following data:
      | country    | sg                              |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator closes the created shipment
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id}                  |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
    And Operator verify the following parameters of all created shipments on Shipment Management page:
      | status | At Transit Hub |
    When Operator clicks on reopen shipment button under the Apply Action
    Then Operator verifies that the Reopen Shipment Button is disabled

  @DeleteShipment
  Scenario: Re-open Shipment - Invalid Shipment Status - Completed (uid:dabe7158-2e9d-4a69-a35d-8b66ff5872b0)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Completed                 |
    When Operator clicks on reopen shipment button under the Apply Action
    Then Operator verifies that the Reopen Shipment Button is disabled

  @DeleteShipment @CloseNewWindows
  Scenario: Upload Bulk Orders to Shipment with Valid Tracking ID Data (uid:db962525-cadb-4314-8e90-1a5d7bb3a3a4)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
    When Operator create CSV "{csv-upload-file-name}" file which has multiple valid Tracking ID in it and upload the CSV
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment

  @DeleteShipment @CloseNewWindows
  Scenario: Upload Bulk Orders to Shipment with Duplicate Tracking ID Data (uid:76ff878a-2998-4656-a9de-62af667591d9)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
    When Operator create CSV "{csv-upload-file-name}" file which has duplicated Tracking ID in it and upload the CSV
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment

  @DeleteShipment
  Scenario: Upload Bulk Orders to Shipment with Invalid Tracking ID Data (uid:06c9f41b-780b-40f3-8c34-d422ded305f6)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
    When Operator create CSV "{csv-upload-file-name}" file which has invalid Tracking ID in it and upload the CSV

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op