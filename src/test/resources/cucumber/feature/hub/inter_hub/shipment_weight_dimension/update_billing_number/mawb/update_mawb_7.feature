@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateMAWB7
Feature: Update MAWB 7 - MY

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format K14B + 7 digits uppercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | K14B1234567         |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format K14B + 7 digits lowercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | k14b1234576         |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format K14B + 7 digits mixcase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | K14b1234567         |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format K14B + 8 digits uppercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | K14B12345678        |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format K14B + 8 digits lowercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | k14b12345678        |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format K14B + 8 digits mixcase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | K14b12345678        |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format R11B + 7 digits uppercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | R11B1234567         |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format R11B + 7 digits lowercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | r11b1234567         |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format R11B + 7 digits mixcase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | R11b1234567         |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format R11B + 8 digits uppercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | R11B12345678        |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format R11B + 8 digits lowercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | r11b12345678        |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Update MAWB for MY with Format R11B + 8 digits mixcase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234            |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}  |
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | R11b12345678        |
      | vendor      | {vendor-name-my-2}  |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @KillBrowser
  Scenario: Kill Browser
    Given no-op