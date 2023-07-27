@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @EditShipment2
Feature: Shipment Management - Edit Shipment 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments
  Scenario: Edit Shipment with Invalid Status - Cancelled (uid:bf43e7b9-b9d4-4f75-b8d4-7ffaf3d1992d)
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API MM - Update shipment status with id "{KEY_CREATED_SHIPMENT_ID}" to "Cancelled"
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Cancelled |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |
    When Operator edits and verifies that the cancelled shipment cannot be edited

  @DeleteCreatedShipments
  Scenario: Cancel Shipment with Cancelled Status (uid:c414b401-2260-4388-bbbd-b364fc07727f)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API MM - Update shipment status with id "{KEY_CREATED_SHIPMENT_ID}" to "Cancelled"
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Cancelled |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |
    Then Operator verify "Cancel" action button is disabled on shipment Management page

  @HappyPath @DeleteCreatedShipments
  Scenario: Cancel Shipment with Completed Status (uid:bc7496b5-5719-480f-9205-b8604cebf3c9)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API MM - Update shipment status with id "{KEY_CREATED_SHIPMENT_ID}" to "Completed"
    When Operator apply filters on Shipment Management Page:
      | shipmentStatus | Completed |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Completed                 |
    Then Operator verify "Cancel" action button is disabled on shipment Management page

  @HappyPath @DeleteCreatedShipments
  Scenario: Cancel Shipment with Pending Status (uid:192240e7-3534-48f3-91ee-242e08ac4342)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
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

  @HappyPath @DeleteCreatedShipments
  Scenario: Re-open Single Shipment (uid:52a4379e-fbae-46a7-ba5c-0841aae75286)
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

  @HappyPath @DeleteCreatedShipments
  Scenario: Re-open Multiple Shipments (uid:a7e00285-e076-43c0-8987-38d2e33996f6)
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