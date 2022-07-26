@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @EditShipment4
Feature: Shipment Management - Edit Shipment 4

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario Outline: Edit Shipment - <type> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page based on "<type>" using data below:
      | origHubName | {hub-name-3}                                                         |
      | destHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | EDA         | {gradle-next-1-day-yyyy-MM-dd}                                       |
      | ETA         | 01:00:01                                                             |
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | type      | hiptest-uid                              |
      | Start Hub | uid:1087986d-905c-4d2c-ad92-b3139f69d8fd |

  @DeleteShipment
  Scenario Outline: Edit Shipment - <type> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page based on "<type>" using data below:
      | origHubName | {hub-name}                                                         |
      | destHubName | {hub-name-3}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | EDA         | {gradle-next-1-day-yyyy-MM-dd}                                       |
      | ETA         | 01:00:01                                                             |
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | type      | hiptest-uid                              |
      | End Hub   | uid:2a179fc7-9139-455d-b1a2-d4e5582c88a7 |
      | Comments  | uid:af9bb414-10d0-4dc6-a298-189e2884c63f |

  @DeleteShipment
  Scenario Outline: Edit Shipment <title> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page based on "<type>" using data below:
      | origHubName | {hub-name-2}                                                        |
      | destHubName | {hub-name}                                                          |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb        | MAWB-{KEY_CREATED_SHIPMENT_ID}                                      |
    And Operator close current window and switch to Shipment management page
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | title             | type     | hiptest-uid                              |
      | without Edit MAWB | non-mawb | uid:771d3f81-175d-43b1-ac65-35de391ac540 |

  @DeleteShipment
  Scenario Outline: Edit Shipment <title> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API get all Vendors
    And API get all Airports
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    When Operator edit Shipment on Shipment Management page based on "<type>" using data below:
      | origHubName     | {hub-name-2}                                                        |
      | destHubName     | {hub-name}                                                          |
      | comments        | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
      | mawb            | {KEY_CREATED_SHIPMENT_ID}                                           |
      | mawbVendor      | {KEY_LIST_OF_VENDORS[1]}                                            |
      | MawbOrigin      | {KEY_LIST_OF_AIRPORTS[1]}                                           |
      | MawbDestination | {KEY_LIST_OF_AIRPORTS[2]}                                           |
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | title             | type     | hiptest-uid                              |
      | with Edit MAWB    | mawb     | uid:32bd221d-d194-4988-a4a8-4185f3aaafc2 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op