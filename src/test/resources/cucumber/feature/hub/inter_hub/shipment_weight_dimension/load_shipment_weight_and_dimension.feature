# https://studio.cucumber.io/projects/210778/test-plan/folders/2075581
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @Load @CWF
Feature: Load Shipment Weight and Dimension

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  # https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6820614
  @DeleteShipment
  Scenario:  Load Shipment Weight and Dimension by Creation Date Time and MAWB
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | mawb            | {KEY_SHIPMENT_AWB}            |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6820623
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension by Creation Date Time
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6820624
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension by MAWB
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | mawb            | {KEY_SHIPMENT_AWB}            |
    Then Operator verify search button is disabled on Shipment Weight Dimension page
    When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | search_valid |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6820637
  @DeleteShipment
  Scenario:Load Shipment Weight and Dimension by Enter New Filters
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator click Enter New Filter button on Shipment Weight Dimension Filter UI
    Then Operator verify Enter New Filter card on Shipment Weight Dimension Filter UI
    Then Operator fill Shipment Weight Dimension Filter UI with data
      | shipmentType    | Air Haul        |
      | startHub        | {hub-name}      |
      | endHub          | {hub-name-2}    |
      | shipmentStatus  | Pending,Closed  |
      | saveAsPreset    | true            |
      | presetName      | RANDOM          |
    When Operator fill in Load Shipment Weight filter
      | mawb            | INVALID                       |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension search error popup shown
    And Operator close Shipment Weight Dimension search error popup
    When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | search_valid |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

# https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6820662
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension by Enter New Filters then Clear and Close Filter
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator click Enter New Filter button on Shipment Weight Dimension Filter UI
    Then Operator verify Enter New Filter card on Shipment Weight Dimension Filter UI
    Then Operator fill Shipment Weight Dimension Filter UI with data
      | shipmentType    | Air Haul        |
      | startHub        | {hub-name}      |
      | endHub          | {hub-name-2}    |
      | shipmentStatus  | Pending,Closed  |
      | saveAsPreset    | true            |
      | presetName      | RANDOM          |
    When Operator fill in Load Shipment Weight filter
      | mawb            | INVALID                       |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
    Then Operator click Clear and Close button on Shipment Weight Dimension
    When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | search_valid |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6876578
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension by Creation Date Time Filter
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6889151
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension by MAWB Time Filter
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | mawb            | {KEY_SHIPMENT_AWB}            |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6889240
  Scenario: Load Shipment Weight and Dimension by Empty Filters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension search error popup shown
    And Operator close Shipment Weight Dimension search error popup

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6889242
  Scenario: Load Shipment Weight and Dimension by Filter - No Shipment
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name}  |
      | createdTime     | FUTURE                         |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension search error popup shown
    And Operator close Shipment Weight Dimension search error popup

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6936829
  Scenario: Load Shipment Weight and Dimension - Delete selected Preset Filter
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Given API Operator create shipment weight dimension preset
      | name            | RANDOM          |
      | destinationHubs | {hub-id-2}      |
      | originHubs      | {hub-id}        |
      | shipmentStatus  | PENDING,CLOSED  |
      | shipmentType    | AIR_HAUL        |
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {KEY_CREATED_SHIPMENT_WEIGHT_FILTER}  |
    Then Operator delete the shipment weight filter preset
    And Operator verify Shipment Weight Dimension confirm delete popup shown
    Then Operator confirm Shipment Weight Dimension confirm delete popup
    And Operator verify shipment weight preset "{KEY_CREATED_SHIPMENT_WEIGHT_FILTER}" is deleted

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6936848
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension by Select existing Preset Filters
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/6936853
  Scenario: Load Shipment Weight and Dimension - Cancel Delete selected Preset Filter
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Given API Operator create shipment weight dimension preset
      | name            | RANDOM          |
      | destinationHubs | {hub-id-2}      |
      | originHubs      | {hub-id}        |
      | shipmentStatus  | PENDING,CLOSED  |
      | shipmentType    | AIR_HAUL        |
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {KEY_CREATED_SHIPMENT_WEIGHT_FILTER}  |
    Then Operator delete the shipment weight filter preset
    And Operator verify Shipment Weight Dimension confirm delete popup shown
    Then Operator cancel Shipment Weight Dimension confirm delete popup
    And Operator verify shipment weight preset "{KEY_CREATED_SHIPMENT_WEIGHT_FILTER}" is not deleted
    And Operator verify Selected Filter card on Shipment Weight Dimension Filter UI

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018972
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Shipment ID field
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
      | mawb            | {KEY_SHIPMENT_AWB}            |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table
    When Operator filter Shipment Weight Dimension Table by "shipment_id" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018982
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Shipment Status field
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
      | mawb            | {KEY_SHIPMENT_AWB}            |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table
    When Operator filter Shipment Weight Dimension Table by "status" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018984
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by End Hub field
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
      | mawb            | {KEY_SHIPMENT_AWB}            |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table
    When Operator filter Shipment Weight Dimension Table by "end_hub" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018985
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Shipment Creation Date Time field
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
      | mawb            | {KEY_SHIPMENT_AWB}            |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table
    When Operator filter Shipment Weight Dimension Table by "creation_date" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018988
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by MAWB field
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
      | mawb            | {KEY_SHIPMENT_AWB}            |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018992
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Comments field
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
      | mawb            | {KEY_SHIPMENT_AWB}            |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table
    When Operator filter Shipment Weight Dimension Table by "comments" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018994
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Start Hub field
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
      | mawb            | {KEY_SHIPMENT_AWB}            |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table
    When Operator filter Shipment Weight Dimension Table by "start_hub" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2075581/scenarios/7018995
  @DeleteShipment
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Shipment Type field
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId            | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}   |
      | mawb                  | RANDOM                                  |
      | destinationAirportId  | {airport-id-1}                          |
      | originAirportId       | {airport-id-2}                          |
      | vendorId              | {vendor_id}                             |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator fill in Load Shipment Weight filter
      | presetName      | {shipment-weight-filter-name} |
      | createdTime     | {KEY_SHIPMENT_CREATION_DATE}  |
      | mawb            | {KEY_SHIPMENT_AWB}            |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    And Operator verify can filter Shipment Weight Dimension Table
    When Operator filter Shipment Weight Dimension Table by "shipment_type" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "1" as counter


  @KillBrowser
  Scenario: Kill Browser
    Given no-op
