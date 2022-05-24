@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @SearchShipment
Feature: Shipment Management - Search Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Shipment by ID - Search <= 30 Shipments with Invalid Shipment (uid:bc7c0cdf-fbcb-4db2-8c0d-a16b39e617a5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 10 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page with "invalid"
    Then Operator verifies that there is a search error modal shown with "valid shipment"
    And Operator verifies the searched shipment ids result is right except last

  Scenario: Search Shipment by ID - Search <= 30 Shipments with Empty Line (uid:a2945cf0-7404-427f-80f9-7feb06288d75)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 10 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page with "empty line"
    Then Operator verify empty line parsing error toast exist

  Scenario: Preset Setting - Save Current Shipment Filter as Preset (uid:81c46be2-466f-4c5f-b7ba-d1f15d05ddc9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator filter Start Hub = {hub-name} on Shipment Management page
    And Operator filter End Hub = {hub-name-2} on Shipment Management page
    And Operator save current filters as preset on Shipment Management page
    And Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Inter-Hub -> Shipment Management
    Then Operator select created filters preset on Shipment Management page
    And Operator verify parameters of selected filters preset on Shipment Management page

  @DeleteFilersPreset
  Scenario: Preset Setting - Delete Shipment Filter as Preset (uid:c722664d-4ef4-4f13-92d6-5074a3dde4f5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator save current filters as preset on Shipment Management page
    And Operator delete created filters preset on Shipment Management page
    And Operator refresh page
    Then Operator verify filters preset was deleted

  @DeleteShipment
  Scenario Outline: Search Shipment by Filter - <scenarioName> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator filter <filterName> = <filterValue> on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | Note                                        | scenarioName    | hiptest-uid                              | filterName      | filterValue  |
      | Search Shipment by Filter - Start Hub       | Start Hub       | uid:6fe69d4d-a6fe-4640-ac42-6a84c2617d17 | Start Hub       | {hub-name}   |
      | Search Shipment by Filter - End Hub         | End Hub         | uid:b8bf98ae-d33f-4686-a0f5-0bf4ce8eed47 | End Hub         | {hub-name-2} |

  @DeleteShipment
  Scenario Outline: Search Shipment by Filter - <scenarioName> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator clear all filters on Shipment Management page
    When Operator filter Shipment Status = Pending on Shipment Management page
    When Operator filter <filterName> = <filterValue> on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | Note                                        | scenarioName    | hiptest-uid                              | filterName      | filterValue  |
      | Search Shipment by Filter - Shipment Type   | Shipment Type   | uid:2c1f7ae7-0e00-43ea-8fcf-be5e699a4ffe | Shipment Type   | Air Haul     |

  @DeleteShipment
  Scenario Outline: Search Shipment by Filter - <scenarioName> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator clear all filters on Shipment Management page
    When Operator filter Shipment Type = Air Haul on Shipment Management page
    When Operator filter <filterName> = <filterValue> on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | Note                                        | scenarioName    | hiptest-uid                              | filterName      | filterValue  |
      | Search Shipment by Filter - Shipment Status | Shipment Status | uid:6cebf48f-e62c-4366-80ee-ec36fbbc6a82 | Shipment Status | Pending      |

  @DeleteShipment
  Scenario Outline: Search Shipment by Filter - <scenarioName> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator filter shipment based on "<filterName>" Date on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | Note                                        | scenarioName    | hiptest-uid                              | filterName      |
      | Search Shipment by Filter - Shipment Date   | Shipment Date   | uid:e10f1ad8-cdc0-4795-b816-2ae3015a36d3 | Shipment Date   |

  Scenario: Search Shipment by ID - Search <= 30 Shipments Separated by Coma (,) or Space (uid:373d0602-6f7f-4669-afbb-e606dc6fa5d2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given DB Operator gets the 10 shipment IDs
    When Operator searches multiple shipment ids in the Shipment Management Page with "comma"
    Then Operator verify cannot parse parameter id as long error toast exist

  @DeleteShipment
  Scenario: Shipment Details (uid:839a572a-8534-4456-8340-b615174dc29c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator put created parcel to shipment
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op