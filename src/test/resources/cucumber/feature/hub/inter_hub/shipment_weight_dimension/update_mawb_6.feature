#https://studio.cucumber.io/projects/210778/test-plan/folders/2110424
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateMAWB6
Feature: Update MAWB 6 - ID

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments
  Scenario: Update MAWB for ID with Format tgn + <dash> + 7 digits lower-case (uid:28f7df97-43e4-49ab-a6cb-6c6feb28379e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-id-1} to hub id = {hub-id-id-2}
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
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | tgn-1234567           |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for ID with Format TGN + <dash> + 7 digits upper-case (uid:30ef17ea-ba16-4830-bc8b-2d74496a0510)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-id-1} to hub id = {hub-id-id-2}
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
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | TGN-1234567           |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for ID with Format Tgn + <dash> + 7 digits mix-case (uid:11f80322-ca7c-420d-8e1c-9434ccdeeb3b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-id-1} to hub id = {hub-id-id-2}
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
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | Tgn-1234567          |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for ID with Format 3 letters lower-case + 4 digits (uid:019bdcf7-2e6a-48a4-9f0b-5017c4d14a6c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-id-1} to hub id = {hub-id-id-2}
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
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | abc1234          |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for ID with Format 3 letters upper-case + 4 digits (uid:6c7f027a-3dc3-45e5-8e88-ccadec70cdc1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-id-1} to hub id = {hub-id-id-2}
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
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | ABC1234          |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for ID with Format 3 letters mix-case + 4 digits (uid:02f74fed-202b-4c47-823f-24b337261d4a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-id-1} to hub id = {hub-id-id-2}
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
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | Abc1234          |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for ID with Format 3 letters lower-case + 5 digits (uid:801c7db0-6f82-4020-b40c-e3d3c9dbe08d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-id-1} to hub id = {hub-id-id-2}
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
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | abc12345         |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for ID with Format 3 letters upper-case + 5 digits (uid:82b42699-3b87-425e-84b6-ffdbb26ea64d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-id-1} to hub id = {hub-id-id-2}
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
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | ABC12345         |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for ID with Format 3 letters mix-case + 5 digits (uid:6cf26381-144f-4799-8cf5-c7106a3c3fb4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Indonesia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-id-1} to hub id = {hub-id-id-2}
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
    When Operator filter Shipment Weight Dimension Table by "mawb" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | Abc12345        |
      | vendor      | {vendor-name-id-2}    |
      | origin      | {airport-name-id-2} |
      | destination | {airport-name-id-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @KillBrowser
  Scenario: Kill Browser
    Given no-op

