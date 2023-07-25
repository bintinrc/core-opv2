#https://studio.cucumber.io/projects/210778/test-plan/folders/2110424
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateMAWB
Feature: Update MAWB

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  https://studio.cucumber.io/projects/210778/test-plan/folders/2110424/scenarios/6948803
  @DeleteCreatedShipments
  Scenario: Select Some SID from Sum up Report and Update MAWB
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select 4 rows from the shipment weight table
    When Operator click sum up button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Sum Up report page UI for shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
    And Operator select all rows from the shipment sum up report table
    When Operator click update MAWB button on Shipment Weight Sum Up page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | RANDOM                 |
      | vendor      | {other-vendor-name}    |
      | origin      | {other-airport-name-1} |
      | destination | {other-airport-name-2} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @HappyPath @DeleteCreatedShipments
  Scenario: Select All SID from Sum up Report and Update MAWB - Create New MAWB Number
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click sum up button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Sum Up report page UI for shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
    And Operator select all rows from the shipment sum up report table
    When Operator click update MAWB button on Shipment Weight Sum Up page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | RANDOM                 |
      | vendor      | {other-vendor-name}    |
      | origin      | {other-airport-name-1} |
      | destination | {other-airport-name-2} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @HappyPath @DeleteCreatedShipments
  Scenario: Select SID from Sum up Report and Update MAWB with existing MAWB - Update Vendor
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | mawb                 | RANDOM                                |
      | destinationAirportId | {airport-id-1}                        |
      | originAirportId      | {airport-id-2}                        |
      | vendorId             | {vendor-id}                           |
    Given Operator take note of the existing mawb
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click sum up button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Sum Up report page UI for shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
    And Operator select all rows from the shipment sum up report table
    When Operator click update MAWB button on Shipment Weight Sum Up page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | {KEY_EXISTING_SHIPMENT_AWB}     |
      | vendor      | {other-vendor-name}             |
      | origin      | {airport-name-1}                |
      | destination | {airport-name-2}                |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @HappyPath @DeleteCreatedShipments
  Scenario: Select SID from Sum up Report and Update MAWB with existing MAWB - Update Origin Airport
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | mawb                 | RANDOM                                |
      | destinationAirportId | {airport-id-1}                        |
      | originAirportId      | {airport-id-2}                        |
      | vendorId             | {vendor-id}                           |
    Given Operator take note of the existing mawb
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click sum up button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Sum Up report page UI for shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
    And Operator select all rows from the shipment sum up report table
    When Operator click update MAWB button on Shipment Weight Sum Up page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | {KEY_EXISTING_SHIPMENT_AWB}     |
      | vendor      | {vendor-name}                   |
      | origin      | {other-airport-name-1}          |
      | destination | {airport-name-2}                |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @HappyPath @DeleteCreatedShipments
  Scenario: Select SID from Sum up Report and Update MAWB with existing MAWB - Update Destination Airport
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | mawb                 | RANDOM                                |
      | destinationAirportId | {airport-id-1}                        |
      | originAirportId      | {airport-id-2}                        |
      | vendorId             | {vendor-id}                           |
    Given Operator take note of the existing mawb
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click sum up button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Sum Up report page UI for shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
    And Operator select all rows from the shipment sum up report table
    When Operator click update MAWB button on Shipment Weight Sum Up page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | {KEY_EXISTING_SHIPMENT_AWB}     |
      | vendor      | {vendor-name}                   |
      | origin      | {airport-name-1}                |
      | destination | {other-airport-name-2}          |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Select SID from Sum up Report and Update MAWB with existing MAWB - Update Vendor, Origin Airport, and Destination Airport
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | mawb                 | RANDOM                                |
      | destinationAirportId | {airport-id-1}                        |
      | originAirportId      | {airport-id-2}                        |
      | vendorId             | {vendor-id}                           |
    Given Operator take note of the existing mawb
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click sum up button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Sum Up report page UI for shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
    And Operator select all rows from the shipment sum up report table
    When Operator click update MAWB button on Shipment Weight Sum Up page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | {KEY_EXISTING_SHIPMENT_AWB}     |
      | vendor      | {other-vendor-name}             |
      | origin      | {other-airport-name-1}          |
      | destination | {other-airport-name-2}          |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @HappyPath @DeleteCreatedShipments
  Scenario: Select SID from Sum up Report and Update MAWB with Invalid Format
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click sum up button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Sum Up report page UI for shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
    And Operator select all rows from the shipment sum up report table
    When Operator click update MAWB button on Shipment Weight Sum Up page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | INVALID                         |
      | vendor      | {other-vendor-name}             |
      | origin      | {other-airport-name-1}          |
      | destination | {other-airport-name-2}          |
    Then Operator verify Shipment Weight Update MAWB page UI has error
      | message     | Invalid MAWB Format |

  @DeleteCreatedShipments
  Scenario: Select SID from Sum up Report and Update MAWB with Symbols/Alphabets MAWB
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click sum up button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Sum Up report page UI for shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
    And Operator select all rows from the shipment sum up report table
    When Operator click update MAWB button on Shipment Weight Sum Up page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | ALFABET                         |
      | vendor      | {other-vendor-name}             |
      | origin      | {other-airport-name-1}          |
      | destination | {other-airport-name-2}          |
    Then Operator verify Shipment Weight Update MAWB page UI has error
      | message     | Invalid MAWB Format |

  @DeleteCreatedShipments
  Scenario: Select SID from Sum up Report and Cancel Update MAWB with existing MAWB
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | mawb                 | RANDOM                                |
      | destinationAirportId | {airport-id-1}                        |
      | originAirportId      | {airport-id-2}                        |
      | vendorId             | {vendor-id}                           |
    Given Operator take note of the existing mawb
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click sum up button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Sum Up report page UI for shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
    And Operator select all rows from the shipment sum up report table
    When Operator click update MAWB button on Shipment Weight Sum Up page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | {KEY_EXISTING_SHIPMENT_AWB}     |
      | vendor      | {other-vendor-name}             |
      | origin      | {other-airport-name-1}          |
      | destination | {other-airport-name-2}          |
    And Operator click update button only on shipment weight update mawb page
    And Operator click cancel on the Shipment weight update confirm dialog

  @HappyPath @DeleteCreatedShipments
  Scenario: Select SID from Sum up Report and Update MAWB with Empty MAWB
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click sum up button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Sum Up report page UI for shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
    And Operator select all rows from the shipment sum up report table
    When Operator click update MAWB button on Shipment Weight Sum Up page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        |  EMPTY                          |
      | vendor      | {other-vendor-name}             |
      | origin      | {other-airport-name-1}          |
      | destination | {other-airport-name-2}          |
    Then Operator verify Shipment Weight Update MAWB page UI has error
      | message     |                                 |

  @HappyPath @DeleteCreatedShipments
  Scenario: Update MAWB without Download Sum Up Report - Create New MAWB Number
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | RANDOM                 |
      | vendor      | {other-vendor-name}    |
      | origin      | {other-airport-name-1} |
      | destination | {other-airport-name-2} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @HappyPath @DeleteCreatedShipments
  Scenario: Update MAWB without Download Sum Up Report - Update Vendor
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | mawb                 | RANDOM                                |
      | destinationAirportId | {airport-id-1}                        |
      | originAirportId      | {airport-id-2}                        |
      | vendorId             | {vendor-id}                           |
    Given Operator take note of the existing mawb
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | {KEY_EXISTING_SHIPMENT_AWB}     |
      | vendor      | {other-vendor-name}             |
      | origin      | {airport-name-1}          |
      | destination | {airport-name-2}          |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @HappyPath @DeleteCreatedShipments
  Scenario: Update MAWB without Download Sum Up Report - Update Origin Airport
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | mawb                 | RANDOM                                |
      | destinationAirportId | {airport-id-1}                        |
      | originAirportId      | {airport-id-2}                        |
      | vendorId             | {vendor-id}                           |
    Given Operator take note of the existing mawb
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | {KEY_EXISTING_SHIPMENT_AWB}     |
      | vendor      | {vendor-name}             |
      | origin      | {other-airport-name-1}          |
      | destination | {airport-name-2}          |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @HappyPath @DeleteCreatedShipments
  Scenario: Update MAWB without Download Sum Up Report - Update Destination Airport
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | mawb                 | RANDOM                                |
      | destinationAirportId | {airport-id-1}                        |
      | originAirportId      | {airport-id-2}                        |
      | vendorId             | {vendor-id}                           |
    Given Operator take note of the existing mawb
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | {KEY_EXISTING_SHIPMENT_AWB}     |
      | vendor      | {vendor-name}             |
      | origin      | {airport-name-1}          |
      | destination | {other-airport-name-2}          |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteCreatedShipments
  Scenario: Update MAWB without Download Sum Up Report - Update Vendor, Origin Airport, and Destination Airport
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given API Operator link mawb for following shipment id
      | shipmentId           | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
      | mawb                 | RANDOM                                |
      | destinationAirportId | {airport-id-1}                        |
      | originAirportId      | {airport-id-2}                        |
      | vendorId             | {vendor-id}                           |
    Given Operator take note of the existing mawb
    Given API MM - Operator creates multiple 5 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 5            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 5 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | {KEY_EXISTING_SHIPMENT_AWB}     |
      | vendor      | {other-vendor-name}             |
      | origin      | {other-airport-name-1}          |
      | destination | {other-airport-name-2}          |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @KillBrowser
  Scenario: Kill Browser
    Given no-op

