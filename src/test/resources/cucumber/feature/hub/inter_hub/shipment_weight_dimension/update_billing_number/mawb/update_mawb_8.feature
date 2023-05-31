@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateMAWB8
Feature: Update MAWB 8 - ID

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format tbn + <dash> + 8 digits lower-case
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | TBN-LOWER-RANDOM    |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format TBN + <dash> + 8 digits upper-case
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | TBN-UPPER-RANDOM    |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format Tbn + <dash> + 8 digits mix-case
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | TBN-MIX-RANDOM      |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format 6 digits
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | RANDOM-6-DIGITS     |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format 3 digits + <dash> + 10 digits
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | RANDOM-3-10-DIGITS  |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format 3 digits + <dash> + 4 digits + <dash> + 4 digits
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | RANDOM-3-4-4-DIGITS |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format ai + <dash> + d + 6 digits lower-case
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | AI-D-LOWER-RANDOM     |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format Ai + <dash> + D + 6 digits mix-case
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | AI-D-MIX-RANDOM       |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format AI + <dash> + D + 6 digits upper-case
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | AI-D-UPPER-RANDOM     |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format ai + <dash>  6 digits lower-case
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | AI-LOWER-RANDOM     |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format Ai + <dash> + 6 digits mix-case
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | AI-MIX-RANDOM       |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @DeleteCreatedShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for ID with Format AI + <dash> + 6 digits upper-case
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "MAWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "MAWB" page UI
    When Operator update billing number "MAWB" information on Shipment Weight Dimension page with following data:
      | mawb        | AI-UPPER-RANDOM     |
      | vendor      | {vendor-name-id-2}  |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "MAWB" has updated with new value "{KEY_SHIPMENT_UPDATED_AWB}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op