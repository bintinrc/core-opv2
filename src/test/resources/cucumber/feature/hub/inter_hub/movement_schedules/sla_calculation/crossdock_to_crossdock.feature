@MiddleMile @Hub @InterHub @MovementSchedules @SlaCalculation @CrossdockToCrossdock
Feature: Crossdock to Crossdock

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedMovementSchedules @DeleteCreatedShipments @DeleteCreatedHubs @CloseNewWindows
  Scenario: Crossdock to Crossdock - Crossdock Movement found and there is available schedule (uid:28f9335f-e4b8-44de-8c36-4a41245901ef)
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 15 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | all                                                                |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
    When Operator click "ok" button on Add Movement Schedule dialog
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | hubId     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].id}    |
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | origHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                                  |
    And Operator open the shipment detail for shipment id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA)              |
      | result | Status: Transit                         |
      | hub    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @DeleteCreatedMovementSchedules @DeleteCreatedShipments @DeleteCreatedHubs @CloseNewWindows
  Scenario: Crossdock to Crossdock - Crossdock Movement found and the schedule available on tomorrow (uid:1d82199c-b464-44e7-b79c-f3e30e115dc4)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 15 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | {date: 1 days next, EEEE}                                          |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
    When Operator click "ok" button on Add Movement Schedule dialog
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | hubId     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].id}    |
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | origHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                                  |
    And Operator open the shipment detail for shipment id "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA)              |
      | result | Status: Transit                         |
      | hub    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @DeleteCreatedMovementSchedules @DeleteCreatedShipments @DeleteCreatedHubs @CloseNewWindows
  Scenario: Crossdock to Crossdock - Crossdock Movement found but there is no available schedule
    Given Operator go to menu Utilities -> QRCode Printing
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 15 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | {date: 2 days next, EEEE}                                          |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
    When Operator click "ok" button on Add Movement Schedule dialog
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | hubId     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].id}    |
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | origHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                                  |
#      | sla         | {{next-4-days-yyyy-MM-dd}} 07:45:00 |
    When Operator opens Shipment Details page for shipment "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}"
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA)              |
      | result | Status: Transit                         |
      | hub    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @DeleteCreatedMovementSchedules @DeleteCreatedShipments @DeleteCreatedHubs @CloseNewWindows
  Scenario: Crossdock to Crossdock - Crossdock Movement found but has no schedule (uid:56c12e0f-caf3-41aa-a82b-39fbd38c28dd)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | hubId     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].id}    |
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | origHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                                  |
      | sla         | -                                        |
    When Operator opens Shipment Details page for shipment "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}"
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA)              |
      | result | Status: Transit                         |
      | hub    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page:
      | source   | SLA_CALCULATION               |
      | status   | FAILED                        |
      | comments | Path finding failed, path: [] |

  @DeleteCreatedMovementSchedules @DeleteCreatedShipments @DeleteCreatedHubs @CloseNewWindows
  Scenario: Crossdock to Crossdock - Facility Type of Origin/Destination Crossdock Hub is changed to 'Station' (uid:2bc56464-c419-4627-939c-932a3ae5dd72)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 15 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | all                                                                |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
    When Operator click "ok" button on Add Movement Schedule dialog
    When API Sort - Operator updates hub "KEY_SORT_LIST_OF_CREATED_HUBS[1]" with data below:
      | facilityType | STATION |
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | hubId     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].id}    |
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | origHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                                  |
      | sla         | -                                        |
    When Operator opens Shipment Details page for shipment "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}"
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA)              |
      | result | Status: Transit                         |
      | hub    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page:
      | source   | SLA_CALCULATION               |
      | status   | FAILED                        |
      | comments | Path finding failed, path: [] |

  @DeleteCreatedMovementSchedules @DeleteCreatedShipments @DeleteCreatedHubs @CloseNewWindows
  Scenario: Crossdock to Crossdock - Crossdock Movement found and available schedule only 1 day in a week (uid:6be5f247-ad8d-43ed-8db3-a5f4bd58a00e)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    When Operator opens Add Movement Schedule modal on Movement Management page
    When Operator fills in Add Movement Schedule form using data below:
      | index          | 1                                                                  |
      | originHub      | KEY_SORT_LIST_OF_CREATED_HUBS[1]                                   |
      | destinationHub | KEY_SORT_LIST_OF_CREATED_HUBS[2]                                   |
      | movementType   | Land Haul                                                          |
      | departureTime  | {date: 15 minutes next, HH:mm}                                     |
      | durationDays   | 0                                                                  |
      | durationTime   | 01:00                                                              |
      | daysOfWeek     | monday                                                             |
      | comment        | Created by automated test at {date: 0 days next, yyyy-MM-dd-HH-mm} |
    When Operator click "ok" button on Add Movement Schedule dialog
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | hubId     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].id}    |
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | origHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                                  |
    When Operator opens Shipment Details page for shipment "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}"
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA)              |
      | result | Status: Transit                         |
      | hub    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @DeleteCreatedShipments @DeleteCreatedHubs @CloseNewWindows
  Scenario: Crossdock Movement Found and There is Available Schedule (Transit Shipment) (uid:a9823aad-1649-426f-837d-0a2dd8ba2ff7)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    When API MM - Operator creates multiple 1 new shipments with type "LAND_HAUL" from hub id "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration  | 00:00:10                                     |
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | hubId     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].id}    |
    And Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | origHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                                  |
    When Operator opens Shipment Details page for shipment "{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}"
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA)              |
      | result | Status: Transit                         |
      | hub    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op