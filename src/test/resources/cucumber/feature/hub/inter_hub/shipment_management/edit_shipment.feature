@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @EditShipment
Feature: Shipment Management - Edit Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments
  Scenario: Bulk Update Shipment - Update Comments (uid:1410c729-d7db-438b-a6b6-a86ceb72fcc2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
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

  @DeleteShipments
  Scenario: Bulk Update Shipment - Remove Selected Shipment (uid:05a2ed45-d659-45f3-b5d5-9878335e7a18)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
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
    Then Operator verify the following parameters of shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[1]}" on Shipment Management page:
      | startHub | {hub-name} |
    And Operator verify the following parameters of shipment with id "{KEY_LIST_OF_CREATED_SHIPMENT_ID[2]}" on Shipment Management page:
      | startHub | {hub-name-3} |

  @DeleteShipments
  Scenario: Bulk Update Shipment - Abort Update (uid:83793581-a5af-45c1-aef5-bfc0e5edb0c5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
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
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[1]} |
      | {KEY_LIST_OF_CREATED_SHIPMENT_ID[2]} |
    And Operator selects all shipments and click bulk update button under the apply action
    When Operator bulk update shipment with data below:
      | shipmentType    | Others |
      | modifySelection | true   |
    Then Operator verify it highlight selected shipment and it can select another shipment

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op