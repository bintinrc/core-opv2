@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @EditShipment5
Feature: Shipment Management - Edit Shipment 5

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Edit Shipment with Invalid Status - Completed (uid:afa91c9d-a140-4635-9e05-a858f5113558)
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Completed                 |
    When Operator edit Shipment on Shipment Management page:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID} |
    Then  Operator verifies that error react notification displayed:
      | top    | Request failed with status code 400                            |
      | bottom | ^.*Error Message: unable to edit completed/cancelled shipments |

  @DeleteShipments
  Scenario: Bulk Update Shipment - Update Shipment Type (uid:b7647c11-855d-4d18-bb3c-3b03e6c7cc10)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator selects all shipments and click bulk update button under the apply action
    When Operator bulk update shipment with data below:
      | shipmentType | Others |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify the following parameters of all created shipments on Shipment Management page:
      | shipmentType | OTHERS |

  @DeleteShipments
  Scenario: Bulk Update Shipment - Update Origin Hub (uid:2cc47ea3-6553-4799-9a2d-c415ea57cba9)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator selects all shipments and click bulk update button under the apply action
    When Operator bulk update shipment with data below:
      | startHub | {hub-name-3} |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify the following parameters of all created shipments on Shipment Management page:
      | startHub | {hub-name-3} |

  @DeleteShipments
  Scenario: Bulk Update Shipment - Update Destination Hub (uid:f65d0f34-bb57-411f-903f-6f122af6292a)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator selects all shipments and click bulk update button under the apply action
    When Operator bulk update shipment with data below:
      | endHub | {hub-name-3} |
    And Operator click Edit filter on Shipment Management page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    Then Operator verify the following parameters of all created shipments on Shipment Management page:
      | endHub | {hub-name-3} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op