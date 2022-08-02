@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @EditShipment
Feature: Shipment Management - Edit Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments
  Scenario: Bulk Update Shipment - Update Comments (uid:1410c729-d7db-438b-a6b6-a86ceb72fcc2)
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator selects all shipments and click bulk update button under the apply action
    When Operator bulk update shipment with data below:
      | comments | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify the following parameters of all created shipments on Shipment Management page:
      | comments | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |

  @DeleteShipments
  Scenario: Bulk Update Shipment - Update Multiple Fields (uid:325947b5-3c94-441e-b5d1-28dd76627eb0)
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

  @DeleteShipments
  Scenario: Bulk Update Shipment - Remove Selected Shipment (uid:05a2ed45-d659-45f3-b5d5-9878335e7a18)
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
      | startHub       | {hub-name-3} |
      | removeShipment | second       |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | origHubName | {hub-name-3}                         |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
      | origHubName | {hub-name}                           |

  @DeleteShipments
  Scenario: Bulk Update Shipment - Abort Update (uid:83793581-a5af-45c1-aef5-bfc0e5edb0c5)
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
      | shipmentType | Others |
      | abort        | true   |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify the following parameters of all created shipments on Shipment Management page:
      | shipmentType | AIR_HAUL |

  @DeleteShipments
  Scenario: Bulk Update Shipment - Modify Selection (uid:c5697e80-4b45-4866-a71c-240056492089)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator click "Load All Selection" on Shipment Management page
    And Operator selects shipments and click bulk update button:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    When Operator bulk update shipment with data below:
      | shipmentType    | Others |
      | modifySelection | true   |
    Then Operator verify it highlight selected shipment and it can select another shipment

  @DeleteShipment
  Scenario: Cancel Shipment with Closed Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Then API Operator closes the created shipment
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Closed                    |
    And Operator cancel the created shipment on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |


  @DeleteShipment
  Scenario: Cancel Shipment with Transit Status
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Then API Operator closes the created shipment
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Transit                   |
    And Operator cancel the created shipment on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |


  @DeleteShipment
  Scenario: Auto Cancel Pending Shipment with 0 parcel and creation time < current time
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Then DB Operator update shipment created date:
      | shipmentId  | {KEY_CREATED_SHIPMENT_ID}         |
      | dateOffset  | -3                                |
    Then API Operator cancel old shipment from "3_days_before"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Cancelled                 |


  @DeleteShipment
  Scenario: Auto Cancel Pending Shipment with 0 parcel and creation time > current time
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Then API Operator cancel old shipment from "3_days_before"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Pending                   |


  @DeleteShipment @ForceSuccessOrder
  Scenario: Auto Cancel Pending Shipment with > 0 parcel
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator go to menu Inter-Hub -> Add To Shipment
    And Operator scan order to shipment on Add to Shipment page:
      | barcode        | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | originHub      | {hub-name}                         |
      | destinationHub | {hub-name-2}                       |
      | shipmentType   | Air Haul                           |
      | shipmentId     | {KEY_CREATED_SHIPMENT_ID}          |
    Then DB Operator update shipment created date:
      | shipmentId  | {KEY_CREATED_SHIPMENT_ID}         |
      | dateOffset  | -3                                |
    Then API Operator cancel old shipment from "3_days_before"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Pending                   |

  @DeleteShipment
  Scenario: Auto Cancel Close Shipment with 0 parcel
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Then API Operator closes the created shipment
    Then DB Operator update shipment created date:
      | shipmentId  | {KEY_CREATED_SHIPMENT_ID}         |
      | dateOffset  | -3                                |
    Then API Operator cancel old shipment from "3_days_before"
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Closed                    |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op