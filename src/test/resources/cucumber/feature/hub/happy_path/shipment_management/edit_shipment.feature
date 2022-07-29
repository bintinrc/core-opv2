@OperatorV2 @HappyPath @Hub @InterHub @ShipmentManagement @EditShipment
Feature: Shipment Management - Edit Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Edit Shipment - Start Hub (uid:e171e86e-2295-4016-b257-a7645768bfc1)
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page:
      | shipmentId  | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name-3}              |
    Then Operator verifies that notification displayed:
      | top | Shipment {KEY_CREATED_SHIPMENT_ID} updated |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name-3}              |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @DeleteShipment
  Scenario: Edit Shipment - End Hub (uid:0714fd17-4ddc-4a0e-ada6-b1ff199ce12a)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page:
      | shipmentId  | {KEY_CREATED_SHIPMENT_ID} |
      | destHubName | {hub-name-3}              |
    Then Operator verifies that notification displayed:
      | top | Shipment {KEY_CREATED_SHIPMENT_ID} updated |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Pending                   |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-3}              |

  @DeleteShipment
  # TODO To be updated
#  Scenario: Edit Shipment with Edit MAWB (uid:82c9ee5a-4f7e-41f8-b4f5-88ccb5193c5a)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Shipment Management
#    When Operator create Shipment on Shipment Management page:
#      | origHubName | {hub-name}                                                          |
#      | destHubName | {hub-name-2}                                                        |
#      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_CREATED_SHIPMENT_ID} |
#    When Operator edit Shipment on Shipment Management page based on "with Edit MAWB" using data below:
#      | origHubName | {hub-name-2}                                                        |
#      | destHubName | {hub-name}                                                          |
#      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
#      | mawb        | MAWB-{KEY_CREATED_SHIPMENT_ID}                                      |
#    And Operator refresh page
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_CREATED_SHIPMENT_ID} |
#    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Upload Bulk Orders to Shipment with Valid Tracking ID Data (uid:bbe26bb4-8a11-49e0-9c01-f39008b27399)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
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

  @DeleteShipment
  Scenario: Upload Bulk Orders to Shipment with Duplicate Tracking ID Data (uid:844fed49-f618-4443-a85e-66dff1fec3c8)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
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
  Scenario: Upload Bulk Orders to Shipment with Invalid Tracking ID Data (uid:0d5917c8-528e-47da-9210-3317d4b549a8)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
    When Operator create CSV "{csv-upload-file-name}" file which has invalid Tracking ID in it and upload the CSV

  @DeleteShipment
#  TODO To be updated
#  Scenario: Bulk Update Shipment - Update MAWB (uid:b96ac0f0-05e8-42a3-91de-c4df2a16b616)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Shipment Management
#    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
#    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
#      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
#    And Operator selects all shipments and click bulk update button under the apply action
#    When Operator bulk update shipment with data below:
#      | mawb | mawb-{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}-{KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
#    And Operator click Edit filter on Shipment Management page
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
#      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
#    Then Operator verify the following parameters of all created shipments on Shipment Management page:
#      | mawb | mawb-{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}-{KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |

  @DeleteShipment
  Scenario: Bulk Update Shipment - Update Multiple Fields (uid:d8fae297-b77a-4c4f-b104-e0a8dea17a12)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
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
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Pending"
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Pending                   |
    And Operator cancel the created shipment on Shipment Management page
    And Operator click Edit filter on Shipment Management page
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Cancelled |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |

  @DeleteShipment
  Scenario: Cancel Shipment with Completed Status (uid:141dbb2c-9a73-46a2-9c0d-8fbfb7bc5e59)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Completed |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Completed                 |
    Then Operator verify "Cancel" action button is disabled on shipment Management page

  @DeleteShipment
  Scenario: Re-open Single Shipment (uid:7b08a458-bde7-4ee2-946c-c4fb7323c6db)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator closes the created shipment
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator clicks on reopen shipment button under the Apply Action
    Then Operator verifies that notification displayed:
      | top | Success reopen shipments |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Pending                   |

  @DeleteShipment
  Scenario: Re-open Multiple Shipments (uid:186571a8-ec55-461e-ba77-4ed9e2892658)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator closes the created shipment for the following shipments:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    When Operator clicks on reopen shipment button under the Apply Action for multiple shipments
    Then Operator verifies that notification displayed:
      | top | Success reopen shipments |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Pending                   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op