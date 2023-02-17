#https://studio.cucumber.io/projects/210778/test-plan/folders/2110424
@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateMAWB2
Feature: Update MAWB 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments
  Scenario: Update MAWB for MY with format 4 lower-case (uid:815a7993-d280-4b50-8085-0199c855cebc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    # Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | la3456            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 4 upper-case (uid:35ede1dd-60d5-41da-9cec-ab2fb4239870)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    # Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | LA3456            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 4 mix-case (uid:84b0de9c-c3cf-43a1-a1d2-89823aa9ed2c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    # Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | La3456            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 5 lower-case (uid:aa908859-d477-435f-b364-78ccf815bf9a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    # Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | la34567            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 5 upper-case (uid:cb4ba85d-8fa9-48d1-8a29-6fbf1e64c9c1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    # Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | LA34567            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 5 mix-case (uid:69ba1f69-2da6-4fb1-922a-b3f5abf118e5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    # Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | La34567            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 6 lower-case (uid:070d8bd3-fccd-45da-a606-e321fec8a07c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    # Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | la345678            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 6 upper-case (uid:f84f2939-653d-45fd-817e-e12de2fdc880)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    # Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | LA345678            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @DeleteShipments
  Scenario: Update MAWB for MY with format 6 mix-case (uid:b70b79b8-e9a1-4ecb-8bc2-8b4032e05aa3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = "{hub-id-my-1}" to hub id = "{hub-id-my-2}"
    # Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id-my-1} to hub id = {hub-id-my-2}
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 1 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click update MAWB button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update MAWB page UI
    When Operator update MAWB information on shipment weight dimension page with following data
      | mawb        | La345678            |
      | vendor      | {vendor-name-my-2}    |
      | origin      | {airport-name-my-2} |
      | destination | {airport-name-my-1} |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Shipment Weight Update MAWB page UI updated with new MAWB

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op

