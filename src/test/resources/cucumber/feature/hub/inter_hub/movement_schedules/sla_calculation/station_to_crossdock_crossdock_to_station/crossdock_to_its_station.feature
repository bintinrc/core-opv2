@MiddleMile @Hub @InterHub @MovementSchedules @SlaCalculation @StationToCrossdock @CrossdockToItsStation
Feature: Crossdock to it's Station

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipment @DeleteCreatedMovementSchedules @CloseNewWindows
  Scenario: Crossdock to its Station - Station Movement Found and there is available schedule (uid:4be9aa9e-813f-4c02-8d92-5af401b4a6f4)
    Given Operator go to menu Utilities -> QRCode Printing
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{sc-cd-hub-id-1}" to "{sc-st-hub-id-1}"
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator try adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {sc-cd-hub-name-1} |
      | originHub      | {sc-cd-hub-name-1} |
      | destinationHub | {sc-st-hub-name-1} |
      | movementType   | Land Haul                          |
      | departureTime  | {date: 5 minutes next, HH:mm} |
      | duration       | 1                                  |
      | endTime        | {date: 10 minutes next, HH:mm} |
      | daysOfWeek     | all                                |
    And API MM - Operator gets Movement Schedule from hub id "{sc-cd-hub-id-1}" to "{sc-st-hub-id-1}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {sc-cd-hub-name-1} |
      | originHub    | {sc-cd-hub-name-1} |
      | destinationHub    | {sc-st-hub-name-1} |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scan shipment id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" "Into Van" in hub "{sc-cd-hub-name-1}" on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}          |
      | origHubName | {sc-cd-hub-name-1} |
      | destHubName | {sc-st-hub-name-1} |
      | status      | Transit                            |
    And Operator open the shipment detail for shipment id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Status: Transit                            |
      | hub    | {sc-cd-hub-name-1} |
    Then Operator verify movement event on Shipment Details page:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @DeleteCreatedShipment @DeleteCreatedMovementSchedules @CloseNewWindows
  Scenario: Crossdock to its Station - Station Movement Found but there is no available schedule (uid:459a5ba5-3ffd-4fe4-ae77-250e77e4c1b0)
    Given Operator go to menu Utilities -> QRCode Printing
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{sc-cd-hub-id-1}" to "{sc-st-hub-id-1}"
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded

    And Operator try adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {sc-cd-hub-name-1} |
      | originHub      | {sc-cd-hub-name-1} |
      | destinationHub | {sc-st-hub-name-1} |
      | movementType   | Land Haul                          |
      | departureTime  | {date: 5 minutes next, HH:mm} |
      | duration       | 1                                  |
      | endTime        | {date: 10 minutes next, HH:mm} |
      | daysOfWeek     | all                                |
    And API MM - Operator gets Movement Schedule from hub id "{sc-cd-hub-id-1}" to "{sc-st-hub-id-1}"
    Then API MM - Operator deletes all Movement Schedules from Hub Relation "KEY_MM_LIST_OF_CREATED_HUB_RELATIONS[1]"
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {sc-cd-hub-name-1} |
      | originHub    | {sc-cd-hub-name-1} |
      | destinationHub    | {sc-st-hub-name-1} |

    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scan shipment id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" "Into Van" in hub "{sc-cd-hub-name-1}" on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}           |
      | origHubName | {sc-cd-hub-name-1} |
      | destHubName | {sc-st-hub-name-1}                  |
      | status      | Transit                             |
    And Operator open the shipment detail for shipment id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(OpV2)          |
      | result | Status: Transit                             |
      | hub    | {sc-cd-hub-name-1} |
    Then Operator verify movement event on Shipment Details page:
      | source   | SLA_CALCULATION                                                                                                                            |
      | status   | FAILED                                                                                                                                     |

  @DeleteCreatedShipment @CloseNewWindows
  Scenario: Crossdock to its Station - Station Movement not found (uid:9aa9d622-d1e1-41d0-9ab0-c7b960051f91)
    Given Operator go to menu Utilities -> QRCode Printing
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{sc-cd-hub-id-1}" to "{sc-st-hub-id-0}"
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scan shipment id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" "Into Van" in hub "{sc-cd-hub-name-1}" on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}           |
      | origHubName | {sc-cd-hub-name-1} |
      | destHubName | {sc-st-hub-name-0}                  |
      | status      | Transit                             |
    And Operator open the shipment detail for shipment id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(OpV2)          |
      | result | Status: Transit                             |
      | hub    | {sc-cd-hub-name-1} |
    Then Operator verify movement event on Shipment Details page:
      | source   | SLA_CALCULATION                                                                                                                            |
      | status   | FAILED                                                                                                                                     |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op