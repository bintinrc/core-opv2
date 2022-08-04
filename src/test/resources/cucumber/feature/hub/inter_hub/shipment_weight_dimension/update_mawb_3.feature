#https://studio.cucumber.io/projects/210778/test-plan/folders/2110424
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateMAWB3
Feature: Update MAWB 3

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments
  Scenario: Update MAWB for MY with format 10 digits number (uid:a1c09149-7a6a-4403-bb3e-d7480fe91db8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
        | mawb                 | la1234         |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}    |
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
      | mawb        | 1231231234            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 15 lower-case (uid:7df127c1-3d5e-40cd-a886-99bbe764a42a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234         |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}    |
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
      | mawb        | mx123456789012345            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 15 mix-case (uid:9af82468-0f27-402e-82e9-994bda816fec)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234         |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}    |
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
      | mawb        | Mx123456789012345            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 15 upper-case (uid:08fa3dbb-dd67-4b3f-9da1-f9834c6ba3f3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234         |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}    |
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
      | mawb        | MX123456789012345            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 16 lower-case (uid:fe19712f-5aed-4a80-b9c8-b13e506af407)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234         |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}    |
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
      | mawb        | mx1234567890123456            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 16 mix-case (uid:c39b4e12-c498-44a6-8d61-bae6a1212030)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234         |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}    |
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
      | mawb        | Mx1234567890123456            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 16 upper-case (uid:3184c052-d73b-4f18-a26c-8ddead59b61c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | la1234         |
      | destinationAirportId | {airport-id-my-1} |
      | originAirportId      | {airport-id-my-2} |
      | vendorId             | {vendor-id-my-1}    |
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
      | mawb        | MX1234567890123456            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @KillBrowser
  Scenario: Kill Browser
    Given no-op

