# https://studio.cucumber.io/projects/210778/test-plan/folders/2066579
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @SearchBySID
Feature: Search by SID

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  #  https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/6796810
  @HappyPath @DeleteCreatedShipments
  Scenario: Search by SID with Single Valid Shipment ID
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | search_valid |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

  #  https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/6796818
  @HappyPath
  Scenario: Search by SID with Single Invalid Shipment ID
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "INVALID" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | search_valid |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension search error popup shown
    And Operator close Shipment Weight Dimension search error popup

  #  https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/6796820
  @DeleteCreatedShipments
  Scenario: Search by SID with Multiple Valid Shipment IDs < 300
    Given API Operator create multiple 20 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 20           |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown

  #  https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/6796822
  Scenario: Search by SID with Multiple Invalid Shipment IDs < 300
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE_INVALID" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 20           |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension search error popup shown
    And Operator close Shipment Weight Dimension search error popup

  @DeleteCreatedShipments
  Scenario: Search by SID with Multiple Valid Shipment IDs > 300
    Given API Operator create multiple 301 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 301          |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown

  Scenario: Search by SID with Multiple Invalid Shipment IDs > 300
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE_INVALID_MORE_300" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 301          |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension search error popup shown
    And Operator close Shipment Weight Dimension search error popup

  #  https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/6796824
  @DeleteCreatedShipments
  Scenario: Search by SID with input Single JSON Shipment ID
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "JSON" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | search_valid |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

  #  https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/6796826
  @DeleteCreatedShipments
  Scenario: Search by SID with input Multiple JSON Shipment ID
    Given API Operator create multiple 20 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE_JSON" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 20           |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown

  #  https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/6796825
  @HappyPath @DeleteCreatedShipments
  Scenario: Search by SID with Duplicate Shipment ID
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "DUPLICATE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | duplicate |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

  # https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/6853705
  @HappyPath @DeleteCreatedShipments
  Scenario: Search by SID with Valid Shipment ID but has NO Weight and Dimension
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | search_valid |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension search error popup shown
    When Operator close Shipment Weight Dimension search error popup
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

  # https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/7015320
  @HappyPath @DeleteCreatedShipments
  Scenario: Search by SID and Select All Data Searched by Shipment ID field
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "shipment_id" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

  # https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/7018898
  @DeleteCreatedShipments
  Scenario: Search by SID and Select All Data Searched by Shipment Status field
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "status" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter

  #  https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/7018906
  @DeleteCreatedShipments
  Scenario: Search by SID and Select All Data Searched by End Hub field
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "end_hub" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter

  # https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/7018908
  @DeleteCreatedShipments
  Scenario: Search by SID and Select All Data Searched by Shipment Creation Date Time field
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "created-at" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

  #  https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/7018914
  @DeleteCreatedShipments
  Scenario: Search by SID and Select All Data Searched by Comments field
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "comments" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter

  @DeleteCreatedShipments
  Scenario: Search by SID and Select All Data Searched by Start Hub field
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "start_hub" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter

  # https://studio.cucumber.io/projects/210778/test-plan/folders/2066579/scenarios/7018917
  @DeleteCreatedShipments
  Scenario: Search by SID and Select All Data Searched by Shipment Type field
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "shipment_type" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
