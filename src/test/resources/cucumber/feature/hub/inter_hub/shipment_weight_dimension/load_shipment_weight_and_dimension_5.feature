@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @Load5
Feature: Load Shipment Weight and Dimension 5

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments
  Scenario: Load Shipment Weight and Dimension by Enter New Filters and Save Preset Filter
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator click Enter New Filter button on Shipment Weight Dimension Filter UI
    Then Operator verify Enter New Filter card on Shipment Weight Dimension Filter UI
    Then Operator fill Shipment Weight Dimension Filter UI with data
      | shipmentType   | Air Haul       |
      | startHub       | {hub-name}     |
      | endHub         | {hub-name-2}   |
      | shipmentStatus | Pending,Closed |
      | saveAsPreset   | true           |
      | presetName     | RANDOM         |
    When Operator fill in Load Shipment Weight filter
      | createdTime | {KEY_SHIPMENT_CREATION_DATE} |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown

  @DeleteCreatedShipments
  Scenario: Load Shipment Weight and Dimension by Enter New Filters and Save Preset Filter with Duplicate Name
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator click Enter New Filter button on Shipment Weight Dimension Filter UI
    Then Operator verify Enter New Filter card on Shipment Weight Dimension Filter UI
    Then Operator fill Shipment Weight Dimension Filter UI with data
      | shipmentType   | Air Haul       |
      | startHub       | {hub-name}     |
      | endHub         | {hub-name-2}   |
      | shipmentStatus | Pending,Closed |
      | saveAsPreset   | true           |
      | presetName     | RANDOM         |
    When Operator fill in Load Shipment Weight filter
      | createdTime | {KEY_SHIPMENT_CREATION_DATE} |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator click Enter New Filter button on Shipment Weight Dimension Filter UI
    Then Operator verify Enter New Filter card on Shipment Weight Dimension Filter UI
    Then Operator fill Shipment Weight Dimension Filter UI with data
      | shipmentType   | Air Haul                             |
      | startHub       | {hub-name}                           |
      | endHub         | {hub-name-2}                         |
      | shipmentStatus | Pending,Closed                       |
      | saveAsPreset   | true                                 |
      | presetName     | {KEY_CREATED_SHIPMENT_WEIGHT_FILTER} |
    Then Operator verifies "Duplicated name. Try another one." error message is shown on Shipment Weight Dimension Filter UI

  @DeleteCreatedShipments
  Scenario: Load Shipment Weight and Dimension by Enter New Filters and Cancel Save Preset Filter with Duplicate Name
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator click Enter New Filter button on Shipment Weight Dimension Filter UI
    Then Operator verify Enter New Filter card on Shipment Weight Dimension Filter UI
    Then Operator fill Shipment Weight Dimension Filter UI with data
      | shipmentType   | Air Haul       |
      | startHub       | {hub-name}     |
      | endHub         | {hub-name-2}   |
      | shipmentStatus | Pending,Closed |
      | saveAsPreset   | true           |
      | presetName     | RANDOM         |
    When Operator fill in Load Shipment Weight filter
      | createdTime | {KEY_SHIPMENT_CREATION_DATE} |
    And Operator click Load Selection button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    And Operator verify Shipment Weight Dimension Filter UI
    When Operator click Enter New Filter button on Shipment Weight Dimension Filter UI
    Then Operator verify Enter New Filter card on Shipment Weight Dimension Filter UI
    Then Operator fill Shipment Weight Dimension Filter UI with data
      | shipmentType   | Air Haul       |
      | startHub       | {hub-name}     |
      | endHub         | {hub-name-2}   |
      | shipmentStatus | Pending,Closed |
      | saveAsPreset   | true           |
      | presetName     | RANDOM         |
    When Operator fill in Load Shipment Weight filter
      | createdTime | {KEY_SHIPMENT_CREATION_DATE} |
    Then Operator click Clear and Close button on Shipment Weight Dimension
    Then Operator verifies "Filters are cleared" popup is shown on Shipment Weight Dimension Filter UI

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Vendor field
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = "{hub-id}" to hub id = "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | RANDOM                 |
      | vendor      | {local-vendor-name}    |
      | origin      | {local-airport-1-code} |
      | destination | {local-airport-2-code} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"
    When Operator search the "VENDOR" column with inputted data "{local-vendor-name}" on Shipment Weight Dimension Table
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Origin Port field
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = "{hub-id}" to hub id = "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | RANDOM                 |
      | vendor      | {local-vendor-name}    |
      | origin      | {local-airport-1-code} |
      | destination | {local-airport-2-code} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"
    When Operator search the "ORIGIN PORT" column with inputted data "{local-airport-1-name}" on Shipment Weight Dimension Table
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Load Shipment Weight and Dimension and Select All Data Searched by Destination Port field
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API MM - Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = "{hub-id}" to hub id = "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | RANDOM                 |
      | vendor      | {local-vendor-name}    |
      | origin      | {local-airport-1-code} |
      | destination | {local-airport-2-code} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"
    When Operator search the "DESTINATION PORT" column with inputted data "{local-airport-2-name}" on Shipment Weight Dimension Table
    And Operator select all data on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter
    When Operator clear filter on Shipment Weight Dimension Table
    Then Operator verify Sum up button on Shipment Weight Dimension Table have "2" as counter

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op