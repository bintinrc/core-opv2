#https://studio.cucumber.io/projects/210778/test-plan/folders/2110424
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateMAWB4
Feature: Update MAWB 4 - PH

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments
  Scenario: Update MAWB for PH with format 3 digits + <space> + 5 digits (uid:0eca8942-67d2-4dec-893a-b01011bcce9e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-ph-2}" to "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123 12345         |
      | destinationAirportId | {airport-id-ph-1} |
      | originAirportId      | {airport-id-ph-2} |
      | vendorId             | {vendor-id-ph-1}  |
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
      | mawb        | 123 23456           |
      | vendor      | {vendor-name-ph-2}  |
      | origin      | {airport-name-ph-2} |
      | destination | {airport-name-ph-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for PH with format rlb + <space> + 5 digits lower-case (uid:043c913c-945d-42e7-bba2-5dd372e1e7af)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-ph-2}" to "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123 12345         |
      | destinationAirportId | {airport-id-ph-1} |
      | originAirportId      | {airport-id-ph-2} |
      | vendorId             | {vendor-id-ph-1}  |
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
      | mawb        | rlb 23456           |
      | vendor      | {vendor-name-ph-2}  |
      | origin      | {airport-name-ph-2} |
      | destination | {airport-name-ph-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for PH with format RLB + <space> + 5 digits upper-case (uid:8e074519-7d2e-4e68-a63e-e64b57604d98)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-ph-2}" to "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123 12345         |
      | destinationAirportId | {airport-id-ph-1} |
      | originAirportId      | {airport-id-ph-2} |
      | vendorId             | {vendor-id-ph-1}  |
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
      | mawb        | RLB 23456           |
      | vendor      | {vendor-name-ph-2}  |
      | origin      | {airport-name-ph-2} |
      | destination | {airport-name-ph-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for PH with format Rlb + <space> + 5 digits mix-case (uid:b4ef2231-ef90-4ba3-a7cc-eb4ed9832392)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-ph-2}" to "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123 12345         |
      | destinationAirportId | {airport-id-ph-1} |
      | originAirportId      | {airport-id-ph-2} |
      | vendorId             | {vendor-id-ph-1}  |
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
      | mawb        | Rlb 23456           |
      | vendor      | {vendor-name-ph-2}  |
      | origin      | {airport-name-ph-2} |
      | destination | {airport-name-ph-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for PH with format 3 digits + <space> + 10 digits (uid:c49534fb-d995-41ac-94a6-4b44f23054df)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-ph-2}" to "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123 12345         |
      | destinationAirportId | {airport-id-ph-1} |
      | originAirportId      | {airport-id-ph-2} |
      | vendorId             | {vendor-id-ph-1}  |
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
      | mawb        | 123 2345654321      |
      | vendor      | {vendor-name-ph-2}  |
      | origin      | {airport-name-ph-2} |
      | destination | {airport-name-ph-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for PH with Format 3 digits + <space> + 8 digits (uid:57d90bfd-b7a5-479a-8ec1-05743cfaa09e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-ph-2}" to "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123 12345         |
      | destinationAirportId | {airport-id-ph-1} |
      | originAirportId      | {airport-id-ph-2} |
      | vendorId             | {vendor-id-ph-1}  |
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
      | mawb        | 123 23456543        |
      | vendor      | {vendor-name-ph-2}  |
      | origin      | {airport-name-ph-2} |
      | destination | {airport-name-ph-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for PH with Format 5 digits
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-ph-2}" to "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123 12345         |
      | destinationAirportId | {airport-id-ph-1} |
      | originAirportId      | {airport-id-ph-2} |
      | vendorId             | {vendor-id-ph-1}  |
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
      | mawb        | 12345               |
      | vendor      | {vendor-name-ph-2}  |
      | origin      | {airport-name-ph-2} |
      | destination | {airport-name-ph-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for PH with Format 6 digits
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-ph-2}" to "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123 12345         |
      | destinationAirportId | {airport-id-ph-1} |
      | originAirportId      | {airport-id-ph-2} |
      | vendorId             | {vendor-id-ph-1}  |
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
      | mawb        | 123456              |
      | vendor      | {vendor-name-ph-2}  |
      | origin      | {airport-name-ph-2} |
      | destination | {airport-name-ph-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for PH with Format 9 digits
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-ph-2}" to "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123 12345         |
      | destinationAirportId | {airport-id-ph-1} |
      | originAirportId      | {airport-id-ph-2} |
      | vendorId             | {vendor-id-ph-1}  |
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
      | mawb        | 123456789           |
      | vendor      | {vendor-name-ph-2}  |
      | origin      | {airport-name-ph-2} |
      | destination | {airport-name-ph-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB for PH with Format 000 + <dash> + 8 digits
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id-ph-2}" to "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | 123 12345         |
      | destinationAirportId | {airport-id-ph-1} |
      | originAirportId      | {airport-id-ph-2} |
      | vendorId             | {vendor-id-ph-1}  |
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
      | mawb        | 000-12345678        |
      | vendor      | {vendor-name-ph-2}  |
      | origin      | {airport-name-ph-2} |
      | destination | {airport-name-ph-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op

