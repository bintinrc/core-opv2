#https://studio.cucumber.io/projects/210778/test-plan/folders/2110424
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateMAWB5
Feature: Update MAWB 5 - ID

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments
  Scenario: Update MAWB for ID with Format 3 digits + <dash> + 8 digits (uid:425a6c07-9c06-42ad-8488-6c2e3b4034f0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
        | mawb                 | 123-12345678         |
      | destinationAirportId | {airport-id-id-1} |
      | originAirportId      | {airport-id-id-2} |
      | vendorId             | {vendor-id-id-1}    |
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 1            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | 123-12345679           |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for ID with Format 3 digits + 8 digits (uid:13bf6ec7-b359-4412-b210-70eccf7bf604)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123-12345678         |
      | destinationAirportId | {airport-id-id-1} |
      | originAirportId      | {airport-id-id-2} |
      | vendorId             | {vendor-id-id-1}    |
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 1            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | 12312345678           |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for ID with Format 7 digits + <dash> + 6 digits (uid:40a406a9-689d-4255-a74b-60fd16c15796)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123-12345678         |
      | destinationAirportId | {airport-id-id-1} |
      | originAirportId      | {airport-id-id-2} |
      | vendorId             | {vendor-id-id-1}    |
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 1            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | 1234567-123456           |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for ID with Format 6 digits + <dash> + 6 digits (uid:354e45ec-d9a2-45b2-b4be-1c6ea1cfcf3b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123-12345678         |
      | destinationAirportId | {airport-id-id-1} |
      | originAirportId      | {airport-id-id-2} |
      | vendorId             | {vendor-id-id-1}    |
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 1            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | 123456-123456          |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for ID with Format 10 digits (uid:00cf7940-6382-4aa6-9385-ef8cf5c08b05)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123-12345678         |
      | destinationAirportId | {airport-id-id-1} |
      | originAirportId      | {airport-id-id-2} |
      | vendorId             | {vendor-id-id-1}    |
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 1            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | 1231237890          |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for ID with Format tgn + <dash> + 8 digits lower-case (uid:0e10a9dc-bfdf-4b1f-a9d0-d5c2cc5a2ee6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123-12345678         |
      | destinationAirportId | {airport-id-id-1} |
      | originAirportId      | {airport-id-id-2} |
      | vendorId             | {vendor-id-id-1}    |
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 1            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | tgn-12345678          |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for ID with Format TGN + <dash> + 8 digits upper-case (uid:477696a5-3b32-4701-adcb-3be0dbcbf0d3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123-12345678         |
      | destinationAirportId | {airport-id-id-1} |
      | originAirportId      | {airport-id-id-2} |
      | vendorId             | {vendor-id-id-1}    |
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 1            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | TGN-12345678         |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for ID with Format Tgn + <dash> + 8 digits mix-case (uid:6c3fb0e7-a401-4878-98ff-f89c500b0165)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123-12345678         |
      | destinationAirportId | {airport-id-id-1} |
      | originAirportId      | {airport-id-id-2} |
      | vendorId             | {vendor-id-id-1}    |
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 1            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | Tgn-12345678         |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for ID with Format 3 digits + <dash> + 7 digits (uid:7d938bf6-6357-4596-854c-ee0027b27268)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123-12345678         |
      | destinationAirportId | {airport-id-id-1} |
      | originAirportId      | {airport-id-id-2} |
      | vendorId             | {vendor-id-id-1}    |
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 1            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | 123-1234567         |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for ID with Format 8 digits (uid:90e531c3-8fc7-4d3f-bc32-67596e251ff0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-id-1}" to "{hub-id-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123-12345678         |
      | destinationAirportId | {airport-id-id-1} |
      | originAirportId      | {airport-id-id-2} |
      | vendorId             | {vendor-id-id-1}    |
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 1            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | 12345678         |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op

