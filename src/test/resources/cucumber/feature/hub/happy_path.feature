@OperatorV2 @MiddleMile @Hub @HappyPath @CFW
Feature: Happy Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Create Shipment with Create Another Shipment (uid:3e44bd1b-5bbf-4eb3-b51c-300c21005f86)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given Operator intends to create a new Shipment directly from the Shipment Toast
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created multiple shipment on Shipment Management page

  @DeleteShipment
  Scenario: Create Shipment without Create Another Shipment (uid:20aadc4d-b1f8-4adf-9c45-6eb0b636c5bb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Edit Shipment - Start Hub (uid:e171e86e-2295-4016-b257-a7645768bfc1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page based on "Start Hub" using data below:
      | origHubName | {hub-name-2}                                                         |
      | destHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | EDA         | {gradle-next-1-day-yyyy-MM-dd}                                       |
      | ETA         | 01:00:01                                                             |
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Edit Shipment - End Hub (uid:0714fd17-4ddc-4a0e-ada6-b1ff199ce12a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page based on "End Hub" using data below:
      | origHubName | {hub-name-2}                                                         |
      | destHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | EDA         | {gradle-next-1-day-yyyy-MM-dd}                                       |
      | ETA         | 01:00:01                                                             |
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Edit Shipment with Edit MAWB (uid:82c9ee5a-4f7e-41f8-b4f5-88ccb5193c5a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page based on "with Edit MAWB" using data below:
      | origHubName | {hub-name-2}                                                        |
      | destHubName | {hub-name}                                                          |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | MAWB-{KEY_CREATED_SHIPMENT_ID}                                      |
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Upload Bulk Orders to Shipment with Valid Tracking ID Data (uid:bbe26bb4-8a11-49e0-9c01-f39008b27399)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator create CSV "{csv-upload-file-name}" file which has multiple valid Tracking ID in it and upload the CSV
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment

  @DeleteShipment
  Scenario: Upload Bulk Orders to Shipment with Duplicate Tracking ID Data (uid:844fed49-f618-4443-a85e-66dff1fec3c8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator create CSV "{csv-upload-file-name}" file which has duplicated Tracking ID in it and upload the CSV
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment

  @DeleteShipment
  Scenario: Upload Bulk Orders to Shipment with Invalid Tracking ID Data (uid:0d5917c8-528e-47da-9210-3317d4b549a8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator create CSV "{csv-upload-file-name}" file which has invalid Tracking ID in it and upload the CSV
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Bulk Update Shipment - Update MAWB (uid:b96ac0f0-05e8-42a3-91de-c4df2a16b616)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator selects all shipments and click bulk update button under the apply action
    When Operator bulk update shipment with data below:
      | mawb | mawb-{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}-{KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify the following parameters of all created shipments on Shipment Management page:
      | mawb | mawb-{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}-{KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |

  @DeleteShipment
  Scenario: Bulk Update Shipment - Update Multiple Fields (uid:d8fae297-b77a-4c4f-b104-e0a8dea17a12)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator selects all shipments and click bulk update button under the apply action
    When Operator bulk update shipment with data below:
      | startHub | {hub-name-2}                                                         |
      | endHub   | {hub-name}                                                           |
      | comments | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify the following parameters of all created shipments on Shipment Management page:
      | startHub | {hub-name-2}                                                         |
      | endHub   | {hub-name}                                                           |
      | comments | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |

  @DeleteShipment
  Scenario: Cancel Shipment with Pending Status (uid:4281e860-d180-4f26-9435-7e2588fd82c2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When API Operator change the status of the shipment into "Pending"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Pending |
    And Operator cancel the created shipment on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |

  @DeleteShipment
  Scenario: Cancel Shipment with Completed Status (uid:141dbb2c-9a73-46a2-9c0d-8fbfb7bc5e59)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When API Operator change the status of the shipment into "Completed"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Completed |
    Then Operator verify "Cancel" action button is disabled on shipment Management page

  @DeleteShipment
  Scenario: Re-open Single Shipment (uid:7b08a458-bde7-4ee2-946c-c4fb7323c6db)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When API Operator closes the created shipment
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of the created shipment on Shipment Management page
    When Operator clicks on reopen shipment button under the Apply Action
    Then Operator verifies that the shipment is reopened
    And Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Pending |

  @DeleteShipment
  Scenario: Re-open Multiple Shipments (uid:186571a8-ec55-461e-ba77-4ed9e2892658)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given Operator intends to create a new Shipment directly from the Shipment Toast
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When API Operator closes the created shipment for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    When Operator clicks on reopen shipment button under the Apply Action for multiple shipments
    Then Operator verifies that the shipment is reopened
    And Operator verify the following parameters of all created shipments status is pending

  @DeleteShipment
  Scenario: Force Success Shipment by Action Button (uid:01f3b1fc-b9ce-46c7-92d5-044d5e71a5bf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    When Operator force success the created shipment on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Completed |

  @DeleteShipment
  Scenario: Search Shipment by Filter - MAWB (uid:e0db5d50-ebcc-4e0e-9179-550e49c45e54)
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
    When Operator filter shipment based on MAWB value on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

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

  @DeleteShipment
  Scenario: Search Shipment by ID - Search <= 30 Shipments without Duplicate (uid:fbdf60e9-a047-4e54-b78b-da1c23f55efd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 10 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page
    Then Operator verifies the searched shipment ids result is right

  @DeleteShipment
  Scenario: Search Shipment by ID - Search > 30 Shipments without Duplicate (uid:d7913466-1c85-466d-baf5-1fe260bb1653)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 35 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page
    Then Operator verifies that more than 30 warning toast shown

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

    # TODO: IMPLEMENT ME
  @DeleteShipment @ForceSuccessOrder @RT
  Scenario: Add Parcel to Shipment (uid:ec01c5c8-9088-4da5-ae29-436e75637568)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB}
    And Operator verifies that the row of the added order is blue highlighted
    And Operator refresh page
    # Verify shipment status in shipment management page
    # Verify tracking ID in shipment detail
    # Verify order status in edit order page


  @DeleteShipment @ForceSuccessOrder
  Scenario: Add Multiple Parcels to Shipment (uid:44bfcc1b-35e8-460b-ac98-f43af0cff49c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan multiple created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB}

  @DeleteShipment @ForceSuccessOrder
  Scenario: Add Parcel with Tag to Shipment (uid:0a2f74ee-4810-493d-bd72-fc951a709943)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-legacy-id}-{shipper-v4-name} |
      | status          | Pending                                  |
      | granular status | Pending Pickup                           |
    And Operator searches and selects orders created first row on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    And DB Operator verify order_events record for the created order:
      | type | 48 |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB}

    # TODO: IMPLEMENT ME
  Scenario: Add On Hold with Missing Type to Shipment (uid:81fd47a8-9dd1-4851-861e-4ce58a141ff4)
    Given no-op

  @DeleteShipment @ForceSuccessOrder
  Scenario: Remove Parcel In Shipment from Action Toggle (uid:10201e78-b282-4eee-a1fb-f32e6c31f9e5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id-2} to hub id = {KEY_DESTINATION_HUB}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan multiple created order to shipment in hub {hub-name-2} to hub id = {KEY_DESTINATION_HUB}
    And Operator removes all the parcel from the shipment
    Then Operator verifies that the parcel shown is zero

    # TODO: IMPLEMENT ME
  Scenario: Remove Parcel In Shipment from Remove Field (uid:bcea2152-bbb9-4963-b418-8949ea22f2a4)
    Given no-op

    # TODO: IMPLEMENT ME
  Scenario: Close Shipment (uid:c543c8e9-cd7d-434f-9670-49f2e2462c57)
    Given no-op

  Scenario: Load All Drivers (uid:fa3e21f0-971c-4462-bbd9-f41afab8b7ce)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Driver gets all the driver
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given API Driver get all middle mile driver
    When Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator verifies that the data shown has the same value

  @DeleteDriver @DeleteHubsViaAPI
  Scenario: Load Driver by Filter - Hub (uid:4ac4ea89-688a-4d62-9192-6f59dc8d292c)
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{KEY_CREATED_HUB.id},"hub":"{KEY_CREATED_HUB.name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details string id "{KEY_CREATED_HUB.id}"
    Given API Driver get all middle mile driver using hub filter with value "{KEY_CREATED_HUB.id}"
    When Operator selects the hub on the Middle Mile Drivers Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator verifies that the data shown has the same value

  @DeleteDriver
  Scenario: Search Driver on Search Field ID (uid:6a4af29f-1e7c-41ed-a1f6-8257ef10a5fd)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "id" and verifies the created username

  @DeleteDriver
  Scenario: Search Driver on Search Field Username (uid:04aa3299-829d-417c-8496-848a8720d89a)
    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "username" and verifies the created username

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
